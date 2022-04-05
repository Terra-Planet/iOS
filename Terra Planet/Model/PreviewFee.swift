//
//  PreviewFee.swift
//  Terra Planet
//
//  Created by f0go on 05/04/2022.
//

import Foundation

struct PreviewFee {
    let coin: String
    let amount: Double
    
    func usdFee() -> Double {
        var response: Double = amount.legibleAmount()
        if coin == "uluna" {
            response = response * API.shared.lunaPrice
        }
        return response
    }
}
