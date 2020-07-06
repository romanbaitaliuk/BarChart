//
//  BarChartView.swift
//  ProperCharts
//
//  Created by Roman Baitaliuk on 28/04/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public struct BarChartView : View {
    
    private var config: ChartConfiguration = ChartConfiguration()
    
    @State var xAxis: XAxis
    @State var yAxis: YAxis
    var data: ChartData
    let frameSize: CGSize
    
    public init(data: ChartData, frameSize: CGSize) {
        self.data = data
        self.frameSize = frameSize
        self._xAxis = State(initialValue: XAxis(data: data.xValues,
                                                frameWidth: nil))
        self._yAxis = State(initialValue: YAxis(data: data.yValues,
                                                frameHeight: nil))
    }
    
    public var body: some View {
        ZStack {
            Rectangle()
                .fill(self.config.backgroundColor)
                .shadow(color: self.config.dropShadowColor,
                        radius: self.config.dropShadow ? 8 : 0)
            Group {
                GeometryReader { proxy in
                    CoordinateSystemView(xAxis: self.xAxis,
                                         yAxis: self.yAxis,
                                         frameSize: proxy.size,
                                         labelOffsetY: self.bottomPadding())
                        .onAppear {
                            // Recalculate axes in the exact order
                            self.updateYAxis(proxy)
                            self.updateXAxis(proxy)
                        }
                        .onReceive(self.data.objectWillChange) { newData in
                            self.xAxis.data = self.data.xValues
                            self.yAxis.data = self.data.yValues
                        }
                    BarChartCollectionView(normalizedValues: self.yAxis.normalizedValues(),
                                           gradient: self.data.gradientColor,
                                           color: self.data.color,
                                           spacing: self.xAxis.spacing,
                                           barWidth: self.xAxis.barWidth,
                                           centre: self.yAxis.centre())
                        .padding([.trailing], self.yAxis.maxYLabelWidth)
                }
            }
            .padding([.top], self.topPadding())
            .padding([.bottom], self.bottomPadding())
        }.frame(minWidth: 0,
                maxWidth: self.frameSize.width,
                minHeight: self.frameSize.height,
                maxHeight: self.frameSize.height)
    }
    
    func topPadding() -> CGFloat {
        return String().height(font: self.yAxis.labelUIFont) / 2
    }
    
    func bottomPadding() -> CGFloat {
        return self.topPadding() + String().height(font: self.xAxis.labelUIFont)
    }
    
    func updateXAxis(_ proxy: GeometryProxy) {
        let frameWidth = proxy.size.width - self.yAxis.maxYLabelWidth
        if self.xAxis.frameWidth == nil {
            self.xAxis.frameWidth = frameWidth
        }
    }
    
    func updateYAxis(_ proxy: GeometryProxy) {
        let frameHeight = proxy.size.height
        if self.yAxis.frameHeight == nil {
            self.yAxis.frameHeight = frameHeight
        }
    }
}

extension String {
    func width(font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func height(font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
}
