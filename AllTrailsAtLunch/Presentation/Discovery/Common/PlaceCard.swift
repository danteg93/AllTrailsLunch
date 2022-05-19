//
//  PlaceCard.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/19/22.
//

import UIKit

struct PlaceCardModel {
    let titleLabel: String
}
class PlaceCard: UIView {
    
    enum Constants {
        static let nibName = "PlaceCard"
    }
        
    @IBOutlet var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var model: PlaceCardModel?
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("hm")
        self.initializeView()
    }
    
    convenience init(frame: CGRect, model: PlaceCardModel) {
        self.init(frame: frame)
        self.model = model
        self.updateView()
    }
    
    private func initializeView() {
        Bundle.main.loadNibNamed(Constants.nibName, owner: self, options: nil)
        self.addSubview(view)
        view.frame = self.bounds
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.isOpaque = false
    }
    
    private func updateView() {
        DispatchQueue.main.async {
            self.titleLabel.text = self.model?.titleLabel
        }
    }
}
