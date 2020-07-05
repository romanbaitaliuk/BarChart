//
//  YValueFormatter.swift
//  PropperCharts
//
//  Created by Roman Baitaliuk on 5/07/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import Foundation

struct YValueFormatter {
    static func formatValues(_ values: [Double], step: Double) -> [String] {
        return values.map { String(format: $0.removeZerosFromEnd(), self.specifier(value: step)) }
    }
    
    static func specifier(value: Double) -> String {
        let absoluteValue = abs(value)
        if absoluteValue > 0 && absoluteValue < 1 {
            let decimalsCount = absoluteValue.decimalsCount()
            return "%.\(decimalsCount)f"
        } else if absoluteValue >= 1 {
            let decimalPart = value.truncatingRemainder(dividingBy: 1)
            return decimalPart == 0 ? "%.0f" : "%.1f"
        } else {
            return "%.0f"
        }
    }
}

private extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16
        return String(formatter.string(from: number) ?? "")
    }
}
