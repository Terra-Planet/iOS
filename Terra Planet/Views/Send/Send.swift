//
//  Send.swift
//  Terra Planet
//
//  Created by f0go on 24/03/2022.
//

import Foundation
import UIKit

extension SendVC {
    func selectCoin() {
        let alert = UIAlertController(title: "Select Coin", message: nil, preferredStyle: .actionSheet)
        let luna = UIAlertAction(title: "LUNA", style: .default) { _ in
            self.setCoin(coin: "uluna")
        }
        alert.addAction(luna)
        let ust = UIAlertAction(title: "UST", style: .default) { _ in
            self.setCoin(coin: "uusd")
        }
        alert.addAction(ust)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func setCoin(coin: String) {
        switch coin {
        case "uluna":
            self.coinName.text = "LUNA"
        default:
            self.coinName.text = "UST"
        }
        if let wallet = API.shared.wallet, let coin = wallet.coins[coin] {
            self.balance = coin.amount
        }
        else {
            self.balance = 0
        }
        self.coinLogo.image = UIImage(named: coin)
        self.coinBalance.text = "Balance: \(self.balance)"
        self.coin = coin
        self.amount.text = "0"
    }
        
    func sendCoinPreview(coin: String, amount: String, address: String, memo: String?, callback: @escaping (_ preview: PreviewTX?,_ errorMessage: String?) -> Void) {
        API.shared.sendPreview(token: coin, amount: amount, address: address, memo: memo) { preview, error in
            callback(preview, error)
        }
    }
    
    func sendCoin(coin: String, amount: String, address: String, memo: String?, callback: @escaping (_ errorMessage: String?) -> Void) {
        API.shared.send(token: coin, amount: amount, address: address, memo: memo) { error in
            callback(error)
        }
    }
}
