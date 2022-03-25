//
//  Utils.swift
//  Terra Planet
//
//  Created by f0go on 24/03/2022.
//

import Foundation

final class Utils {
    static let shared = Utils()
    
    let events: EventManager = EventManager()
}

extension Double {
    func double2String() -> String {
        return String(format: "%.2f", self)
    }
}
