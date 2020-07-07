//
//  BarChartCollection.swift
//  ProperCharts
//
//  Created by Roman Baitaliuk on 28/04/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public struct BarChartCollectionView: View {
    let xAxis: XAxis
    let yAxis: YAxis
    let gradient: GradientColor?
    let color: Color
    let frameHeight: CGFloat
    
    public var body: some View {
        HStack(alignment: .bottom,
               spacing: self.xAxis.spacing) {
                ForEach(0..<self.yAxis.normalizedValues().count, id: \.self) { index in
                    BarChartCell(width: self.xAxis.barWidth,
                                 height: self.barHeight(at: index),
                                 gradient: self.gradient,
                                 color: self.color)
                }
        }.offset(y: self.offsetY())
    }
    
    func offsetY() -> CGFloat {
        let maxNormalizedValue = self.yAxis.normalizedValues().max() ?? 0
        let chartNormalisedMax = maxNormalizedValue > 0 ? maxNormalizedValue : 0
        let absoluteMax = abs(CGFloat(chartNormalisedMax))
        let positivePart = absoluteMax * self.frameHeight
        return self.frameHeight-abs(self.yAxis.centre()) - positivePart
    }
    
    func barHeight(at index: Int) -> CGFloat {
        return CGFloat(self.yAxis.normalizedValues()[index]) * self.frameHeight
    }
}
