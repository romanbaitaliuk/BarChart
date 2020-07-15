//
//  YAxisScaler.swift
//  PropperCharts
//
//  Created by Roman Baitaliuk on 14/07/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import Foundation

struct YAxisScaler {
    private var minPoint: Double
    private var maxPoint: Double
    private var maxTicks: Int
    private(set) var tickSpacing: Double?
    private(set) var scaledMin: Double?
    private(set) var scaledMax: Double?
    
    init(min: Double, max: Double, maxTicks: Int) {
        self.maxTicks = maxTicks
        self.minPoint = min
        self.maxPoint = max
        self.calculate()
    }
    
    func scaledValues() -> [Double] {
        guard let tickSpacing = self.tickSpacing,
            let min = self.scaledMin,
            let max = self.scaledMax else { return [] }
        var labels = [Double]()
        
        // Adjusted max to include actual max to the list
        let adjustedMax = max + tickSpacing / 2
        for label in stride(from: min, to: adjustedMax, by: tickSpacing) {
            labels.append(self.removeTrailingZeros(label, to: tickSpacing.decimalsCount()))
        }
        return labels
    }
    
    private mutating func calculate() {
        guard self.maxTicks > 1,
            self.maxPoint > self.minPoint else { return }
        let range = self.scale(self.maxPoint - self.minPoint, round: false)
        let tickSpacing = self.scale(range / Double((self.maxTicks - 1)), round: true)
        let scaledMin = floor(self.minPoint / tickSpacing) * tickSpacing
        self.scaledMin = self.removeTrailingZeros(scaledMin, to: tickSpacing.decimalsCount())
        let scaledMax = ceil(self.maxPoint / tickSpacing) * tickSpacing
        self.scaledMax = self.removeTrailingZeros(scaledMax, to: tickSpacing.decimalsCount())
        self.tickSpacing = tickSpacing
    }
    
    private func removeTrailingZeros(_ value: Double, to decimalsCount: Int) -> Double {
        return Double(String(format: "%.\(decimalsCount)f", value))!
    }
    
    private func scale(_ range: Double, round: Bool) -> Double {
        let exponent = floor(log10(range))
        let fraction = range / pow(10, exponent)
        let niceFraction: Double
        
        if round {
            if fraction <= 1.5 {
                niceFraction = 1
            } else if fraction <= 3 {
                niceFraction = 2
            } else if fraction <= 7 {
                niceFraction = 5
            } else {
                niceFraction = 10
            }
        } else {
            if fraction <= 1 {
                niceFraction = 1
            } else if fraction <= 2 {
                niceFraction = 2
            } else if fraction <= 5 {
                niceFraction = 5
            } else {
                niceFraction = 10
            }
        }
        
        return niceFraction * pow(10, exponent)
    }
}
