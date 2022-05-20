//
//  String+Extension.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/18/22.
//

import Foundation

// MARK: - Helper types
extension String {
  var localized: String {
    return NSLocalizedString(self, comment: "")
  }
}
