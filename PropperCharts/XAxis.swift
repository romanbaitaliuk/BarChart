//
//  XAxis.swift
//  ProperCharts
//
//  Created by Roman Baitaliuk on 21/06/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public class XAxis: AxisBase {    
    @Published var data: [String] = []
    
    @Published var frameWidth: CGFloat?
    
    var barWidth: CGFloat {
        guard let frameWidth = self.frameWidth,
            !self.data.isEmpty else { return 0 }
        return frameWidth / (CGFloat(self.data.count) * 1.5)
    }
    
    var spacing: CGFloat {
        guard let frameWidth = self.frameWidth,
            !self.data.isEmpty else { return 0 }
        return frameWidth / CGFloat((self.data.count - 1) * 3)
    }
    
    func barCentre(at index: Int) -> CGFloat {
        guard self.frameWidth != nil else { return 0 }
        let centre = self.barWidth / 2
        return self.barWidth * CGFloat(index + 1) + self.spacing * CGFloat(index) - centre
    }
    
    func formattedLabels() -> [String] {
        guard let frameWidth = self.frameWidth,
            !self.data.isEmpty else { return [] }
        let totalLabelsWidth = self.data.compactMap { $0.width(font: self.labelUIFont) }.reduce(0, +)
        let averageLabelWidth = totalLabelsWidth / CGFloat(data.count)
        let maxNumberOfLabels = Int((frameWidth / averageLabelWidth))
        guard maxNumberOfLabels > 0,
            maxNumberOfLabels <= self.data.count else { return self.data }
        return self.calculateLabels(step: 2, max: maxNumberOfLabels)
    }
    
    private func calculateLabels(step: Int, max: Int) -> [String] {
        let reversedData = Array(self.data.reversed())
        var finalLabels = [String]()
        for index in stride(from: 0, through: self.data.count - 1, by: step) {
            finalLabels.append(reversedData[index])
        }
        if finalLabels.count > max {
            return self.calculateLabels(step: step + 1, max: max)
        }
        return Array(finalLabels.reversed())
    }
}
