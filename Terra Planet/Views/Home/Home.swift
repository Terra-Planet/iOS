//
//  Home.swift
//  Terra Planet
//
//  Created by f0go on 23/03/2022.
//

import Foundation
import UIKit

extension HomeVC {
    func loadBalance() {
        DispatchQueue.main.async {
            let loading = UIAlertController(title: "Loading", message: "Please wait...", preferredStyle: .alert)
            self.present(loading, animated: true)
            API.shared.loadCoins(reloadMarket: true) { status in
                loading.dismiss(animated: true)
                if status, let wallet = API.shared.wallet {
                    self.balance.text = "$\(wallet.balance().double2String())"
                    for item in wallet.coins {
                        switch item.value.coin {
                        case "uluna":
                            self.lunaAmount.text = "\(item.value.amount)"
                            self.lunaValue.text = "$\((item.value.amount * API.shared.lunaPrice).double2String())"
                        case "uusd":
                            self.ustAmount.text = "\(item.value.amount)"
                            self.ustValue.text = "$\(item.value.amount.double2String())"
                        case "anchor":
                            self.anchorValue.text = "$\(item.value.amount.double2String())"
                        default:
                            print(item.value.coin)
                        }
                    }
                }
            }
        }
    }
    
    func loadAPY() {
        API.shared.apy { apy in
            self.anchorAPY.text = "Earn (\(apy.double2String())% APY)"
        }
    }
}
