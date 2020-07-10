//
//  YAxisLayout.swift
//  ProperCharts
//
//  Created by Roman Baitaliuk on 19/06/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public class YAxis: AxisBase {
    @Published var data: [Double] = []
    
    @Published var frameHeight: CGFloat?
    
    @Published public var minGridlineSpacing: CGFloat = 40.0
    
    var maxYLabelWidth: CGFloat {
        return self.formattedLabels().map { $0.width(font: self.labelUIFont) }.max() ?? 0
    }
    
    private var minValue: Double {
        self.data.min() ?? 0
    }
    
    private var maxValue: Double {
        self.data.max() ?? 0
    }
    
    private var max: Double {
        self.maxValue < 0 ? 0 : self.maxValue
    }
    
    private var min: Double {
        self.minValue < 0 ? self.minValue : 0
    }
    
    var chartMin: Double {
        guard let min = self.labels().min() else {
            return 0
        }
        return min < 0 ? min : 0
    }
    
    var chartMax: Double {
        guard let max = self.labels().max() else {
            return 0
        }
        return max < 0 ? 0 : max
    }
    
    var maxGridlinesCount: Int {
        guard let frameHeight = self.frameHeight else { return 0 }
        return Int(frameHeight / self.minGridlineSpacing)
    }
    
    func pixelsRatio() -> CGFloat {
        guard let frameHeight = self.frameHeight else { return 0 }
        return frameHeight / CGFloat(self.verticalDistance())
    }
    
    func step() -> Double {
        guard self.frameHeight != nil,
            !self.data.isEmpty else { return 0 }
        let absoluteMax = Swift.max(abs(self.max), abs(self.min))
        let absoluteMin = Swift.min(abs(self.max), abs(self.min))
        let distance = absoluteMax + absoluteMin
        let step = distance / Double(maxGridlinesCount)
        let roundedStep = self.roundUp(step)
        return roundedStep
    }
    
    private func roundUp(_ value: Double) -> Double {
        if value > 0 && value < 1 {
            let digitsCount = self.zerosCountAfterPoint(value) + 2
            var adj = 100.0
            if digitsCount > 2 {
                adj = Double(truncating: pow(10.0, digitsCount) as NSNumber)
            }
            return ceil(value * adj / 5) * 5 / adj
        } else if value >= 1 && value < 10 {
            return ceil(value * 10 / 5) * 5 / 10
        } else if value >= 10 {
            let digitsCount = Int(value).digitsCount()
            let adj = Double(truncating: pow(10.0, digitsCount - 2) as NSNumber)
            return ceil(value / adj / 5) * 5 * adj
        } else {
            return 0
        }
    }
    
    private func zerosCountAfterPoint(_ value: Double) -> Int {
        let valueString = String(value)
        let decimalPart = valueString.replacingOccurrences(of: "0.", with: "")
        var count: Int = 0
        for digit in decimalPart {
            if digit == "0" {
                count += 1
            } else {
                break
            }
        }
        return count
    }
    
    func centre() -> CGFloat {
        return CGFloat(self.chartMin) * self.pixelsRatio()
    }
    
    func normalizedValues() -> [Double] {
        guard self.frameHeight != nil,
            !self.data.isEmpty else { return [] }
        return self.data.map { $0 / self.verticalDistance() }
    }
    
    private func verticalDistance() -> Double {
        return abs(self.chartMax) + abs(self.chartMin)
    }
    
    func formattedLabels() -> [String] {
        return YValueFormatter.formatValues(self.labels(), step: self.step())
    }
    
    func labels() -> [Double] {
        guard self.frameHeight != nil,
            !self.data.isEmpty else { return [] }
        var labels = [Double]()
        var count = 0.0
        let step = self.step()
        
        // Add positive Y values
        while count < self.max {
            count += step
            labels.append(count)
        }
        
        count = 0.0
        labels.append(count)
        
        // Add negative Y values
        while count > self.min {
            count -= step
            labels.append(count)
        }
        return labels
    }
}
