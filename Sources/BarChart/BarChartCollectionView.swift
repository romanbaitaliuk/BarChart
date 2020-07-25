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
        ZStack {
            if self.xAxis.layout.barWidth != nil {
                ForEach(0..<self.yAxis.normalizedValues().count, id: \.self) { index in
                    BarChartCell(width: self.xAxis.layout.barWidth!,
                                 cornerRadius: 3.0,
                                 startPoint: self.startPoint(at: index),
                                 endPoint: self.endPoint(at: index),
                                 gradient: self.gradient,
                                 color: self.color)
                        .animation(Animation.easeInOut.delay(Double(index) * 0.04))
                        .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                }
            }
        }
    }
    
    func offsetY() -> CGFloat {
        guard let centre = self.yAxis.centre() else { return 0 }
        let bottomPadding = String().height(ctFont: self.xAxis.labelsCTFont) * 1.5
        return abs(centre) + bottomPadding
    }
    
    func startPoint(at index: Int) -> CGPoint {
        return CGPoint(x: self.xAxis.layout.barCentre(at: index)!, y: self.offsetY())
    }
    
    func endPoint(at index: Int) -> CGPoint {
        let endY = self.barHeight(at: index) + self.offsetY()
        return CGPoint(x: self.xAxis.layout.barCentre(at: index)!, y: endY)
    }
    
    func barHeight(at index: Int) -> CGFloat {
        return CGFloat(self.yAxis.normalizedValues()[index]) * self.yAxis.frameHeight
    }
}
