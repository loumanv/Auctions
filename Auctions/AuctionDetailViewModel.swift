//
//  AuctionDetailViewModel.swift
//  Auctions
//
//  Created by Billybatigol on 04/09/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import UIKit

class AuctionDetailViewModel {
    
    var auction: Auction
    var title: String
    var riskBandString: String
    var closeTimeString: String
    var rateString: String
    var termString: String
    
    init(auction: Auction) {
        self.auction = auction
        
        title = auction.title
        riskBandString = auction.riskBand.rawValue
        closeTimeString = AuctionsViewModel.dateFormatter.string(from: auction.closeTime)
        rateString = String(auction.rate)
        termString = String(auction.term)
    }
    
    func calculateEstimatedReturn(bidAmount: Double) -> String {
        let estimatedReturn = auction.calculateEstimatedReturn(bidAmount: bidAmount)
        return String(estimatedReturn)
    }
}
