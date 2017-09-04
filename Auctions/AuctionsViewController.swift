//
//  AuctionsViewController.swift
//  Auctions
//
//  Created by Billybatigol on 03/09/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import UIKit

protocol AuctionsViewControllerOutput {
    func didSelectRowAction(sender: UIViewController, selectedAuction: Auction)
}

class AuctionsViewController: UIViewController {
    
    var viewModel: AuctionsViewModel
    var controllerOutput: AuctionsViewControllerOutput?
    
    @IBOutlet weak var table: UITableView! {
        didSet {
            table.estimatedRowHeight = 44
            table.rowHeight = UITableViewAutomaticDimension
            
            table.register(UINib(nibName: String(describing: AuctionCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AuctionCell.self))
        }
    }
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
    
    init(viewModel: AuctionsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: AuctionsViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.controllerOutput = self
        table.delegate = self
        table.dataSource = self
        addNavigationItems()
    }
    
    func reload() {
        viewModel.loadAuctions()
    }
    
    func addNavigationItems() {
        let activityBarButton = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem  = activityBarButton
        activityIndicator.startAnimating()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reload", style: .plain, target: self, action: #selector(reload))
    }
    
    func showErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension AuctionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = AuctionSection(rawValue: section) else { return "" }
        return section.sectionTitle()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.auctions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: String(describing: AuctionCell.self), for: indexPath) as? AuctionCell else { return UITableViewCell() }
        cell.titleLabel.text = viewModel.auctionTitleFor(row: indexPath.row)
        cell.closeTimeLabel.text = viewModel.auctionCloseTimeFor(row: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let auctions = viewModel.auctions else { return }
        controllerOutput?.didSelectRowAction(sender: self, selectedAuction:  auctions[indexPath.row])
    }
}

extension AuctionsViewController: AuctionsViewModelOutput {
    func auctionsFetched() {
        table.reloadData()
    }
    
    func handle(error: Error) {
        showErrorMessage(title: "An Error Occurred", message: error.localizedDescription)
    }
    
    func isPerformingRequest(_ isPerformingRequest: Bool) {
        isPerformingRequest ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}
