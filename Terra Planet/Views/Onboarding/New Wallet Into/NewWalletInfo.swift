//
//  NewWalletInfo.swift
//  Terra Planet
//
//  Created by f0go on 23/03/2022.
//

import Foundation
import UIKit

extension NewWalletInfoVC {
    
    func loadWallet() -> Wallet? {
        if let wallet = API.shared.wallet {
            return wallet
        }
        else {
            return nil
        }
    }
}
