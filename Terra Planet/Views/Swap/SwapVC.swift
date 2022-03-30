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
        let loading = UIAlertController(title: "Loading", message: "Please wait...", preferredStyle: .alert)
        present(loading, animated: true)
        swap { status in
            Utils.shared.events.trigger("reloadBalance")
            loading.dismiss(animated: true)
            self.dismiss(animated: true)
        }
    }
    
    func design() {
        fromView.blueBorderLine()
        toView.blueBorderLine()
    }
}
