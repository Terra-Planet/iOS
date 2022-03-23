//
//  API.swift
//  Terra Planet
//
//  Created by f0go on 22/03/2022.
//

import Foundation
import SwiftyJSON
import Alamofire

final class API {
    static let shared = API()
    
    var wallet: Wallet?
    
    private let local = "http://127.0.0.1:3000/"
    
    func createWallet(callback: @escaping (_ status: Bool) -> Void) {
        if wallet == nil {
            Network.shared.get("\(local)wallet/create") { response in
                if response.status == 200 {
                    self.wallet = Wallet(address: response.data["acc_address"].stringValue, mnemonic: response.data["mnemonic"].stringValue)
                    KeyChainManager.shared.saveWallet(wallet: self.wallet!)
                    callback(true)
                }
                else {
                    callback(false)
                }
            }
        }
        else {
            callback(false)
        }
    }
    
    func balance(callback: @escaping (_ balance: [Balance]?) -> Void) {
        if let wallet = wallet {
            Network.shared.get("\(local)wallet/balance/\(wallet.address)") { response in
                if response.status == 200 {
                    var resp: [Balance] = []
                    if response.data["anchor"]["balance"].floatValue != 0 {
                        resp.append(Balance(coin: "aUST", amount: response.data["anchor"]["balance"].floatValue / 1000000))
                    }
                
                    
                    let native = JSON(parseJSON: response.data["native"][0].stringValue)
                    for coin in native.arrayValue {
                        resp.append(Balance(coin: coin["denom"].stringValue, amount: (coin["amount"].floatValue / 1000000)))
                    }
                    callback(resp)
                }
                else {
                    callback(nil)
                }
            }
        }
        else {
            callback(nil)
        }
    }
    
    func send(token: String, amount: String, address: String, callback: @escaping (_ status: Bool) -> Void) {
        if let wallet = wallet {
            let payload: [String:Any] = [
                "token" : token,
                "amount" : amount,
                "dst_addr" : address,
                "mnemonic" : wallet.mnemonic
            ]
            Network.shared.post("\(local)wallet/send", data: payload) { response in
                if response.status == 200 {
                    callback(true)
                }
                else {
                    callback(false)
                }
            }
        }
        else {
            callback(false)
        }
    }
    
    func swap(from: String, to: String, amount: String, callback: @escaping (_ status: Bool) -> Void) {
        if let wallet = wallet {
            let payload: [String:Any] = [
                "src" : from,
                "amount" : amount,
                "dst" : to,
                "mnemonic" : wallet.mnemonic
            ]
            Network.shared.post("\(local)wallet/swap", data: payload) { response in
                if response.status == 200 {
                    callback(true)
                }
                else {
                    callback(false)
                }
            }
        }
        else {
            callback(false)
        }
    }
    
    func anchorDeposit(amount: String, callback: @escaping (_ status: Bool) -> Void) {
        if let wallet = wallet {
            let payload: [String:Any] = [
                "token" : "uusd",
                "amount" : amount,
                "mnemonic" : wallet.mnemonic
            ]
            Network.shared.post("\(local)anchor/deposit", data: payload) { response in
                if response.status == 200 {
                    callback(true)
                }
                else {
                    callback(false)
                }
            }
        }
        else {
            callback(false)
        }
    }
    
    func anchorWithdraw(amount: String, callback: @escaping (_ status: Bool) -> Void) {
        if let wallet = wallet {
            let payload: [String:Any] = [
                "token" : "uusd",
                "amount" : amount,
                "mnemonic" : wallet.mnemonic
            ]
            Network.shared.post("\(local)anchor/withdraw", data: payload) { response in
                if response.status == 200 {
                    callback(true)
                }
                else {
                    callback(false)
                }
            }
        }
        else {
            callback(false)
        }
    }
}
