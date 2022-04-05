//
//  Utils.swift
//  Terra Planet
//
//  Created by f0go on 24/03/2022.
//

import Foundation
import UIKit

final class Utils {
    static let shared = Utils()
    
    let events: EventManager = EventManager()
}

extension Double {
    func double2String() -> String {
        return String(format: "%.2f", self)
    }
    
    func legibleAmount() -> Double {
        return self / 1000000
    }
}

extension String {
    func coinCode2Name() -> String {
        switch self {
        case "uluna": return "LUNA"
        case "uusd": return "UST"
        default: return self
        }
    }
}

extension UIView {
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}
