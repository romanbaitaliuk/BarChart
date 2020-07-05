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
    
    @State public var xAxis: XAxis = XAxis()
    @State public var yAxis: YAxis = YAxis()
    
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
                    CoordinateSystemView(xAxis: self.xAxis,
                                         yAxis: self.yAxis,
                                         frameSize: proxy.size,
                                         labelOffsetY: self.bottomPadding())
                        .onAppear {
                            // Recalculate axes in the exact order
                            self.updateYAxis(proxy)
                            self.updateXAxis(proxy)
                        }
                    BarChartCollectionView(normalizedValues: self.yAxis.normalizedValues(),
                                           gradient: self.currentStyle().gradientColor,
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
    
    func currentStyle() -> ChartStyle {
        if let darkModeStyle = self.darkModeStyle {
            return self.colorScheme == .dark ? darkModeStyle : self.style
        } else {
            return self.style
        }
    }
    
    func updateXAxis(_ proxy: GeometryProxy) {
        let frameWidth = proxy.size.width - self.yAxis.maxYLabelWidth
        if self.xAxis.frameWidth == nil {
            self.xAxis.frameWidth = frameWidth
            
            // TODO: Set data in another place
            self.xAxis.data = self.data.xValues
        }
    }
    
    func updateYAxis(_ proxy: GeometryProxy) {
        let frameHeight = proxy.size.height
        if self.yAxis.frameHeight == nil {
            self.yAxis.frameHeight = frameHeight
            
            // TODO: Set data in another place
            self.yAxis.data = self.data.yValues
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
