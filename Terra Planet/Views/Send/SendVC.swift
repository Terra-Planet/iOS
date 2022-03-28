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
            let loading = UIAlertController(title: "Loading", message: "Please wait...", preferredStyle: .alert)
            present(loading, animated: true)
            sendCoin(coin: coin, amount: amount, address: address) { status in
                Utils.shared.events.trigger("reloadBalance")
                loading.dismiss(animated: true)
                self.dismiss(animated: true)
            }
        }
        
    }
    
    private func design() {
        coinView.layer.borderWidth = 2
        coinView.layer.borderColor = UIColor(named: "color_blue")?.cgColor
    }
}
