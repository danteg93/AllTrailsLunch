//
//  GooglePlacesRestCall.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/19/22.
//

import Foundation

class GooglePlacesRestCall: RestCall {
    
    var uniqueId: String = UUID().uuidString
    var baseURL: String = "https://maps.googleapis.com/maps/api/place/"
    var endpoint: String
    var url: String {
        return baseURL + endpoint + "/json"
    }
    var parameters: [String : AnyHashable]
    var requestType: RestRequestType
    var headers: [String: String]
    var retriesLeft: Int = 3
    var retryDelay: TimeInterval = 2.0
    var isReplaceable: Bool = false
    var request: Any?
    var completionHandler: RestCallCompletionHandler
    
    init(endpoint: String,
         requestType: RestRequestType,
         headers: [String: String] = [:],
         parameters: [String : AnyHashable] = [:],
         completionHandler: @escaping RestCallCompletionHandler) {
        self.completionHandler = completionHandler
        self.endpoint = endpoint
        self.parameters = parameters
        self.headers = headers
        self.requestType = requestType
    }
    
    func completeCall(statusCode: Int?, rawResponse: Data?, error: RestCallError?) {
        if let error = error {
            completionHandler(nil, error)
        } else if let data = rawResponse, let statusCode = statusCode {
            switch statusCode {
            case 200, 201:
                completionHandler(data, nil)
            case 400:
                completionHandler(nil, .badRequest)
            case 401:
                completionHandler(nil, .unauthorized)
            case 403:
                completionHandler(nil, .requestDeniedByServer)
            case 404:
                completionHandler(nil, .doesNotExist)
            case 409:
                completionHandler(nil, .conflictResponse)
            case 500...599:
                break
            default:
                break
            }
        }
    }
}
