//
//  BarChartView.swift
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

public struct BarChartView : View {
    @ObservedObject var config: ChartConfiguration
    
    public init(config: ChartConfiguration) {
        self.config = config
    }
    
    public var body: some View {
        ZStack {
            GeometryReader { proxy in
                CoordinateSystemView(yAxis: YAxis(frameHeight: proxy.size.height,
                                                  data: self.config.data.yValues,
                                                  ref: self.config.yAxis),
                                     xAxis: XAxis(frameWidth: proxy.size.width,
                                                  data: self.config.data.entries,
                                                  ref: self.config.xAxis),
                                     frameSize: proxy.size,
                                     labelOffsetY: self.bottomPadding())
                    .onReceive(self.config.objectWillChange) { _ in
                        print("changed")
                    }
                BarChartCollectionView(yAxis: YAxis(frameHeight: proxy.size.height,
                                                    data: self.config.data.yValues,
                                                    ref: self.config.yAxis),
                                       xAxis: XAxis(frameWidth: proxy.size.width,
                                                    data: self.config.data.entries,
                                                    ref: self.config.xAxis),
                                       gradient: self.config.data.gradientColor?.gradient(),
                                       color: self.config.data.color,
                                       frameHeight: proxy.size.height)
            }
            .padding([.top], self.topPadding())
            .padding([.bottom], self.bottomPadding())
        }
    }
    
    private func xAxis(width: CGFloat) -> XAxis {
        return XAxis(frameWidth: width,
                     data: self.config.data.entries,
                     ref: self.config.xAxis)
    }
    
    private func yAxis(height: CGFloat) -> YAxis {
        return YAxis(frameHeight: height,
                     data: self.config.data.yValues,
                     ref: self.config.yAxis)
    }
    
    private func topPadding() -> CGFloat {
        return String().height(ctFont: self.config.yAxis.labelsCTFont) / 2
    }
    
    private func bottomPadding() -> CGFloat {
        return self.topPadding() + String().height(ctFont: self.config.xAxis.labelsCTFont)
    }
}
