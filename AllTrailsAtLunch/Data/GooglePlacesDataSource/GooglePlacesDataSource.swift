//
//  GooglePlacesDataSource.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/18/22.
//

import Foundation


class GooglePlacesDataSource {
    
    typealias ApiCall = GooglePlacesRestCall
    typealias ApiResponse = (Data?, RestCallError?) -> Void
    
    enum Endpoint {
        static let nearbySearch = "nearbysearch"
    }
    
    enum Constants {
        static let apiKey: [UInt8] = [14, 43, 28, 20, 32, 26, 37, 1, 10, 45, 29, 101, 59, 91, 19, 7, 11, 43, 27, 56, 32, 21, 63, 38, 45, 8, 19, 69, 34, 44, 87, 37, 87, 21, 6, 50, 56, 1, 32]
    }
    
    private let restTransport: RestTransportManager<ApiCall>
    
    // MARK: - Singleton Setup
    static let shared = GooglePlacesDataSource()
    // MARK: - Initializer
    init(restTransport: RestTransportManager<ApiCall> = RestTransportManager<ApiCall>()) {
      self.restTransport = restTransport
    }
    
    func findNearbyRestaurants(latitude: Double,
                               longitude: Double,
                               keyword: String? = nil,
                               completion: @escaping ApiResponse) {
        
        var parameters: [String: AnyHashable] = ["key": Obfuscator().decrypt(key: Constants.apiKey),
                                                 "location": "\(latitude),\(longitude)",
                                                 "rankby": "distance",
                                                 "type": "restaurant"]
        if let keyword = keyword {
            parameters["keyword"] = keyword
        }
        let apiCall = ApiCall(endpoint: Endpoint.nearbySearch,
                              requestType: .get,
                              parameters: parameters) { [completion] (dataResponse, error) in
            completion(dataResponse, error)
        }
        self.restTransport.enqueueCall(apiCall)
    }
}
