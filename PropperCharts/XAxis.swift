//
//  XAxis.swift
//  ProperCharts
//
//  Created by Roman Baitaliuk on 21/06/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public struct XAxis: AxisBase {
    var data: [String] = []
    var frameWidth: CGFloat = 0
    
    var layout: XAxisLayout {
        return XAxisLayout(dataCount: self.data.count,
                           frameWidth: self.frameWidth)
    }
    
    func formattedLabels() -> [String] {
        guard self.frameWidth != 0 else { return [] }
        let totalLabelsWidth = self.data.compactMap { LabelDimensions.width(text: $0, font: self.labelUIFont) }.reduce(0, +)
        let averageLabelWidth = totalLabelsWidth / CGFloat(self.data.count)
        let maxNumberOfLabels = Int((self.frameWidth / averageLabelWidth))
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
