//
//  StoreManager.swift
//  Terra Planet
//
//  Created by f0go on 30/03/2022.
//

import Foundation

final class StoreManager {
    
    static let shared = StoreManager()
    
    private let availableCoins = ["uluna", "uusd", "anchor"]
    
    func setPreferredGasFeeCoin(coin: FeeCoin) {
        var fee_token = "uusd"
        if coin == .luna {
            fee_token = "uluna"
        }
        UserDefaults.standard.setValue(fee_token, forKey: "gasFee")
    }
    
    private func getPreferredGasFeeCoin() -> FeeCoin {
        if let value = UserDefaults.standard.value(forKey: "gasFee") as? String {
            var fee_token: FeeCoin = .ust
            if value == "uluna" {
                fee_token = .luna
            }
            return fee_token
        }
        return .ust
    }
    
    func loadUserData(callback: @escaping (_ preferredGasFeeCoin: FeeCoin) -> Void) {
        callback(getPreferredGasFeeCoin())
    }
    
    func setNetwork(network: String) {
        UserDefaults.standard.setValue(network, forKey: "network")
    }
    
    func getNetwork() {
        if let value = UserDefaults.standard.value(forKey: "network") as? String {
            API.shared.net = value
        }
        else {
            API.shared.net = "test"
        }
    }
}
