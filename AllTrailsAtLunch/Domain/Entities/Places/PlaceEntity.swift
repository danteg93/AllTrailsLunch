//
//  PlaceEntity.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/19/22.
//

import Foundation
import CoreLocation

struct PlaceEntity: Decodable {
    
    struct Location: Decodable {
        let lat: Double
        let lng: Double
    }
    
    struct Geometry: Decodable {
        let location: Location
    }
    
    let name: String?
    let geometry: Geometry?
    let rating: Double?
    let priceLevel: Int?
    let vicinity: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case geometry
        case rating
        case price_level
        case vicinity
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try? values.decode(String.self, forKey: .name)
        self.geometry = try? values.decode(Geometry.self, forKey: .geometry)
        self.rating = try? values.decode(Double.self, forKey: .rating)
        self.priceLevel = try? values.decode(Int.self, forKey: .price_level)
        self.vicinity = try? values.decode(String.self, forKey: .vicinity)
    }
}
