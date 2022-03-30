//
//  Settings.swift
//  Terra Planet
//
//  Created by f0go on 30/03/2022.
//

import Foundation

extension SettingsVC {
    
    func savePreferredGasFeeCoin(coin: GasFee) {
        API.shared.gasFee = coin
        StoreManager.shared.setPreferredGasFeeCoin(coin: coin)
    }
    
    func getSeed(callback: @escaping (_ mnemonic: String?) -> Void) {
        API.shared.showSeed { mnemonic in
            callback(mnemonic)
        }
    }
    
    func deleteAccount() -> Bool {
        return KeyChainManager.shared.deleteWallet()
    }
    
}
