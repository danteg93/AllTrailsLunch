//
//  ListViewController.swift
//  AllTrailsAtLunch
//
//  Created by Dante Garcia on 5/18/22.
//

import Foundation
import UIKit

protocol ListViewControllerDelegate: AnyObject {
    func placeTapped(placeIdSelected: String)
}

class ListViewController: LayoutReadyViewController, Displayable {
        
    typealias State = ListViewState
    typealias Presenter = ListViewPresenter
    
    enum Constants {
        static let listCellIdentifier = "ListViewTableCell"
        static let tableBottomInset: CGFloat = 85.0
        static let cellHeight: CGFloat = 150.0
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    var presenter: ListViewPresenter?
    
    weak var delegate: ListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createPresenter()
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.register(UINib(nibName: Constants.listCellIdentifier, bundle: nil), forCellReuseIdentifier: Constants.listCellIdentifier)
    }
    
    override func viewIsReady() {
        super.viewIsReady()
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constants.tableBottomInset, right: 0)
        self.presenter?.setup()
    }
    
    func display(_ displayableState: DisplayableState) {
        switch displayableState {
        case .stateNotRequested:
            break
        case .empty:
            break
        case .loading:
            break
        case .error:
            break
        case .populated:
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presenter?.viewModel.places.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.listCellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        if let listCell = cell as? ListViewTableCell, let place = self.presenter?.viewModel.places[indexPath.row] {
            let model = ListViewTableCellModel(title: place.name ?? "",
                                               placeId: place.placeId ?? "")
            listCell.setup(model: model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let placeId = self.presenter?.viewModel.places[indexPath.row].placeId else { return }
        self.delegate?.placeTapped(placeIdSelected: placeId)
    }
    
}
