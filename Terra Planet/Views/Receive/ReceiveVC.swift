//
//  ReceiveVC.swift
//  Terra Planet
//
//  Created by f0go on 24/03/2022.
//

import Foundation
import UIKit

class ReceiveVC: UIViewController {
    
    @IBOutlet weak var copiedLabel: UILabel!
    @IBOutlet weak var qr: UIImageView!
    
    override func viewDidLoad() {
        createQR()
    }
    
    @IBAction func copyAddress(_ sender: UIButton) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        copyAddressToClipboard()
        UIView.animate(withDuration: 0.3) {
            self.copiedLabel.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 1, options: .curveLinear) {
                self.copiedLabel.alpha = 0
            }
        }
    }
}
