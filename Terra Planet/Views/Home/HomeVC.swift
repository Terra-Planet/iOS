//
//  HomeVC.swift
//  Terra Planet
//
//  Created by f0go on 23/03/2022.
//

import Foundation
import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var actionsView: UIView!
    @IBOutlet weak var earnView: UIView!
    
    @IBOutlet weak var balance: UILabel!
    
    @IBOutlet weak var lunaAmount: UILabel!
    @IBOutlet weak var lunaValue: UILabel!
    
    
    @IBOutlet weak var ustAmount: UILabel!
    @IBOutlet weak var ustValue: UILabel!
    
    @IBOutlet weak var anchorAPY: UILabel!
    @IBOutlet weak var anchorValue: UILabel!
    
    override func viewDidLoad() {
        design()
        loadBalance()
        loadAPY()
        Utils.shared.events.listenTo("reloadBalance") { _ in
            self.loadBalance()
        }
    }
    
    @IBAction func reload(_ sender: UIButton) {
        loadBalance()
        loadAPY()
    }
    
    @IBAction func receive(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Receive", bundle: nil).instantiateViewController(withIdentifier: "ReceiveVC")
        self.present(vc, animated: true)
    }
    
    @IBAction func swap(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Swap", bundle: nil).instantiateViewController(withIdentifier: "SwapVC")
        self.present(vc, animated: true)
    }
    
    @IBAction func send(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Send", bundle: nil).instantiateViewController(withIdentifier: "SendVC")
        self.present(vc, animated: true)
    }
    
    @IBAction func anchorDeposit(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Anchor", bundle: nil).instantiateViewController(withIdentifier: "AnchorVC") as! AnchorVC
        vc.anchorAction = .deposit
        self.present(vc, animated: true)
    }
    
    @IBAction func anchorWithdraw(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Anchor", bundle: nil).instantiateViewController(withIdentifier: "AnchorVC") as! AnchorVC
        vc.anchorAction = .withdraw
        self.present(vc, animated: true)
    }
    
    private func design() {
        tabBarController?.tabBar.tintColor = UIColor(named: "color_blue")
        tabBarController?.tabBar.items?[0].image = UIImage(systemName: "wallet.pass.fill")
        tabBarController?.tabBar.items?[0].title = "Wallet"
        earnView.layer.borderWidth = 2
        earnView.layer.borderColor = UIColor(named: "color_blue")?.cgColor
    }
}
