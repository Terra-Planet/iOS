//
//  SendVC.swift
//  Terra Planet
//
//  Created by f0go on 24/03/2022.
//

import Foundation
import UIKit

class SendVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var coinView: UIView!
    @IBOutlet weak var coinLogo: UIImageView!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var coinBalance: UILabel!
    
    var coin = "uluna"
    var balance: Double = 0
    
    let loading = UIAlertController(title: "Loading", message: "Please wait...", preferredStyle: .alert)
    
    override func viewDidLoad() {
        design()
        setCoin(coin: "uluna")
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if var text = textField.text {
            text = text.replacingOccurrences(of: ",", with: ".")
            textField.text = text
        }
    }
    
    @IBAction func pasteAddress(_ sender: UIButton) {
        address.text = UIPasteboard.general.string
    }
    
    @IBAction func scanAddress(_ sender: UIButton) {
        let vc = UIStoryboard(name: "QR", bundle: nil).instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
        vc.callback = {(address) in
            self.address.text = address
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func selectCoin(_ sender: UIButton) {
        selectCoin()
    }
    
    @IBAction func sendAll(_ sender: UIButton) {
        amount.text = "\(balance)"
    }
    
    @IBAction func send(_ sender: UIButton) {
        if let amount = amount.text, let address = address.text {
            present(loading, animated: true)
            sendCoinPreview(coin: coin, amount: amount, address: address) { preview in
                self.loading.dismiss(animated: true) {
                    if let preview = preview {
                        self.showPreview(preview: preview)
                    }
                }
            }
        }
    }
    
    private func showPreview(preview: PreviewTX) {
        var alertText = "From: \(preview.from.coinCode2Name())\n\nTo: \(preview.to.coinCode2Name())\n\nAmount:\(preview.amount)\n\nFee: \(preview.fee.amount.legibleAmount()) \(preview.fee.coin.coinCode2Name())"
        if API.shared.gasFee == .luna {
            alertText += " ($\(preview.fee.usdFee().double2String()) usd)"
        }
        let alert = UIAlertController(title: "SEND", message: alertText, preferredStyle: .alert)
        let yes = UIAlertAction(title: "Sign it!", style: .default) { _ in
            self.present(self.loading, animated: true)
            self.sendCoin(coin: self.coin, amount: self.amount.text!, address: self.address.text!) { status in
                Utils.shared.events.trigger("reloadBalance")
                self.loading.dismiss(animated: true)
                self.dismiss(animated: true)
            }
        }
        alert.addAction(yes)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func design() {
        coinView.blueBorderLine()
    }
}
