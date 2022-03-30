//
//  Design.swift
//  Terra Planet
//
//  Created by f0go on 30/03/2022.
//

import Foundation
import UIKit

extension UIView {
    func blueBorderLine() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(named: "color_blue")?.cgColor
    }
}
