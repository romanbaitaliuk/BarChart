//
//  XAxis.swift
//  ProperCharts
//
//  Created by Roman Baitaliuk on 21/06/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public struct XAxis: AxisBase {
    var data: [String]?
    var frameWidth: CGFloat?
    
    var barWidth: CGFloat {
        guard let frameWidth = self.frameWidth,
            let data = self.data else { return 0 }
        return frameWidth / (CGFloat(data.count) * 1.5)
    }
    
    var spacing: CGFloat {
        guard let frameWidth = self.frameWidth,
            let data = self.data else { return 0 }
        return frameWidth / CGFloat((data.count - 1) * 3)
    }
    
    func barCentre(at index: Int) -> CGFloat {
        let centre = self.barWidth / 2
        return self.barWidth * CGFloat(index + 1) + self.spacing * CGFloat(index) - centre
    }
    
    func formattedLabels() -> [String] {
        guard let frameWidth = self.frameWidth,
            let data = self.data else { return [] }
        let totalLabelsWidth = data.compactMap { $0.width(font: self.labelUIFont) }.reduce(0, +)
        let averageLabelWidth = totalLabelsWidth / CGFloat(data.count)
        let maxNumberOfLabels = Int((frameWidth / averageLabelWidth))
        guard maxNumberOfLabels > 0,
            maxNumberOfLabels <= data.count else { return data }
        return self.calculateLabels(step: 2, max: maxNumberOfLabels)
    }
    
    private func calculateLabels(step: Int, max: Int) -> [String] {
        guard let data = self.data else { return [] }
        let reversedData = Array(data.reversed())
        var finalLabels = [String]()
        for index in stride(from: 0, through: data.count - 1, by: step) {
            finalLabels.append(reversedData[index])
        }
        if finalLabels.count > max {
            return self.calculateLabels(step: step + 1, max: max)
        }
        return Array(finalLabels.reversed())
    }
}
