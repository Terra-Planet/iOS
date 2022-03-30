//
//  ViewController.swift
//  Terra Planet
//
//  Created by f0go on 22/03/2022.
//

import UIKit
import SwiftyJSON

class FirstVC: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        loadWallet { hasWallet in
            self.redirect(hasWallet: hasWallet)
        }
    }
    
    func redirect(hasWallet: Bool) {
        var nextView = ["Onboarding","OBNav"]
        if hasWallet {
            nextView = ["HomeTab","HomeTab"]
            loadStoredData()
        }
        DispatchQueue.main.async {
            let vc = UIStoryboard(name: nextView[0], bundle: nil).instantiateViewController(withIdentifier: nextView[1])
            self.present(vc, animated: false)
        }
    }
}

