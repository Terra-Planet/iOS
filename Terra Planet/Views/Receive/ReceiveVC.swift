//
//  ReceiveVC.swift
//  Terra Planet
//
//  Created by f0go on 24/03/2022.
//

import Foundation
import UIKit

class ReceiveVC: UIViewController {
    
    @IBOutlet weak var qr: UIImageView!
    
    override func viewDidLoad() {
        createQR()
    }
    
    @IBAction func copyAddress(_ sender: UIButton) {
        copyAddressToClipboard()
    }
}
