//
//  RestTransportManager.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/19/22.
//

import Foundation
import Alamofire

public enum RestRequestType: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

public enum RestCallError: Error {
    case noResponse
    case callReplaced
    case timedout
    case unknownError
    case transportFailure(_: Error?)
    case malformedURL
    case badRequest //400
    case unauthorized //401
    case requestDeniedByServer //403
    case doesNotExist //404
    case conflictResponse //409
    case serverError //500...599
}

protocol RestCall: AnyObject {
    typealias RestCallCompletionHandler = (_ rawResponse: Data?, _ error: RestCallError?) -> Void
    var uniqueId: String { get }
    var baseURL: String { get }
    var endpoint: String { get }
    var url: String { get }
    var parameters: [String: AnyHashable] { get set }
    var requestType: RestRequestType { get }
    var headers: [String: String] { get }
    func completeCall(statusCode: Int?, rawResponse: Data?, error: RestCallError?)
    var completionHandler: RestCallCompletionHandler { get set }
    var retriesLeft: Int { get set }
    var retryDelay: TimeInterval { get }
    var isReplaceable: Bool { get }
    var request: Any? { get set }
}

extension RestCall {
    /// Hash value used to figure out if the call is in progress.
    var hashValue: Int {
        get {
            let endpointHash = endpoint.hashValue
            let parametersHash  = parameters.hashValue
            return baseURL.hashValue ^ endpointHash &* 16777619 ^ parametersHash
        }
    }
    
    static func ==(lhs: RestCall, rhs: RestCall) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

/// REST Transport Manager. Accepts JSON Headers and Responses.
final class RestTransportManager<ApiCall: RestCall> {
    
    static func createAlamoFireSessionManager(timeout: TimeInterval = 30) -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeout
        configuration.timeoutIntervalForResource = timeout
        return Alamofire.Session(configuration: configuration)
    }
    
    private let sessionManager: Session
    
    init(sessionManager: Session = RestTransportManager.createAlamoFireSessionManager()) {
        self.sessionManager = sessionManager
    }
    
    // Enqueues call in a concurrent queue that ensures call with the same hash value are called serially. Hash value calculated from base url, port number, endpoint and parameters.
    func enqueueCall(_ apiCall: ApiCall) {
        self.enqueueCallAsync(apiCall)
    }
    
    /// Removes call from both in progress and enqueued dictionaries. Should be called upon failure/cancel only.
    func dequeueCall(_ apiCall: ApiCall) {
        concurrentCallQueue.async(flags: .barrier) {
            let callId: AnyHashable = apiCall.isReplaceable ? apiCall.hashValue : apiCall.uniqueId
            self.callsInProgress[callId] = nil
            self.enqueuedAPICalls[callId] = nil
        }
    }
    
    // MARK: Private
    /// Figures out if call with the same ID is still in progress. If it is, and the call is replaceable, send back and error.
    private func enqueueCallAsync(_ apiCall: ApiCall) {
        concurrentCallQueue.async(flags: .barrier) {
            let callId: AnyHashable = apiCall.isReplaceable ? apiCall.hashValue : apiCall.uniqueId
            var shouldMakeCall = false
            // If there is an existing call for this base url + endpoint + parameters combo, replace it and throw .callReplaced error
            if let enqueuedCall = self.enqueuedAPICalls[callId] {
                // Replaced enqueued call
                DispatchQueue.global().async { enqueuedCall.completeCall(statusCode: nil, rawResponse: nil, error: .callReplaced) }
                self.enqueuedAPICalls[callId] = apiCall
                // If there is a call with this hash in progress, store it in enqueued calls to be called after the previous call is completed.
            } else if self.callsInProgress[callId] != nil {
                self.enqueuedAPICalls[callId] = apiCall
                // If the call is not enqueued or in progress. Add it to calls in progress and proceed with call.
            } else {
                self.callsInProgress[callId] = apiCall
                shouldMakeCall = true
            }
            
            if shouldMakeCall {
                self.makeCall(apiCall, sessionManager: self.sessionManager)
            }
        }
    }
    
