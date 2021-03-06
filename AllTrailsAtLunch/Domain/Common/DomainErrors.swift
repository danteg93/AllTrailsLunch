//
//  DomainErrors.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/18/22.
//

import Foundation

protocol LocalizedDomainError: Error {
    var localizedDescription: String { get }
}


enum LocationError: LocalizedDomainError {
    case domainError
    
    var localizedDescription: String {
        switch self {
        case .domainError:
            return "Something went wrong, please try again".localized
        }
    }
}

enum PlacesError: LocalizedDomainError {
    case dataSourceError
    
    var localizedDescription: String {
        switch self {
        case .dataSourceError:
            return "Server unreachable, please try again later".localized
        }
    }
}
