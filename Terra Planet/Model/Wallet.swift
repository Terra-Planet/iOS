//
//  Wallet.swift
//  Terra Planet
//
//  Created by f0go on 22/03/2022.
//

import Foundation

struct Wallet {
    let address: String
    let mnemonic: String
    var coins: [String:Balance]
    
    func balance() -> Double {
        var response: Double = 0
        for coin in coins {
            var value = coin.value.amount
            if coin.value.coin == "uluna" {
                value += value * API.shared.lunaPrice
            }
            response += value
        }
        return response
    }
}
