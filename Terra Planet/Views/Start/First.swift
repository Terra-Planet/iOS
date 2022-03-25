//
//  First.swift
//  Terra Planet
//
//  Created by f0go on 23/03/2022.
//

import Foundation
import UIKit

extension FirstVC {
    
    func waitServer(callback: @escaping () -> Void) {
        func ask() {
            API.shared.status { status in
                if status {
                    callback()
                }
                else {
                    ask()
                }
            }
        }
        ask()
    }
    
    func loadWallet() {
        let loadWallet = KeyChainManager.shared.loadWallet()
        if loadWallet {
            DispatchQueue.main.async {
                let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(identifier: "HomeVC")
                self.present(vc, animated: false)
            }
        }
        else {
            DispatchQueue.main.async {
                let vc = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(identifier: "OBNav")
                self.present(vc, animated: false)
            }
        }
    }
    
}
