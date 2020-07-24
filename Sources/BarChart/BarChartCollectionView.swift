//
//  BarChartCollection.swift
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

struct BarChartCollectionView: View {
    let yAxis: YAxis
    let xAxis: XAxis
    let gradient: Gradient?
    let color: Color
    
    var body: some View {
        HStack(alignment: .bottom,
               spacing: self.xAxis.layout.spacing) {
                if self.xAxis.layout.barWidth != nil {
                    ForEach(0..<self.yAxis.normalizedValues().count, id: \.self) { index in
                        BarChartCell(width: self.xAxis.layout.barWidth!,
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
        let positivePart = absoluteMax * self.yAxis.frameHeight
        let topPadding = String().height(ctFont: self.xAxis.labelsCTFont) / 2
        return self.yAxis.frameHeight - abs(centre) - positivePart + topPadding
    }
    
    func offsetX() -> CGFloat {
        guard let spacing = self.xAxis.layout.spacing else { return 0 }
        // Getting offset when only one entry is shown
        return self.xAxis.data.count == 1 ? spacing : 0
    }
    
    func barHeight(at index: Int) -> CGFloat {
        return CGFloat(self.yAxis.normalizedValues()[index]) * self.yAxis.frameHeight
    }
}
