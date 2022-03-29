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
    
    func loadWallet(callback: @escaping (_ hasWallet: Bool) -> Void) {
        waitServer {
            KeyChainManager.shared.loadWallet { status in
                callback(status)
            }
        }
    }
    
}
