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
    }
    
    @IBAction func switchCoins(_ sender: UIButton) {
        flip()
    }
    
    @IBAction func swap(_ sender: UIButton) {
        present(self.loading, animated: true)
        swapPreview { preview in
            self.loading.dismiss(animated: true) {
                if let preview = preview {
                    self.showPreview(preview: preview)
                }
            }
        }
    }
    
    private func showPreview(preview: PreviewTX) {
        var alertText = "From: \(preview.from.coinCode2Name())\nTo: \(preview.to.coinCode2Name())\n\nAmount:\(preview.amount.legibleAmount())\n\nFee: \(preview.fee.amount.legibleAmount()) \(preview.fee.coin.coinCode2Name())"
        if API.shared.gasFee == .luna {
            alertText += " ($\(preview.fee.usdFee().double2String()) usd)"
        }
        let alert = UIAlertController(title: "SWAP", message: alertText, preferredStyle: .alert)
        let yes = UIAlertAction(title: "Sign it!", style: .default) { _ in
            self.present(self.loading, animated: true)
            self.swap { status in
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
        fromView.blueBorderLine()
        toView.blueBorderLine()
    }
}
