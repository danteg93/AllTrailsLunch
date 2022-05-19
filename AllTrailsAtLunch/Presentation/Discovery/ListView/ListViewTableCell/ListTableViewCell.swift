//
//  ListTableViewCell.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/19/22.
//

import UIKit


class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placesCardView: UIView!
    
    var model: PlaceCardModel?
    
    func setup(_ model: PlaceCardModel) {
        self.layoutIfNeeded()
        self.model = model
        let frame = self.placesCardView.bounds
        self.placesCardView.addSubview(PlaceCard(frame: frame, model: model))
    }
    
    override func prepareForReuse() {
        self.model = nil
    }
    
}
