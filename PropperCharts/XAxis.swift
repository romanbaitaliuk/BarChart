//
//  XAxis.swift
//  ProperCharts
//
//  Created by Roman Baitaliuk on 21/06/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public class XAxis: AxisBase {
    
    // MARK: - Public Properties
    
    @Published public var labelInterval: Int?
    
    // MARK: - Internal Properties
    
    @Published var data: [ChartDataEntry] = []
    @Published var frameWidth: CGFloat?
    
    var barWidth: CGFloat? {
        guard let frameWidth = self.frameWidth,
            !self.data.isEmpty else { return nil }
        return frameWidth / (CGFloat(self.data.count) * 1.5)
    }
    
    var spacing: CGFloat? {
        guard let frameWidth = self.frameWidth,
            let barWidth = self.barWidth, !self.data.isEmpty else { return nil }
        if self.data.count == 1 {
            return (frameWidth - barWidth) / 2
        } else {
            return frameWidth / CGFloat((self.data.count - 1) * 3)
        }
    }
    
    // MARK: - Internal Methods
    
    func barCentre(at index: Int) -> CGFloat? {
        guard let barWidth = self.barWidth,
            let spacing = self.spacing else { return nil }
        if self.data.count == 1 {
            return spacing + barWidth / 2
        } else {
            let centre = barWidth / 2
            return barWidth * CGFloat(index + 1) + spacing * CGFloat(index) - centre
        }
    }
    
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
        let totalLabelsWidth = self.data.compactMap { $0.x.width(font: self.labelUIFont) }.reduce(0, +)
        let averageLabelWidth = totalLabelsWidth / CGFloat(data.count)
        
        guard averageLabelWidth != 0 else { return [] }
        let maxNumberOfLabels = Int((frameWidth / averageLabelWidth))
        
        if let labelInterval = self.labelInterval {
            return self.calculateLabels(step: labelInterval, max: maxNumberOfLabels)
        }
        
        if maxNumberOfLabels > 0, maxNumberOfLabels < self.data.count {
            return self.calculateLabels(step: 2, max: maxNumberOfLabels)
        } else {
            return self.data
        }
    }
    
    private func calculateLabels(step: Int, max: Int) -> [ChartDataEntry] {
        let reversedData = Array(self.data.reversed())
        var finalLabels = [ChartDataEntry]()
        for index in stride(from: 0, through: self.data.count - 1, by: step) {
            finalLabels.append(reversedData[index])
        }
        if finalLabels.count > max {
            let adj = self.labelInterval ?? 1
            return self.calculateLabels(step: step + adj, max: max)
        }
        return Array(finalLabels.reversed())
    }
}
