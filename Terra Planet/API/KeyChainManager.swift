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
    
    private let service = "TerraPlanet"
    private let account = "Account"
    
    func saveWallet(wallet: Wallet) {
        let _ = deleteWallet()
        let dic = ["address":wallet.address,"mnemonic":wallet.mnemonic]
        let valueData: Data = NSKeyedArchiver.archivedData(withRootObject: dic)
        let sacObject = SecAccessControlCreateWithFlags(kCFAllocatorDefault, kSecAttrAccessibleWhenUnlockedThisDeviceOnly, .userPresence, nil)!

        let insert_query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccessControl: sacObject,
            kSecValueData: valueData,
            kSecUseAuthenticationUI: kSecUseAuthenticationUIAllow,
            kSecAttrService: service,
            kSecAttrAccount: account
        ]
        let insert_status = SecItemAdd(insert_query as CFDictionary, nil)
        if insert_status == errSecSuccess {
            print("Inserted successfully.")
        }
        else {
            print("INSERT Error: \(insert_status).")
        }
    }
    
    func loadWallet(callback: @escaping (_ status: Bool) -> Void) {
        DispatchQueue.global().async {
            let select_query: NSDictionary = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: self.service,
                kSecAttrAccount: self.account,
                kSecReturnData: true,
                kSecUseOperationPrompt: "Touch to Unlock"
            ]
            var extractedData: CFTypeRef?
            let select_status = SecItemCopyMatching(select_query, &extractedData)
            if select_status == errSecSuccess {
                if let retrievedData = extractedData as? Data,
                    let credentials: [String : String] = NSKeyedUnarchiver.unarchiveObject(with: retrievedData) as? [String : String] {
                    print(credentials)
                    if let address = credentials["address"], let mnemonic = credentials["mnemonic"], !address.isEmpty, !mnemonic.isEmpty {
                        API.shared.wallet = Wallet(address: address, mnemonic: mnemonic, coins: [:])
                        callback(true)
                    }
                    else {
                        callback(false)
                    }
                }
                else {
                    callback(false)
                }
            }
            else {
                callback(false)
            }
        }
    }
    
    func deleteWallet() -> Bool {
        let delete_query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: false
        ]
        let delete_status = SecItemDelete(delete_query)
        if delete_status == errSecSuccess {
            print("Deleted successfully.")
            return true
        } else if delete_status == errSecItemNotFound {
            print("Nothing to delete.")
            return false
        } else {
            print("DELETE Error: \(delete_status).")
            return false
        }
    }
    
}
