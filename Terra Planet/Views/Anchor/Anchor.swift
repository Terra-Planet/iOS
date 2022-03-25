//
//  Anchor.swift
//  Terra Planet
//
//  Created by f0go on 25/03/2022.
//

import Foundation

extension AnchorVC {
        
    func anchor(action: AnchorActions, amount: String, callback: @escaping (_ status: Bool) -> Void) {
        if action == .deposit {
            API.shared.anchorDeposit(amount: amount) { status in
                callback(status)
            }
        }
        else {
            API.shared.anchorWithdraw(amount: amount) { status in
                callback(status)
            }
        }
    }
}
