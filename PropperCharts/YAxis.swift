//
//  YAxisLayout.swift
//  ProperCharts
//
//  Created by Roman Baitaliuk on 19/06/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public class YAxis: AxisBase {
    
    // MARK: - Internal Properties
    
    @Published var data: [Double] = []
    
    @Published var frameHeight: CGFloat?
    
    var chartMin: Double? {
        guard let min = self.labels().min() else { return nil }
        return min < 0 ? min : 0
    }
    
    var chartMax: Double? {
        guard let max = self.labels().max() else { return nil }
        return max < 0 ? 0 : max
    }
    
    // MARK: - Public Properties
    
    @Published public var minGridlineSpacing: CGFloat = 40.0
    
    // MARK: - Private Properties
    
    private var minValue: Double? {
        self.data.min() ?? nil
    }
    
    private var maxValue: Double? {
        self.data.max() ?? nil
    }
    
    private var max: Double? {
        guard let maxValue = self.maxValue else { return nil }
        return maxValue < 0 ? 0 : maxValue
    }
    
    private var min: Double? {
        guard let minValue = self.minValue else { return nil }
        return minValue < 0 ? minValue : 0
    }
    
    private var maxGridlinesCount: Int? {
        guard let frameHeight = self.frameHeight,
            self.minGridlineSpacing != 0 else { return nil }
        return Int(frameHeight / self.minGridlineSpacing)
    }
    
    // MARK: - Internal Methods
    
    override func formattedLabels() -> [String] {
        guard let step = self.step() else { return [] }
        return YValueFormatter.formatValues(self.labels(), step: step)
    }
    
    func labelValue(at index: Int) -> Double {
        return self.labels()[index]
    }
    
    func pixelsRatio() -> CGFloat? {
        guard let frameHeight = self.frameHeight,
            let verticalDistance = self.verticalDistance(),
            verticalDistance != 0 else { return nil }
        return frameHeight / CGFloat(verticalDistance)
    }
    
    func step() -> Double? {
        guard let min = self.min,
            let max = self.max,
            let maxGridlinesCount = self.maxGridlinesCount,
            maxGridlinesCount != 0 else { return nil }
        let absoluteMax = Swift.max(abs(max), abs(min))
        let absoluteMin = Swift.min(abs(max), abs(min))
        let distance = absoluteMax + absoluteMin
        let step = distance / Double(maxGridlinesCount)
        let roundedStep = self.roundUp(step)
        return roundedStep
    }
    
    func centre() -> CGFloat? {
        guard let chartMin = self.chartMin,
            let pixelsRatio = self.pixelsRatio() else { return nil }
        return CGFloat(chartMin) * pixelsRatio
    }
       
    func normalizedValues() -> [Double] {
        guard let verticalDistance = self.verticalDistance(),
            verticalDistance != 0 else { return [] }
        return self.data.map { $0 / verticalDistance }
    }
    
    // MARK: - Private Methods
    
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
    
    private func verticalDistance() -> Double? {
        guard let chartMax = self.chartMax,
            let chartMin = self.chartMin else { return nil }
        return abs(chartMax) + abs(chartMin)
    }
    
    private func labels() -> [Double] {
        guard let step = self.step(),
            let min = self.min,
            let max = self.max else { return [] }
        var labels = [Double]()
        var count = 0.0
        
        // Add positive Y values
        while count < max {
            count += step
            labels.append(count)
        }
        
        count = 0.0
        labels.append(count)
        
        // Add negative Y values
        while count > min {
            count -= step
            labels.append(count)
        }
        return labels
    }
}
