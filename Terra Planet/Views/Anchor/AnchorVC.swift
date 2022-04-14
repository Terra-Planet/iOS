//
//  AnchorVC.swift
//  Terra Planet
//
//  Created by f0go on 25/03/2022.
//

import Foundation
import UIKit

class AnchorVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var suggest: UILabel!
    
    var anchorAction: AnchorActions = .deposit
    var accountBalance: Double = 0
    
    override func viewDidLoad() {
        design()
        switchAction(action: anchorAction)
    }
    
    @IBAction func switchAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            switchAction(action: .deposit)
        }
        else {
            switchAction(action: .withdraw)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "0" {
            textField.text = ""
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if var text = textField.text {
            text = text.replacingOccurrences(of: ",", with: ".")
            textField.text = text
        }
    }
    
    @IBAction func setMax(_ sender: UIButton) {
        if accountBalance > 2 {
            amount.text = "\(accountBalance - 2)"
            amount.resignFirstResponder()
        }
    }
    
    @IBAction func action(_ sender: UIButton) {
        amount.resignFirstResponder()
        if let amount = amount.text {
            let loading = UIAlertController(title: "Loading", message: "Please wait...", preferredStyle: .alert)
            present(loading, animated: true)
            anchor(action: anchorAction, amount: amount) { status in
                Utils.shared.events.trigger("reloadBalance")
                loading.dismiss(animated: true)
                self.dismiss(animated: true)
            }
        }
    }
    
    func design() {
        amountView.blueBorderLine()
    }
    
    func switchAction(action: AnchorActions) {
        amount.text = "0"
        amount.resignFirstResponder()
        anchorAction = action
        if anchorAction == .deposit {
            segment.selectedSegmentIndex = 0
            suggest.isHidden = false
            actionButton.setTitle("DEPOSIT", for: .normal)
            if let wallet = API.shared.wallet, let coin = wallet.coins["uusd"] {
                accountBalance = coin.amount
            }
            else {
                accountBalance = 0
            }
        }
        else {
            segment.selectedSegmentIndex = 1
            actionButton.setTitle("WITHDRAW", for: .normal)
            suggest.isHidden = true
            if let wallet = API.shared.wallet, let coin = wallet.coins["anchor"] {
                accountBalance = coin.amount
            }
            else {
                accountBalance = 0
            }
        }
        self.balance.text = "Balance: \(accountBalance)"
    }
}
