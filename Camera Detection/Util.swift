//
//  Util.swift
//  Camera Detection
//
//  Created by Taha Topiwala on 7/19/17.
//  Copyright © 2017 Taha Topiwala. All rights reserved.
//

import Foundation

enum AppNotificationCenterName: String {
    case changeArrowImage = "changeArrowImage"
}

extension Double {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Array {
    func slice(for count: Int) -> Array {
        return Array(self[..<count])
    }
}
