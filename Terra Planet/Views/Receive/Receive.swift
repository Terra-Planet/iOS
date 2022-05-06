//
//  ReceiveVC\\.swift
//  Terra Planet
//
//  Created by f0go on 24/03/2022.
//

import Foundation
import UIKit

extension ReceiveVC {
    
    func createQR() {
        if let wallet = API.shared.wallet {
            qr.image = QR.generateQRCode(from: wallet.address)
            addressLabel.text = wallet.address
        }
    }
    
    func copyAddressToClipboard() {
        if let wallet = API.shared.wallet {
            UIPasteboard.general.string = wallet.address
        }
    }
}
