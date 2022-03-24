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
    
    var balance: Double = 0
    var lunaPrice: Double = 0
    
    private let local = "http://127.0.0.1:3000/"
 
    //MARK: Server Status
    func status(callback: @escaping (_ status: Bool) -> Void) {
        Network.shared.get("\(local)server/status") { response in
            if response.status == 200 {
                callback(true)
            }
            else {
                callback(false)
            }
        }
    }
    
    //MARK: Wallet
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
    
    func balance(callback: @escaping (_ balance: [Balance]) -> Void) {
        if let wallet = wallet {
            var resp: [Balance] = []
            balance = 0
            var terra = false
            var anchor = false
            //MARK: Get Terra Balance
            Network.shared.get("\(local)wallet/balance/\(wallet.address)") { response in
                if response.status == 200 {
                    let native = JSON(parseJSON: response.data["native"][0].stringValue)
                    for coin in native.arrayValue {
                        let amount = (coin["amount"].doubleValue / 1000000)
                        if coin["denom"].stringValue == "uluna" {
                            self.balance += amount * self.lunaPrice
                        }
                        else {
                            self.balance += amount
                        }
                        resp.append(Balance(coin: coin["denom"].stringValue, amount: amount))
                    }
                    terra = true
                    if anchor {
                        callback(resp)
                    }
                }
            }
            
            //MARK: Get Anchor Balance
            Network.shared.post("\(local)anchor/balance", data: ["mnemonic":wallet.mnemonic]) { response in
                if response.status == 200 {
                    self.balance += response.data["total_deposit_balance_in_ust"].doubleValue
                    resp.append(Balance(coin: "anchor", amount: response.data["total_deposit_balance_in_ust"].doubleValue))
                    anchor = true
                    if terra {
                        callback(resp)
                    }
                }
            }
        }
        else {
            callback([])
        }
    }
    
    func send(token: String, amount: String, address: String, callback: @escaping (_ status: Bool) -> Void) {
        if let wallet = wallet {
            let payload: [String:Any] = [
                "fee_token" : "uluna",
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
                "fee_token" : "uluna",
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
    
    //MARK: Anchor
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
    
    //MARK: Rates
    func apy(callback: @escaping (_ apy: Double) -> Void) {
        if let wallet = wallet {
            Network.shared.post("\(local)anchor/market", data: ["mnemonic":wallet.mnemonic]) { response in
                if response.status == 200 {
                    callback(response.data["APY"].doubleValue)
                }
                else {
                    callback(0)
                }
            }
        }
        else {
            callback(0)
        }
    }
    
    func prices(callback: @escaping (_ status: Bool) -> Void) {
        Network.shared.get("\(local)wallet/rate/uluna/uusd") { response in
            if response.status == 200 {
                print(response.data)
                self.lunaPrice = response.data["amount"].doubleValue
                callback(true)
            }
            else {
                callback(false)
            }
        }
    }
}
