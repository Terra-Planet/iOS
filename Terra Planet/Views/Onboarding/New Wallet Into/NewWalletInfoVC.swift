//
//  NewWalletInfoVC.swift
//  Terra Planet
//
//  Created by f0go on 23/03/2022.
//

import Foundation
import UIKit

class NewWalletInfoVC: UIViewController {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var seedLabel: UILabel!
    
    var address = ""
    var seeds = ""
    
    override func viewDidLoad() {
        loadContent()
    }
    
    @IBAction func `continue`(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
        present(vc, animated: false)
    }
    
    private func loadContent() {
        if let wallet = loadWallet() {
            address = wallet.address
            seeds = wallet.mnemonic
            reloadView()
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func reloadView() {
        addressLabel.text = address
        seedLabel.text = seeds
    }
}
