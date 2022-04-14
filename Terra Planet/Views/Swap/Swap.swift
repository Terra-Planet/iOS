//
//  Swap.swift
//  Terra Planet
//
//  Created by f0go on 24/03/2022.
//

import Foundation
import UIKit

extension SwapVC {

    func calculateLiveSwap(textField: UITextField) {
        if var text = textField.text {
            text = text.replacingOccurrences(of: ",", with: ".")
            textField.text = text
            if let double = Double(text) {
                if textField == fromAmount {
                    if from == "uluna" {
                        toAmount.text = "\((double * API.shared.lunaPrice).double2String())"
                    }
                    else {
                        toAmount.text = "\((double / API.shared.lunaPrice))"
                    }
                }
                else {
                    if from == "uluna" {
                        fromAmount.text = "\((double / API.shared.lunaPrice))"
                    }
                    else {
                        fromAmount.text = "\((double * API.shared.lunaPrice).double2String())"
                    }
                }
            }
        }
    }
    
    func flip() {
        fromAmount.resignFirstResponder()
        toAmount.resignFirstResponder()
        fromAmount.text = "0"
        toAmount.text = "0"
        if from == "uluna" {
            from = "uusd"
            to = "uluna"
            fromLogo.image = UIImage(named: "uusd")
            toLogo.image = UIImage(named: "uluna")
            fromCoinName.text = "UST"
            toCoinName.text = "LUNA"
        }
        else {
            from = "uluna"
            to = "uusd"
            fromLogo.image = UIImage(named: "uluna")
            toLogo.image = UIImage(named: "uusd")
            fromCoinName.text = "LUNA"
            toCoinName.text = "UST"
        }
    }
    
    func swapPreview(callback: @escaping (_ preview: PreviewTX?,_ errorMessage: String?) -> Void) {
        if let amount = fromAmount.text {
            API.shared.swapPreview(from: from, to: to, amount: amount) { preview, error in
                callback(preview, error)
            }
        }
    }
    
    func swap(callback: @escaping (_ errorMessage: String?) -> Void) {
        if let amount = fromAmount.text {
            API.shared.swap(from: from, to: to, amount: amount) { error in
                callback(error)
            }
        }
    }
}
