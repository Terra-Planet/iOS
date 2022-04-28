//
//  HistoryVC.swift
//  Terra Planet
//
//  Created by f0go on 29/03/2022.
//

import Foundation
import UIKit
import WebKit
import WKWebView_WarmUp

class HistoryVC: UIViewController {
    
    private lazy var webView: WKWebView = {
        let webView: WKWebView!
        
        if let url = API.shared.createWalletHistoryURL() {
            webView = WKWebViewHeater.shared.dequeue(with: url)
        } else {
            webView = WKWebViewHeater.shared.dequeue()
        }
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.scrollView.alwaysBounceHorizontal = false
        webView.scrollView.alwaysBounceVertical = false
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add the WebView
        view.addSubview(webView)

        // User AutoLayout to set its constraints
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        NSLayoutConstraint.activate(webViewConstraints)
    }
}

