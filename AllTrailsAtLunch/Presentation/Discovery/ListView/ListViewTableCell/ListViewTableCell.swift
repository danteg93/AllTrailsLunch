//
//  ListViewTableCell.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/19/22.
//

import Foundation
import UIKit

struct ListViewTableCellModel {
    let title: String
    let rating: Double
    let ratingCount: Int
    let supportText: String
}

class ListViewTableCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var supportLabel: UILabel!
    @IBOutlet private weak var ratingCountLabel: UILabel!
    
    @IBOutlet var starImageCollection: [UIImageView]!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30))
        contentView.layer.cornerRadius = 6.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setup(model: ListViewTableCellModel) {
        DispatchQueue.main.async {
            self.titleLabel.text = model.title
            self.supportLabel.text = model.supportText
            self.ratingCountLabel.text = "(\(model.ratingCount))"
            for imageIndex in 0..<5 {
                self.starImageCollection[imageIndex].tintColor = Double(imageIndex) < model.rating.rounded() ? .orange : .lightGray
            }
        }
    }
    
}
