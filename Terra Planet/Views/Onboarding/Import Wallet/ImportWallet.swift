//
//  ImportWallet.swift
//  Terra Planet
//
//  Created by f0go on 28/03/2022.
//

import Foundation

extension ImportWalletVC {
    
    func getWalletFromSeeds(seeds: String, callback: @escaping (_ status: Bool) -> Void) {
        API.shared.restoreWallet(mnemonic: seeds) { status in
            callback(status)
        }
    }
    
}
