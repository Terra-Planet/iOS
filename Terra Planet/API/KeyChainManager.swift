//
//  KeyChainManager.swift
//  Terra Planet
//
//  Created by f0go on 22/03/2022.
//

import Foundation
import SwiftyJSON

final class KeyChainManager {
    static let shared = KeyChainManager()
    
    func saveWallet(wallet: Wallet) {
        let json:JSON = ["address":wallet.address, "mnemonic":wallet.mnemonic]
        var data: Data?
        try? data = json.rawData()
        if data != nil {
            let status = KeyChain.save(key: "wallet", data: data!)
            print("status: ", status)
        }
    }
    
    func loadWallet() -> Bool {
        if let receivedData = KeyChain.load(key: "wallet") {
            if let json = try? JSON(data: receivedData) {
                print("Wallet Loaded: \(json)")
                API.shared.wallet = Wallet(address: json["address"].stringValue, mnemonic: json["mnemonic"].stringValue)
                return true
            }
            else {
                print("Error loading Wallet")
                return false
            }
        }
        else {
            print("No stored Wallet")
            return false
        }
    }
}
