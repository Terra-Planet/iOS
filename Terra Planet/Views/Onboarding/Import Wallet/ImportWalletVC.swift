//
//  ImportWalletVC.swift
//  Terra Planet
//
//  Created by f0go on 28/03/2022.
//

import Foundation
import UIKit
import AVFoundation

class ImportWalletVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var seedTextview: UITextView!
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text, text.contains("\n") {
            textView.text = text.replacingOccurrences(of: "\n", with: "")
            textView.resignFirstResponder()
        }
    }
    
    @IBAction func getWallet(_ sender: UIButton) {
        let loading = UIAlertController(title: "Loading", message: "Please wait...", preferredStyle: .alert)
        present(loading, animated: true)
        getWalletFromSeeds(seeds: seedTextview.text) { status in
            loading.dismiss(animated: true) {
                if status {
                    let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
                    self.present(vc, animated: false)
                }
                else {
                    let alert = UIAlertController(title: "Error", message: "Invalid Seeds. Wallet not found", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
