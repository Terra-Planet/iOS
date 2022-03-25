//
//  NewWalletInfoVC.swift
//  Terra Planet
//
//  Created by f0go on 23/03/2022.
//

import Foundation
import UIKit

class NewWalletInfoVC: UIViewController {
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var seed: UILabel!
    
    override func viewDidLoad() {
        loadWallet()
    }
    
    @IBAction func `continue`(_ sender: UIButton) {
        nextView()
    }
}
