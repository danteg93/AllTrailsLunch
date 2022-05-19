//
//  DiscoveryViewController.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/18/22.
//

import UIKit

class DiscoveryViewController: LayoutReadyViewController {
    
    private enum Constants {
        static let listButtonTitle = "List".localized
        static let mapButtonTitle = "Map".localized
        static let listImage = UIImage(systemName: "list.bullet")
        static let mapImage = UIImage(systemName: "map.circle")
    }
    
    @IBOutlet private weak var viewContainer: UIView!
    @IBOutlet private weak var modeSwitchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modeSwitchButton.setImage(Constants.listImage, for: .normal)
        self.modeSwitchButton.setTitle(Constants.listButtonTitle, for: .normal)
        self.modeSwitchButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        self.modeSwitchButton.alignTextAndImage(spacing: 10)
    }
}
