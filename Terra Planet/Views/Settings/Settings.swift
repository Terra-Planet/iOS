//
//  Settings.swift
//  Terra Planet
//
//  Created by f0go on 30/03/2022.
//

import Foundation

extension SettingsVC {
    
    func savePreferredGasFeeCoin(coin: FeeCoin) {
        API.shared.savePreferredGasFeeCoin(coin: coin)
    }
    
    func getSeed(callback: @escaping (_ mnemonic: String?) -> Void) {
        API.shared.showSeed { mnemonic in
            callback(mnemonic)
        }
    }
    
    func deleteAccount() -> Bool {
        API.shared.wallet = nil
        return KeyChainManager.shared.deleteWallet()
    }
    
}
