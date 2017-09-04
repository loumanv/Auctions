//
//  AuctionsViewModel.swift
//  Auctions
//
//  Created by Billybatigol on 03/09/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import UIKit

protocol AuctionsViewModelOutput {
    func auctionsFetched()
    func handle(error: Error)
    func isPerformingRequest(_: Bool)
}

enum AuctionSection: Int {
    case auctions
    static let count = 1
    
    static let sectionTitles = [
        auctions: "Auctions"
    ]
    
    func sectionTitle() -> String {
        if let sectionTitle = AuctionSection.sectionTitles[self] {
            return sectionTitle
        } else {
            return ""
        }
    }
}

class AuctionsViewModel {
    
    var auctions: [Auction]?
    var controllerOutput: AuctionsViewModelOutput?
    let networkClient = NetworkClient.shared
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter
    }()
    
    init() {
        loadAuctions()
    }
    
    func loadAuctions() {
        controllerOutput?.isPerformingRequest(true)
        guard let url = URL(string: Urls.baseUrl + Urls.auctionsUrl) else { return }
        networkClient.load(url: url) { [weak self] (data, error) in
            
            self?.controllerOutput?.isPerformingRequest(false)
            guard error == nil,
                  let data = data,
                  let json = data as? [String: Any] else {
                    if let error = error {
                        self?.controllerOutput?.handle(error: error)
                    } else {
                        self?.controllerOutput?.handle(error: ResponseError.jsonResponseEmpty)
                    }
                self?.controllerOutput?.handle(error: ResponseError.jsonResponseEmpty)
                return
            }
            
            let auctions = try? Auction.parseAuctions(json: json)
            self?.auctions = auctions
            self?.controllerOutput?.auctionsFetched()
        }
    }
    
    func auctionTitleFor(row: Int) -> String {
        guard let auction = auctions?[row] else { return ""}
        return auction.title
    }
    
    func auctionCloseTimeFor(row: Int) -> String {
        guard let auction = auctions?[row] else { return ""}
        return AuctionsViewModel.dateFormatter.string(from: auction.closeTime)
    }
}
