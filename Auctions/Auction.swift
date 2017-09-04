//
//  Auction.swift
//  Auctions
//
//  Created by Billybatigol on 03/09/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import Foundation

enum AuctionError: LocalizedError {
    case missingId
    case missingTitle
    case missingRate
    case missingAmountCents
    case missingTerm
    case missingRiskBand
    case missingCloseTime
}

enum RiskBandType: String {
    case aPlus = "A+"
    case a = "A"
    case b = "B"
    case c = "C"
    case cMinus = "C-"
}

class Auction {
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter
    }()
    
    var auctionId: String
    var title: String
    var rate: Double
    var amountCents: Int
    var term: Int
    var riskBand: RiskBandType
    var closeTime: Date
    
    let fee = 0.01
    var estimatedBadDebt: Double {
        switch riskBand {
        case .aPlus:
            return 0.01
        case .a:
            return 0.02
        case .b:
            return 0.03
        case .c:
            return 0.04
        case .cMinus:
            return 0.05
        }
    }

    init(dictionary: [String: Any]) throws {
        
        guard let auctionId = dictionary["id"] as? Int else { throw AuctionError.missingId}
        guard let title = dictionary["title"] as? String else { throw AuctionError.missingTitle}
        guard let rate = dictionary["rate"] as? Double else { throw AuctionError.missingRate}
        guard let amountCents = dictionary["amount_cents"] as? Int else { throw AuctionError.missingAmountCents}
        guard let term = dictionary["term"] as? Int else { throw AuctionError.missingTerm}
        guard let riskBandString = dictionary["risk_band"] as? String, let riskBand = RiskBandType(rawValue: riskBandString) else { throw AuctionError.missingRiskBand}
        guard let closeTimeString = dictionary["close_time"] as? String, let closeTime = Auction.dateFormatter.date(from: closeTimeString) else { throw AuctionError.missingCloseTime}
        
        self.auctionId = "\(auctionId)"
        self.title = title
        self.rate = rate
        self.amountCents = amountCents
        self.term = term
        self.riskBand = riskBand
        self.closeTime = closeTime
    }
    
    func calculateEstimatedReturn(bidAmount: Double) -> Double {
        let era = (1 + rate - estimatedBadDebt - fee) * bidAmount
        return era
    }
}

extension Auction {
    static let jsonKey = "items"

    static func parseAuctions(json: [String: Any]) throws -> [Auction] {
        let auctions: [Auction] = {
            if let auctionsArray = json[jsonKey] as? [Any] {
                return auctionsArray.flatMap { auctionDictionary in
                    guard let auctionDictionary = auctionDictionary as? [String : Any] else { return nil }
                    return try? Auction(dictionary: auctionDictionary) }
            }
            return [Auction]()
        }()
        return auctions
    }
}
