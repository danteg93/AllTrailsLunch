//
//  UIButton+Extension.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/18/22.
//

import UIKit

extension UIButton {
    
    func alignTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing * 2, bottom: 0, right: spacing * 2)
    }
}
