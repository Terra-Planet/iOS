//
//  ViewController.swift
//  Terra Planet
//
//  Created by f0go on 22/03/2022.
//

import UIKit
import SwiftyJSON

class FirstVC: UIViewController {

    override func viewDidLoad() {
        waitServer {
            self.loadWallet()
        }
    }
}

