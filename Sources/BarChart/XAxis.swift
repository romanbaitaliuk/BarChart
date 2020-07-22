//
//  XAxis.swift
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

struct XAxis: Identifiable {
    let id = UUID()
    let data: [ChartDataEntry]
    let frameWidth: CGFloat
    let ref: XAxisReference
    
    var layout: XAxisLayout {
        XAxisLayout(frameWidth: self.frameWidth, dataCount: self.data.count)
    }
    
    init(frameWidth: CGFloat,
         data: [ChartDataEntry],
         ref: XAxisReference) {
        self.frameWidth = frameWidth
        self.data = data
        self.ref = ref
    }
    
    func chartEntry(at index: Int) -> ChartDataEntry {
        return self.labels()[index]
    }
    
    func formattedLabels() -> [String] {
        return self.labels().map { $0.x }
    }
    
    private func labels() -> [ChartDataEntry] {
        guard !self.data.isEmpty else { return [] }
        let totalLabelsWidth = self.data.compactMap { $0.x.width(ctFont: self.ref.labelsCTFont) }.reduce(0, +)
        let averageLabelWidth = totalLabelsWidth / CGFloat(data.count)
        
        guard averageLabelWidth != 0 else { return [] }
        let maxLabelsCount = Int((frameWidth / averageLabelWidth))
        
        if let interval = self.ref.ticksInterval {
            return self.calculateLabels(with: interval, to: maxLabelsCount)
        }
        
        if maxLabelsCount > 0, maxLabelsCount < self.data.count {
            return self.calculateLabels(with: 2, to: maxLabelsCount)
        } else {
            return self.data
        }
    }
    
    private func calculateLabels(with interval: Int,
                                 to maxLabelsCount: Int) -> [ChartDataEntry] {
        let reversedData = Array(self.data.reversed())
        var finalLabels = [ChartDataEntry]()
        for index in stride(from: 0, through: self.data.count - 1, by: interval) {
            finalLabels.append(reversedData[index])
        }
        if finalLabels.count > maxLabelsCount {
            let adj = self.ref.ticksInterval ?? 1
            return self.calculateLabels(with: interval + adj, to: maxLabelsCount)
        }
        return Array(finalLabels.reversed())
    }
}
