//
//  BarChartView.swift
//  ProperCharts
//
//  Created by Roman Baitaliuk on 28/04/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public struct BarChartView : View {
    
    public var config = ChartConfiguration()
    
    @State private var xAxis = XAxis()
    
    @State private var yAxis = YAxis()
    
    public init() {}
    
    public var body: some View {
        ZStack {
            GeometryReader { proxy in
                CoordinateSystemView(xAxis: self.xAxis,
                                     yAxis: self.yAxis,
                                     frameSize: proxy.size,
                                     labelOffsetY: self.bottomPadding())
                    .onAppear {
                        self.updateAxes(proxy)
                    }
                    .onReceive(self.config.data.objectWillChange) { newData in
                        self.updateAxes(proxy)
                    }
                BarChartCollectionView(xAxis: self.xAxis,
                                       yAxis: self.yAxis,
                                       gradient: self.config.data.gradientColor,
                                       color: self.config.data.color,
                                       frameHeight: proxy.size.height)
            }
            .padding([.top], self.topPadding())
            .padding([.bottom], self.bottomPadding())
        }
    }
    
    func topPadding() -> CGFloat {
        return String().height(font: self.yAxis.labelUIFont) / 2
    }
    
    func bottomPadding() -> CGFloat {
        return self.topPadding() + String().height(font: self.xAxis.labelUIFont)
    }
    
    func updateAxes(_ proxy: GeometryProxy) {
        self.updateAxesData()
        self.updateAxesFrame(proxy)
    }
    
    func updateAxesData() {
        self.xAxis.data = self.config.data.xValues
        self.yAxis.data = self.config.data.yValues
    }
    
    func updateAxesFrame(_ proxy: GeometryProxy) {
        let frameWidth = proxy.size.width - self.yAxis.maxYLabelWidth
        self.xAxis.frameWidth = frameWidth
        
        let frameHeight = proxy.size.height
        self.yAxis.frameHeight = frameHeight
    }
}
