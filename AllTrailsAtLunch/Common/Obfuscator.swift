//
//  Obfuscator.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/18/22.
//  Solution based on: https://gist.github.com/DejanEnspyra/80e259e3c9adf5e46632631b49cd1007
//

import UIKit

class Obfuscator {
  
  private var salt: String
  
  init(salt: String = "") {
    if salt.isEmpty {
      self.salt = "\(String(describing: Self.self))\(String(describing: NSObject.self))\(String(describing: UIApplicationDelegate.self))"
    } else {
      self.salt = salt
    }
  }
  
  func encrypt(_ string: String) -> [UInt8] {
    let byteString = [UInt8](string.utf8)
    let cipher = [UInt8](self.salt.utf8)
    var encryptedBytes = [UInt8]()
    for (offset, byte) in byteString.enumerated() {
      encryptedBytes.append(byte ^ cipher[offset % cipher.count])
    }
    return encryptedBytes
  }
  
  func decrypt(key: [UInt8]) -> String? {
    let cipher = [UInt8](self.salt.utf8)
    var decryptedBytes = [UInt8]()
    for (offset, byte) in key.enumerated() {
      decryptedBytes.append(byte ^ cipher[offset % cipher.count])
    }
    return String(bytes: decryptedBytes, encoding: .utf8)
  }
}
