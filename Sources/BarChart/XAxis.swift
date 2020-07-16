//
//  XAxis.swift
//  BarChart
//
//  Created by Roman Baitaliuk on 21/06/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public class XAxis: AxisBase {
    
    // MARK: - Public Properties
    
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
        let totalLabelsWidth = self.data.compactMap { $0.x.width(font: self.labelsUIFont) }.reduce(0, +)
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
