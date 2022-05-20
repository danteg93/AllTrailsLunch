//
//  AdditionalDetailsEntity.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/19/22.
//

import Foundation

struct AdditionalDetailsEntity: Decodable {
    
    struct OpeningHours: Decodable {
        let open_now: Bool?
        let weekday_text: [String]?
    }
    
    let address: String?
    let phoneNumber: String?
    let openingHours: OpeningHours?
    let website: String?
    
    enum CodingKeys: String, CodingKey {
        case formatted_address
        case formatted_phone_number
        case opening_hours
        case website
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.address = try? values.decode(String.self, forKey: .formatted_address)
        self.phoneNumber = try? values.decode(String.self, forKey: .formatted_phone_number)
        self.openingHours = try? values.decode(OpeningHours.self, forKey: .opening_hours)
        self.website = try? values.decode(String.self, forKey: .website)
    }
    
}
