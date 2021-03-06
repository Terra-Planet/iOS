//
//  SettingsVC.swift
//  Terra Planet
//
//  Created by f0go on 30/03/2022.
//

import Foundation
import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet weak var gasView: UIView!
    @IBOutlet weak var gasSelector: UISegmentedControl!
    @IBOutlet weak var netView: UIView!
    @IBOutlet weak var networkSelector: UISegmentedControl!
    
    override func viewDidLoad() {
        design()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setSelector()
    }
    
    private func setSelector() {
        if API.shared.gasFee == .ust {
            gasSelector.selectedSegmentIndex = 0
        }
        else {
            gasSelector.selectedSegmentIndex = 1
        }
        if API.shared.net == "test" {
            networkSelector.selectedSegmentIndex = 0
        }
        else {
            networkSelector.selectedSegmentIndex = 1
        }
    }
    
    @IBAction func changeGas(_ sender: UISegmentedControl) {
        if sender == gasSelector {
            var coin: FeeCoin = .ust
            if gasSelector.selectedSegmentIndex == 1 {
                coin = .luna
            }
            savePreferredGasFeeCoin(coin: coin)
        }
        else {
            if sender.selectedSegmentIndex == 0 {
                API.shared.changeNetwork(network: "test")
            }
            else {
                API.shared.changeNetwork(network: "main")
            }
        }
    }
    
    @IBAction func seeSeeds(_ sender: UIButton) {
        getSeed { seed in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            if let seed = seed {
                alert.title = "Your seed phrase is:"
                alert.message = seed
            }
            else {
                alert.title = "Error"
                alert.message = "Seed Phrase not found"
            }
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func deleteAccount(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure?", message: "Please check if you took note of your seed phrase before deleting the account.", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes, I'm sure", style: .destructive) { _ in
            if self.deleteAccount() {
                self.dismiss(animated: true)
            }
        }
        alert.addAction(yes)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func design() {
        gasView.blueBorderLine()
        netView.blueBorderLine()
    }
}
