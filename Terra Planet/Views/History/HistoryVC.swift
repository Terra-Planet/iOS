//
//  HistoryVC.swift
//  Terra Planet
//
//  Created by f0go on 29/03/2022.
//

import Foundation
import UIKit
import WebKit

class HistoryVC: UIViewController {
    
    let webView = WKWebView()
    
    override func viewDidLoad() {
        view = webView
        if let wallet = API.shared.wallet {
            let url = URL(string: "https://finder.terra.money/\(API.shared.net)/address/\(wallet.address)")
            let request = URLRequest(url: url!)
            webView.load(request)
        }
    }
}