    /// Makes call through matching AlamoFire session manager.
    private func makeCall(_ apiCall: ApiCall, sessionManager: Session) {
        concurrentCallQueue.async {
            // No URL no call
            guard let url = URL(string: apiCall.url) else {
                apiCall.completeCall(statusCode: nil, rawResponse: nil, error: .malformedURL)
                return
            }
            
            // Prepare headers with auth token
            var headers: HTTPHeaders = [:]
            if !apiCall.headers.isEmpty {
                apiCall.headers.forEach { headers[$0] = $1 }
            }
            
            // Prepare parameters
            let parameters: Alamofire.Parameters = apiCall.parameters
            
            // Prepare request type / HTTP method
            var requestType: HTTPMethod
            var encoding: ParameterEncoding
            switch apiCall.requestType {
            case .get:
                requestType = HTTPMethod.get
                encoding = URLEncoding.default
            case .post:
                requestType = HTTPMethod.post
                encoding = JSONEncoding.default
            case .patch:
                requestType = HTTPMethod.patch
                encoding = JSONEncoding.default
            case .put:
                requestType = HTTPMethod.put
                encoding = JSONEncoding.default
            case .delete:
                requestType = HTTPMethod.delete
                encoding = JSONEncoding.default
            }
            
            // Make call
            let request = sessionManager.request(url, method: requestType, parameters: parameters, encoding: encoding, headers: headers)
            // Pointer to this request in APICall object to stop it from going out of scope and getting cancelled.
            apiCall.request = request
            request.responseData(completionHandler: { [weak self, apiCall] (response) in
                switch response.result {
                case .success(let data):
                    apiCall.completeCall(statusCode: request.response?.statusCode, rawResponse: data, error: nil)
                    self?.dequeueNextMatchingCall(apiCall)
                case .failure(let error):
                    // Got an error. Will retry call.
                    if apiCall.retriesLeft > 0 {
                        self?.dequeueCall(apiCall)
                        self?.retryCall(apiCall)
                        return
                    }
                    // All retries exausted.
                    apiCall.completeCall(statusCode: nil, rawResponse: response.data, error: RestCallError.transportFailure(error))
                    self?.dequeueCall(apiCall)
                    return
                }
            })
        }
    }
    
    /// Removes provided call from calls in progress and checks if there is another call with the same hash in the enqueuedAPICalls dictionary.
    private func dequeueNextMatchingCall(_ apiCall: ApiCall) {
        guard apiCall.isReplaceable else {
            dequeueCall(apiCall)
            return
        }
        concurrentCallQueue.async(flags: .barrier) {
            var nextCallMatchingHash: ApiCall?
            nextCallMatchingHash = self.enqueuedAPICalls.removeValue(forKey: apiCall.hashValue)
            self.callsInProgress[apiCall.hashValue] = nextCallMatchingHash
            if let nextCallMatchingHash = nextCallMatchingHash {
                self.makeCall(nextCallMatchingHash, sessionManager: self.sessionManager)
            }
        }
    }
    
    /// Retries the call after its stored delay
    private func retryCall(_ apiCall: ApiCall) {
        apiCall.retriesLeft -= 1
        let delay = apiCall.retryDelay
        
        concurrentCallQueue.asyncAfter(deadline: DispatchTime.now() + delay, execute: { [apiCall] in
            self.enqueueCallAsync(apiCall)
        })
    }
    
    /// Queue to make calls
    private var concurrentCallQueue: DispatchQueue = DispatchQueue(label: "com.ConcurrentCallQueue.RESTransportManager", qos: .userInitiated, attributes: DispatchQueue.Attributes.concurrent)
    /// Holds call if there is another call with the same hash in progress.
    private var enqueuedAPICalls = [AnyHashable: ApiCall]()
    /// Holds current call in progress for that call's hash.
    private var callsInProgress = [AnyHashable: ApiCall]()
}
