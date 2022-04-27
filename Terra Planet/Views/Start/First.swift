//
//  First.swift
//  Terra Planet
//
//  Created by f0go on 23/03/2022.
//

import Foundation
import UIKit

extension FirstVC {
    
    private func waitServer(callback: @escaping () -> Void) {
        func ask() {
            let queue = DispatchQueue(label: "waitServer", qos: .default)
            queue.async {
                Thread.current.name = queue.label
                API.shared.status { status in
                    if status {
                        callback()
                        return
                    }
                    
                    let seconds = 1.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                        ask()
                    }
                }
            }
        }
        ask()
    }
    
    func loadWallet(callback: @escaping (_ hasWallet: Bool) -> Void) {
        waitServer {
            KeyChainManager.shared.loadWallet { status in
                callback(status)
            }
        }
    }
    
    func loadStoredData() {
        StoreManager.shared.loadUserData { preferredGasFeeCoin in
            API.shared.gasFee = preferredGasFeeCoin
        }
        StoreManager.shared.getNetwork()
    }
    
}
