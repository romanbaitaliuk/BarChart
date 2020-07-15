//
//  Extension+Decimals.swift
//  PropperCharts
//
//  Created by Roman Baitaliuk on 14/07/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import Foundation

extension Double {
    func decimalsCount() -> Int {
        if self == Double(Int(self)) {
            return 0
        }

        let integerString = String(Int(self))
        let doubleString = String(Double(self))
        let decimalCount = doubleString.count - integerString.count - 1

        return decimalCount
    }
}
