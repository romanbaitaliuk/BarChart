//
//  BarChartCollection.swift
//  ProperCharts
//
//  Created by Roman Baitaliuk on 28/04/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

struct BarChartCollectionView: View {
    @ObservedObject var xAxis: XAxis
    @ObservedObject var yAxis: YAxis
    let gradient: Gradient?
    let color: Color
    let frameHeight: CGFloat
    
    var body: some View {
        HStack(alignment: .bottom,
               spacing: self.xAxis.layout?.spacing) {
                if self.xAxis.layout?.barWidth != nil {
                    ForEach(0..<self.yAxis.normalizedValues().count, id: \.self) { index in
                        BarChartCell(width: self.xAxis.layout!.barWidth!,
                                     height: self.barHeight(at: index),
                                     gradient: self.gradient,
                                     color: self.color)
                            .offset(x: self.offsetX(),
                                    y: self.offsetY())
                    }
                }
        }
    }
    
    func offsetY() -> CGFloat {
        guard let maxNormalizedValue = self.yAxis.normalizedValues().max(),
            let centre = self.yAxis.centre() else { return 0 }
        let chartNormalisedMax = maxNormalizedValue > 0 ? maxNormalizedValue : 0
        let absoluteMax = abs(CGFloat(chartNormalisedMax))
        let positivePart = absoluteMax * self.frameHeight
        return self.frameHeight-abs(centre) - positivePart
    }
    
    func offsetX() -> CGFloat {
        guard let spacing = self.xAxis.layout?.spacing else { return 0 }
        // Getting offset when only one entry is shown
        return self.xAxis.data.count == 1 ? spacing : 0
    }
    
    func barHeight(at index: Int) -> CGFloat {
        return CGFloat(self.yAxis.normalizedValues()[index]) * self.frameHeight
    }
}
