//
//  BarChartView.swift
//  ProperCharts
//
//  Created by Roman Baitaliuk on 28/04/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public struct BarChartView : View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    private let data: ChartData
    public let style: ChartStyle
    public let darkModeStyle: ChartStyle?
    public let dropShadow: Bool
    public let frameSize: CGSize
    
    public init(data: ChartData,
                style: ChartStyle,
                darkModeStyle: ChartStyle? = nil,
                dropShadow: Bool = false,
                frameSize: CGSize) {
        self.data = data
        self.style = style
        self.darkModeStyle = darkModeStyle
        self.dropShadow = dropShadow
        self.frameSize = frameSize
    }
    
    public var body: some View {
        ZStack {
            Rectangle()
                .fill(self.currentStyle().backgroundColor)
                .shadow(color: self.currentStyle().dropShadowColor,
                        radius: self.dropShadow ? 8 : 0)
            Group {
                GeometryReader { proxy in
                    AxesGridView(data: self.data,
                                 gridlineColor: self.currentStyle().gridlineColor,
                                 labelColor: self.currentStyle().labelColor,
                                 xAxis: self.xAxis(proxy),
                                 yAxis: self.yAxis(proxy),
                                 frameSize: proxy.size)
                    BarChartCollectionView(normalizedValues: self.yAxis(proxy).normalizedValues(),
                                           gradient: self.currentStyle().gradientColor,
                                           layout: self.xAxis(proxy).layout,
                                           centre: self.yAxis(proxy).centre())
                        .padding([.trailing], self.maxYLabelWidth(proxy))
                }
            }
            .padding([.top], AxisLabelUtils.halfHeight)
            .padding([.bottom], AxisLabelUtils.height + AxisLabelUtils.halfHeight)
        }.frame(minWidth: 0,
                maxWidth: self.frameSize.width,
                minHeight: self.frameSize.height,
                maxHeight: self.frameSize.height)
    }
    
    func maxYLabelWidth(_ proxy: GeometryProxy) -> CGFloat {
        return AxisLabelUtils.maxWidth(yValues: self.data.yValues,
                                       frameHeight: proxy.size.height)
    }
    
    func currentStyle() -> ChartStyle {
        if let darkModeStyle = self.darkModeStyle {
            return self.colorScheme == .dark ? darkModeStyle : self.style
        } else {
            return self.style
        }
    }
    
    func xAxis(_ proxy: GeometryProxy) -> XAxis {
        let frameWidth = proxy.size.width - self.maxYLabelWidth(proxy)
        return XAxis(data: self.data.xValues, frameWidth: frameWidth)
    }
    
    func yAxis(_ proxy: GeometryProxy) -> YAxis {
        return YAxis(data: self.data.yValues, frameHeight: proxy.size.height)
    }
}
