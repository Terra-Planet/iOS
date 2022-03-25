//
//  NewWalletInfo.swift
//  Terra Planet
//
//  Created by f0go on 23/03/2022.
//

import Foundation
import UIKit

extension NewWalletInfoVC {
    
    func loadWallet() {
        if let wallet = API.shared.wallet {
            address.text = wallet.address
            seed.text = wallet.mnemonic
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func nextView() {
        let vc = UIStoryboard(name: "HomeTab", bundle: nil).instantiateViewController(identifier: "HomeTab")
        self.present(vc, animated: false)
    }
}
