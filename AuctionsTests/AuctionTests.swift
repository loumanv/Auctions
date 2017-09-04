//
//  AuctionTests.swift
//  AuctionsTests
//
//  Created by Billybatigol on 03/09/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import XCTest
@testable import Auctions

class AuctionTests: XCTestCase {
    
    var dictionary: [String: Any]?
    var auction: Auction?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dictionary = [
            "id":12,
            "title":"Herzog-Koelpin",
            "rate":0.07,
            "amount_cents":4000000,
            "term":36,
            "risk_band":"A",
            "close_time":"2017-09-11T03:28:02.552Z"
        ]
        auction = try? Auction(dictionary: dictionary!)
    }
    
    func testAuctionInitializationSucceeds() {
        XCTAssertNotNil(auction)
    }
    
    func testAuctionJsonParseSucceeds() {
        XCTAssertEqual(auction?.auctionId, "12")
        XCTAssertEqual(auction?.title, "Herzog-Koelpin")
        XCTAssertEqual(auction?.rate, 0.07)
        XCTAssertEqual(auction?.amountCents, 4000000)
        XCTAssertEqual(auction?.term, 36)
        XCTAssertEqual(auction?.riskBand, RiskBandType.a)
        XCTAssertEqual(Auction.dateFormatter.string(from: (auction?.closeTime)!), "2017-09-11T03:28:02.552Z")
    }
    
    func testCalculationOfEstimatedReturn() {
        XCTAssertEqual(auction?.calculateEstimatedReturn(bidAmount: 20.0), 20.8)
    }
}
