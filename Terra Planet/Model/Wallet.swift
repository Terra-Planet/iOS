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
            if coin.value.coin == "uluna" {
                response += coin.value.amount * API.shared.lunaPrice
            }
            else {
                response += coin.value.amount
            }
        }
        return response
    }
}
