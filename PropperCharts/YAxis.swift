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
    
    private func step() -> Double {
        // If average value is under range 1
        let absoluteMax = Swift.max(abs(self.max), abs(self.min))
        let absoluteMin = Swift.min(abs(self.max), abs(self.min))
        
        if self.minValue > 0 || self.maxValue < 0 {
            return absoluteMax * 1.1 / 3
        } else {
            let step = absoluteMin * 1.1
            let maxPositiveStepCount = (absoluteMax / step).rounded(.up)
            if maxPositiveStepCount >= 2 && maxPositiveStepCount <= 3 {
                return step
            } else {
                return absoluteMax * 1.1 / 3
            }
        }
    }
    
    private func roundedStep() -> Double {
        // TODO: Check scenario when rounding can break max/min
        return round(self.step() * 20) / 20
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
        let step = self.roundedStep()
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
