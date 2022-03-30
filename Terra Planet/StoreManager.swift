//
//  StoreManager.swift
//  Terra Planet
//
//  Created by f0go on 30/03/2022.
//

import Foundation

final class StoreManager {
    
    static let shared = StoreManager()
    
    func setPreferredGasFeeCoin(coin: GasFee) {
        var fee_token = "uusd"
        if coin == .luna {
            fee_token = "uluna"
        }
        UserDefaults.standard.setValue(fee_token, forKey: "gasFee")
    }
    
    func getPreferredGasFeeCoin() -> GasFee {
        if let value = UserDefaults.standard.value(forKey: "gasFee") as? String {
            var fee_token: GasFee = .ust
            if value == "uluna" {
                fee_token = .luna
            }
            return fee_token
        }
        return .ust
    }
    
    func loadUserData(callback: @escaping (_ preferredGasFeeCoin: GasFee) -> Void) {
        callback(getPreferredGasFeeCoin())
    }
}
