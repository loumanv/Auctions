//
//  AuctionDetailViewController.swift
//  Auctions
//
//  Created by Billybatigol on 04/09/2017.
//  Copyright © 2017 Vasileios Loumanis. All rights reserved.
//

import UIKit

class AuctionDetailViewController: UIViewController {
    
    var viewModel: AuctionDetailViewModel
    
    @IBOutlet weak var bidAmountTextField: UITextField!
    @IBOutlet weak var estimatedReturnLabel: UILabel!
    @IBOutlet weak var riskBandLabel: UILabel!
    @IBOutlet weak var closeTimeLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var termLabel: UILabel!
    
    init(viewModel: AuctionDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: AuctionDetailViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
        riskBandLabel.text = viewModel.riskBandString
        closeTimeLabel.text = viewModel.closeTimeString
        rateLabel.text = viewModel.rateString
        termLabel.text = viewModel.termString
        
        bidAmountTextField.delegate = self
    }
    @IBAction func calculateButtonPressed(_ sender: Any) {
        guard let bidAmountText = bidAmountTextField.text, let bidAmount = Double(bidAmountText) else { return }
        estimatedReturnLabel.text = viewModel.calculateEstimatedReturn(bidAmount: bidAmount)
    }
}

extension AuctionDetailViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let bidAmountText = textField.text, let bidAmount = Double(bidAmountText) else { return false }
        estimatedReturnLabel.text = viewModel.calculateEstimatedReturn(bidAmount: bidAmount)
        return true
    }
}
