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

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
