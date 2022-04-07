//
//  BlockScreenVC.swift
//  Terra Planet
//
//  Created by f0go on 07/04/2022.
//

import Foundation
import UIKit

class BlockScreenVC: UIViewController {
    
    @IBAction func unblock(_ sender: UIButton) {
        KeyChainManager.shared.loadWallet { status in
            if status {
                DispatchQueue.main.sync {
                    self.dismiss(animated: true)
                }
            }
        }
    }
}
