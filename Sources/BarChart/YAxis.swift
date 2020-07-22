//
//  YAxisLayout.swift
//  BarChart
//
//  Copyright (c) 2020 Roman Baitaliuk
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

import SwiftUI

struct YAxis: Identifiable {
    let id = UUID()
    let data: [Double]
    let frameHeight: CGFloat
    let ref: YAxisReference
    
    var scaler: YAxisScaler? {
        guard let minValue = self.data.min(),
            let maxValue = self.data.max(),
            let maxTicks = self.maxTicks else {
                return nil
        }
        let adjustedMin = minValue > 0 ? 0 : minValue
        let adjustedMax = maxValue < 0 ? 0 : maxValue
        return YAxisScaler(min: adjustedMin, max: adjustedMax, maxTicks: maxTicks)
    }
    
    var maxLabelWidth: CGFloat {
        return self.formattedLabels().map { $0.width(ctFont: self.ref.labelsCTFont) }.max() ?? 0
    }
    
    init(frameHeight: CGFloat,
         data: [Double],
         ref: YAxisReference) {
        self.frameHeight = frameHeight
        self.data = data
        self.ref = ref
    }
    
    private var maxTicks: Int? {
        guard self.ref.minTicksSpacing != 0 else { return nil }
        return Int(frameHeight / self.ref.minTicksSpacing)
    }
    
    func formattedLabels() -> [String] {
        guard let tickSpacing = self.scaler?.tickSpacing else { return [] }
        return self.scaler?.scaledValues().map { self.ref.formatter($0, tickSpacing.decimalsCount()) } ?? []
    }
    
    func labelValue(at index: Int) -> Double? {
        return self.scaler?.scaledValues()[index]
    }
    
    func pixelsRatio() -> CGFloat? {
        guard let verticalDistance = self.verticalDistance(),
            verticalDistance != 0 else { return nil }
        return frameHeight / CGFloat(verticalDistance)
    }
    
    func centre() -> CGFloat? {
        guard let chartMin = self.scaler?.scaledMin,
            let pixelsRatio = self.pixelsRatio() else { return nil }
        return CGFloat(chartMin) * pixelsRatio
    }
       
    func normalizedValues() -> [Double] {
        guard let verticalDistance = self.verticalDistance(),
            verticalDistance != 0 else { return [] }
        return self.data.map { $0 / verticalDistance }
    }
    
    private func verticalDistance() -> Double? {
        guard let chartMax = self.scaler?.scaledMax,
            let chartMin = self.scaler?.scaledMin else { return nil }
        return abs(chartMax) + abs(chartMin)
    }
}
