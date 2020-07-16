//
//  BarChartView.swift
//  BarChart
//
//  Created by Roman Baitaliuk on 28/04/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public struct BarChartView : View {
    @ObservedObject public var config = ChartConfiguration()

    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()
    
    public init() {}
    
    public var body: some View {
        ZStack {
            GeometryReader { proxy in
                CoordinateSystemView(xAxis: self.config.xAxis,
                                     yAxis: self.config.yAxis,
                                     frameSize: proxy.size,
                                     labelOffsetY: self.bottomPadding())
                    .onAppear {
                        self.config.updateAxes(frameSize: proxy.size)
                    }
                    .onReceive(self.config.data.objectWillChange) { newData in
                        self.config.updateAxes(frameSize: proxy.size)
                    }
                    .onReceive(self.orientationChanged) { _ in
                        self.config.updateAxes(frameSize: proxy.size)
                    }
                BarChartCollectionView(xAxis: self.config.xAxis,
                                       yAxis: self.config.yAxis,
                                       gradient: self.config.data.gradientColor?.gradient(),
                                       color: self.config.data.color,
                                       frameHeight: proxy.size.height)
            }
            .padding([.top], self.topPadding())
            .padding([.bottom], self.bottomPadding())
        }
    }
    
    private func topPadding() -> CGFloat {
        return String().height(font: self.config.yAxis.labelsUIFont) / 2
    }
    
    private func bottomPadding() -> CGFloat {
        return self.topPadding() + String().height(font: self.config.xAxis.labelsUIFont)
    }
}
