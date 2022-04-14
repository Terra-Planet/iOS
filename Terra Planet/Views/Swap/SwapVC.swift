//
//  SwapVC.swift
//  Terra Planet
//
//  Created by f0go on 24/03/2022.
//

import Foundation
import UIKit

class SwapVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var fromLogo: UIImageView!
    @IBOutlet weak var fromCoinName: UILabel!
    @IBOutlet weak var toLogo: UIImageView!
    @IBOutlet weak var toCoinName: UILabel!
    @IBOutlet weak var fromAmount: UITextField!
    @IBOutlet weak var toAmount: UITextField!
    @IBOutlet weak var swapButton: UIButton!
    
    var from = "uluna"
    var to = "uusd"
    
    let loading = UIAlertController(title: "Loading", message: "Please wait...", preferredStyle: .alert)
    
    override func viewDidLoad() {
        design()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "0" {
            textField.text = ""
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        calculateLiveSwap(textField: textField)
        if let wallet = API.shared.wallet {
            if let balance = wallet.coins[from]?.amount, let amount = fromAmount.text, let wantSend = Double(amount), wantSend > balance {
                textField.textColor = .red
                swapButton.isEnabled = false
            }
            else {
                textField.textColor = .label
                swapButton.isEnabled = true
            }
        }
    }
    
    @IBAction func switchCoins(_ sender: UIButton) {
        flip()
    }
    
    @IBAction func swap(_ sender: UIButton) {
        swapPreview()
    }
    
    private func swapPreview() {
        present(self.loading, animated: true)
        swapPreview { preview, errorMessage in
            self.loading.dismiss(animated: true) {
                if let preview = preview {
                    self.showPreview(preview: preview)
                }
                else if let errorMessage = errorMessage {
                    self.showError(message: errorMessage)
                }
            }
        }
    }
    
    private func showPreview(preview: PreviewTX) {
        if let fromAmount = fromAmount.text, let amountToDouble = Double(fromAmount) {
            if preview.fee.coin == "uluna" {
                if let lunaBalance = API.shared.wallet?.coins["uluna"]?.amount {
                    var totalAmount = preview.fee.amount.legibleAmount()
                    if fromCoinName.text == "LUNA" {
                        totalAmount += amountToDouble
                    }
                    if totalAmount > lunaBalance {
                        return notEnoughFee(switchTo: .ust)
                    }
                }
                else {
                    return notEnoughFee(switchTo: .ust)
                }
            }
            else {
                if let ustBalance = API.shared.wallet?.coins["uusd"]?.amount {
                    var totalAmount = preview.fee.amount.legibleAmount()
                    if fromCoinName.text == "UST" {
                        totalAmount += amountToDouble
                    }
                    if totalAmount > ustBalance {
                        return notEnoughFee(switchTo: .luna)
                    }
                }
                else {
                    return notEnoughFee(switchTo: .luna)
                }
            }
        }
        
        var alertText = "From: \(preview.from.coinCode2Name())\nTo: \(preview.to.coinCode2Name())\n\nAmount:\(preview.amount.legibleAmount())\n\nFee: \(preview.fee.amount.legibleAmount()) \(preview.fee.coin.coinCode2Name())"
        if API.shared.gasFee == .luna {
            alertText += " ($\(preview.fee.usdFee().double2String()) usd)"
        }
        let alert = UIAlertController(title: "SWAP", message: alertText, preferredStyle: .alert)
        let yes = UIAlertAction(title: "Sign it!", style: .default) { _ in
            self.present(self.loading, animated: true)
            self.swap { error in
                self.loading.dismiss(animated: true)
                if let err = error {
                    self.showError(message: err)
                }
                else {
                    Utils.shared.events.trigger("reloadBalance")
                    self.dismiss(animated: true)
                }
            }
        }
        alert.addAction(yes)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    private func notEnoughFee(switchTo: FeeCoin) {
        var currentCoinName = "LUNA"
        var newCoinName = "UST"
        if switchTo == .luna {
            currentCoinName = "UST"
            newCoinName = "LUNA"
        }

        let alert = UIAlertController(title: "Not enough \(currentCoinName) for fees", message: "Do you want switch fees to \(newCoinName)?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default) { _ in
            API.shared.savePreferredGasFeeCoin(coin: switchTo)
            self.swapPreview()
        }
        alert.addAction(yes)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func design() {
        fromView.blueBorderLine()
        toView.blueBorderLine()
    }
}
