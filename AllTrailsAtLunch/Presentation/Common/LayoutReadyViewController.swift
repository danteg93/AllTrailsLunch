//
//  LayoutReadyViewController.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/15/22.
//

import UIKit

class LayoutReadyViewController: UIViewController {
    
    private var viewsWereLaidOut = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !self.viewsWereLaidOut {
            self.viewsWereLaidOut = true
            DispatchQueue.main.async {
                self.viewIsReady()
            }
        }
    }
    
    func viewIsReady() { }
}
