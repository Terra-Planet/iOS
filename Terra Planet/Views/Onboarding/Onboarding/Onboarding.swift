//
//  Onboarding.swift
//  Terra Planet
//
//  Created by f0go on 23/03/2022.
//

import Foundation
import UIKit

extension OnboardingVC {
    func createWallet() {
        API.shared.createWallet { status in
            if status {
                let vc = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "NewWalletInfoVC")
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                let alert = UIAlertController(title: "Error", message: "There was an error creating the wallet.\nPlease try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
}
