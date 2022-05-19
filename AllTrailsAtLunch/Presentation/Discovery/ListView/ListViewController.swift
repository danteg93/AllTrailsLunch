//
//  ListViewController.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/18/22.
//

import Foundation
import UIKit

class ListViewController: LayoutReadyViewController {
    
    enum Constants {
        static let listCellIdentifier = "ListTableViewCell"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: Constants.listCellIdentifier, bundle: nil), forCellReuseIdentifier: Constants.listCellIdentifier)
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.listCellIdentifier, for: indexPath)
        if let listCell = cell as? ListTableViewCell {
            let model = PlaceCardModel(titleLabel: "\(indexPath.row)")
            listCell.setup(model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
}
