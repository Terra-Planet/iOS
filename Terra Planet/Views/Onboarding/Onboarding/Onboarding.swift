//
//  Onboarding.swift
//  Terra Planet
//
//  Created by f0go on 23/03/2022.
//

import Foundation
import UIKit

extension OnboardingVC {
    func createWallet(callback: @escaping (_ status: Bool) -> Void) {
        API.shared.createWallet { status in
            callback(status)
        }
    }
}
