//
//  YAxisLayout.swift
//  StockFinancials
//
//  Created by Roman Baitaliuk on 19/06/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

struct YAxis {
    let data: [Double]
    
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
    
    func pixelsRatio(proxy: GeometryProxy) -> CGFloat {
        return proxy.size.height / CGFloat(self.verticalDistance())
    }
    
    func step() -> Double {
        let absoluteMax = Swift.max(abs(self.max), abs(self.min))
        let absoluteMin = Swift.min(abs(self.max), abs(self.min))
        
        if self.minValue > 0 || self.maxValue < 0 {
            return self.adjustValue(absoluteMax / 3)
        } else {
            let step = absoluteMin
            let maxPositiveStepCount = (absoluteMax / step).rounded(.up)
            if maxPositiveStepCount >= 2 && maxPositiveStepCount <= 3 {
                return self.adjustValue(step)
            } else {
                return self.adjustValue(absoluteMax / 3)
            }
        }
    }
    
    private func adjustValue(_ value: Double,
                             by percent: Int = 0) -> Double {
        let adj = Double(percent) / 100.0 + 1
        let roundedValue = self.roundUp(value * adj)!
        let changeInProcent = (roundedValue - value) / value * 100
        if changeInProcent < 5 {
            return self.adjustValue(value, by: percent + 1)
        }
        return roundedValue
    }
    
    private func roundUp(_ value: Double) -> Double? {
        if value > 0 && value < 1 {
            let digitsCount = value.zerosCountAfterPoint() + 2
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
            return nil
        }
    }
    
    func centre(proxy: GeometryProxy) -> CGFloat {
        return CGFloat(self.chartMin) * self.pixelsRatio(proxy: proxy)
    }
    
    func normalizedValue(at index: Int) -> Double {
        return self.data[index] / self.verticalDistance()
    }
    
    private func verticalDistance() -> Double {
        return abs(self.chartMax) + abs(self.chartMin)
    }
    
    func labels() -> [Double] {
        var labels = [Double]()
        let step = self.step()
        var count = 0.0
        
        if self.min > 0 {
            // Add positive Y values
            while count < self.max {
                count += step
                labels.append(count)
            }
        } else if self.max < 0 {
            // Add negative Y values
            while count > self.min {
                count += -1.0 * step
                labels.append(count)
            }
        } else {
            // Add positive Y values
            while count < self.max {
                count += step
                labels.append(count)
            }
            
            count = 0.0
            
            // Add negative Y values
            while count > self.min {
                count += -1.0 * step
                labels.append(count)
            }
        }
        return labels
    }
    
    func label(at index: Int) -> Double {
        return self.labels()[index]
    }
}

extension Int {
    func digitsCount() -> Int {
        if abs(self) < 10 {
            return 1
        } else {
            return 1 + (self/10).digitsCount()
        }
    }
}

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
    
    func zerosCountAfterPoint() -> Int {
        let valueString = String(self)
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
}
