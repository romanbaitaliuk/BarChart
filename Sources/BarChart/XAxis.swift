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

public class XAxis: AxisBase {
    
    // MARK: - Public Properties
    
    /// Horizontal interval between the bars
    @Published public var ticksInterval: Int? {
        didSet {
            self.validateTicksInterval()
        }
    }
    
    // MARK: - Internal Properties
    
    @Published var data: [ChartDataEntry] = [] {
        didSet {
            self.updateLayout()
        }
    }
    
    @Published var frameWidth: CGFloat? {
        didSet {
            self.updateLayout()
        }
    }
    
    var layout: XAxisLayout?
    
    // MARK: - Internal Methods
    
    func chartEntry(at index: Int) -> ChartDataEntry {
        return self.labels()[index]
    }
    
    override func formattedLabels() -> [String] {
        return self.labels().map { $0.x }
    }
    
    // MARK: - Private Methods
    
    private func labels() -> [ChartDataEntry] {
        guard let frameWidth = self.frameWidth,
            !self.data.isEmpty else { return [] }
        let totalLabelsWidth = self.data.compactMap { $0.x.width(ctFont: self.labelsCTFont) }.reduce(0, +)
        let averageLabelWidth = totalLabelsWidth / CGFloat(data.count)
        
        guard averageLabelWidth != 0 else { return [] }
        let maxLabelsCount = Int((frameWidth / averageLabelWidth))
        
        if let interval = self.ticksInterval {
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
            let adj = self.ticksInterval ?? 1
            return self.calculateLabels(with: interval + adj, to: maxLabelsCount)
        }
        return Array(finalLabels.reversed())
    }
    
    private func validateTicksInterval() {
        if let newValue = self.ticksInterval, newValue < 1 {
            self.ticksInterval = nil
        }
    }
    
    private func updateLayout() {
        guard let frameWidth = self.frameWidth else {
            self.layout = nil
            return
        }
        self.layout = XAxisLayout(frameWidth: frameWidth, dataCount: self.data.count)
    }
}
