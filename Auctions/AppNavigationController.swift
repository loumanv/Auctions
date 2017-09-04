//
//  AppNavigationController.swift
//  Auctions
//
//  Created by Billybatigol on 03/09/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import UIKit

class AppNavigationController {
    
    static let sharedInstance = AppNavigationController()

    lazy var navigationController: UINavigationController = {
        let auctionsVC = AuctionsViewController(viewModel: AuctionsViewModel())
        auctionsVC.controllerOutput = self
        return UINavigationController(rootViewController: auctionsVC)
    }()
}

extension AppNavigationController: AuctionsViewControllerOutput {
    func didSelectRowAction(sender: UIViewController, selectedAuction: Auction) {
        let auctionDetailVC = AuctionDetailViewController(viewModel: AuctionDetailViewModel(auction: selectedAuction))
        navigationController.pushViewController(auctionDetailVC, animated: true)
    }
}
