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
    let net = "testnet"
    var gasFee: FeeCoin = .ust
    
    var lunaPrice: Double = 0
    
    private let local = "http://127.0.0.1:3000/"
    private let supportedCoins = ["uluna", "uusd"]
 
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
                    self.wallet = Wallet(address: response.data["acc_address"].stringValue, mnemonic: response.data["mnemonic"].stringValue, coins: [:])
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
    
    func showSeed(callback: @escaping (_ mnemonic: String?) -> Void) {
        KeyChainManager.shared.loadWallet { status in
            if status {
                callback(self.wallet?.mnemonic)
            }
            else {
                callback(nil)
            }
        }
    }
    
    func restoreWallet(mnemonic: String, callback: @escaping (_ status: Bool) -> Void) {
        Network.shared.post("\(local)wallet/restore", data: ["mnemonic":mnemonic]) { response in
            if response.status == 200 {
                self.wallet = Wallet(address: response.data["acc_address"].stringValue, mnemonic: mnemonic, coins: [:])
                KeyChainManager.shared.saveWallet(wallet: self.wallet!)
                callback(true)
            }
            else {
                callback(false)
            }
        }
    }
    
    func loadCoins(reloadMarket: Bool, callback: @escaping (_ status: Bool) -> Void) {
        callback(false)
        if let wallet = wallet {
            
            func loadCoins() {
                var terra = false
                var anchor = false
                
                //MARK: Get Terra Balance
                Network.shared.get("\(local)wallet/balance/\(wallet.address)") { response in
                    if response.status == 200 {
                        let native = JSON(parseJSON: response.data["native"][0].stringValue)
                        for coin in native.arrayValue {
                            if self.supportedCoins.contains(coin["denom"].stringValue) {
                                let amount = (coin["amount"].doubleValue / 1000000)
                                let balance = Balance(coin: coin["denom"].stringValue, amount: amount)
                                StoreManager.shared.setBalance(coin: balance)
                                self.wallet?.coins[coin["denom"].stringValue] = balance
                            }
                        }
                        terra = true
                        if anchor {
                            callback(true)
                        }
                    }
                }
                
                //MARK: Get Anchor Balance
                Network.shared.post("\(local)anchor/balance", data: ["mnemonic":wallet.mnemonic]) { response in
                    if response.status == 200 {
                        let balance = Balance(coin: "anchor", amount: response.data["total_deposit_balance_in_ust"].doubleValue)
                        StoreManager.shared.setBalance(coin: balance)
                        self.wallet?.coins["anchor"] = balance
                        anchor = true
                        if terra {
                            callback(true)
                        }
                    }
                }
            }
            
            if reloadMarket {
                prices { status in
                    if status {
                        loadCoins()
                    }
                    else {
                        callback(false)
                    }
                }
            }
            else {
                loadCoins()
            }
        }
        else {
            callback(false)
        }
    }

    func sendPreview(token: String, amount: String, address: String, memo: String?, callback: @escaping (_ preview: PreviewTX?) -> Void) {
        if let wallet = wallet {
            var payload: [String:Any] = [
                "fee_token" : self.preferredGasFeeCoin(),
                "token" : token,
                "amount" : amount,
                "dst_addr" : address,
                "mnemonic" : wallet.mnemonic
            ]
            if let memo = memo, memo != "" {
                payload["memo"] = memo
            }
            Network.shared.post("\(self.local)wallet/send/preview", data: payload) { response in
                if response.status == 200 {
                    let message = JSON(parseJSON: response.data["body"]["messages"][0].stringValue)
                    let fee_info = JSON(parseJSON: response.data["auth_info"]["fee"].stringValue)
                    let fee = PreviewFee(coin: fee_info["amount"][0]["denom"].stringValue, amount: fee_info["amount"][0]["amount"].doubleValue)
                    callback(PreviewTX(from: message["from_address"].stringValue, to: message["to_address"].stringValue, amount: message["amount"][0]["amount"].doubleValue.legibleAmount(), fee: fee))
                }
                else {
                    callback(nil)
                }
            }
        }
    }
    
    func send(token: String, amount: String, address: String, memo: String?, callback: @escaping (_ status: Bool) -> Void) {
        KeyChainManager.shared.loadWallet { status in
            if status {
                if let wallet = self.wallet {
                    var payload: [String:Any] = [
                        "fee_token" : self.preferredGasFeeCoin(),
                        "token" : token,
                        "amount" : amount,
                        "dst_addr" : address,
                        "mnemonic" : wallet.mnemonic
                    ]
                    if let memo = memo, memo != "" {
                        payload["memo"] = memo
                    }
                    Network.shared.post("\(self.local)wallet/send", data: payload) { response in
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
            else {
                callback(false)
            }
        }
    }
    
    func swapPreview(from: String, to: String, amount: String, callback: @escaping (_ preview: PreviewTX?) -> Void) {
        if let wallet = wallet {
            let payload: [String:Any] = [
                "fee_token" : self.preferredGasFeeCoin(),
                "src" : from,
                "amount" : amount,
                "dst" : to,
                "mnemonic" : wallet.mnemonic
            ]
            Network.shared.post("\(self.local)wallet/swap/preview", data: payload) { response in
                if response.status == 200 {
                    let message = JSON(parseJSON: response.data["body"]["messages"][0].stringValue)
                    let fee_info = JSON(parseJSON: response.data["auth_info"]["fee"].stringValue)
                    let fee = PreviewFee(coin: fee_info["amount"][0]["denom"].stringValue, amount: fee_info["amount"][0]["amount"].doubleValue)
                    callback(PreviewTX(from: message["offer_coin"]["denom"].stringValue, to: message["ask_denom"].stringValue, amount: message["offer_coin"]["amount"].doubleValue, fee: fee))
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
    
    func swap(from: String, to: String, amount: String, callback: @escaping (_ status: Bool) -> Void) {
        KeyChainManager.shared.loadWallet { status in
            if status {
                if let wallet = self.wallet {
                    let payload: [String:Any] = [
                        "fee_token" : self.preferredGasFeeCoin(),
                        "src" : from,
                        "amount" : amount,
                        "dst" : to,
                        "mnemonic" : wallet.mnemonic
                    ]
                    Network.shared.post("\(self.local)wallet/swap", data: payload) { response in
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
            else {
                callback(false)
            }
        }
    }
    
    //MARK: Anchor
    func anchorDeposit(amount: String, callback: @escaping (_ status: Bool) -> Void) {
        KeyChainManager.shared.loadWallet { status in
            if status {
                if let wallet = self.wallet {
                    let payload: [String:Any] = [
                        "token" : "uusd",
                        "amount" : amount,
                        "mnemonic" : wallet.mnemonic
                    ]
                    Network.shared.post("\(self.local)anchor/deposit", data: payload) { response in
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
            else {
                callback(false)
            }
        }
    }
    
    func anchorWithdraw(amount: String, callback: @escaping (_ status: Bool) -> Void) {
        KeyChainManager.shared.loadWallet { status in
            if status {
                if let wallet = self.wallet {
                    let payload: [String:Any] = [
                        "token" : "uusd",
                        "amount" : amount,
                        "mnemonic" : wallet.mnemonic
                    ]
                    Network.shared.post("\(self.local)anchor/withdraw", data: payload) { response in
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
            else {
                callback(false)
            }
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
        Network.shared.get("\(local)market/rate/uluna/uusd") { response in
            if response.status == 200 {
                self.lunaPrice = response.data["amount"].doubleValue
                StoreManager.shared.setLastLunaPrice(value: self.lunaPrice)
                callback(true)
            }
            else {
                callback(false)
            }
        }
    }
    
    //MARK: Utils
    private func preferredGasFeeCoin() -> String {
        var fee_token = "uusd"
        if self.gasFee == .luna {
            fee_token = "uluna"
        }
        return fee_token
    }
}
