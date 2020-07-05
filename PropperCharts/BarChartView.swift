//
//  BarChartView.swift
//  ProperCharts
//
//  Created by Roman Baitaliuk on 28/04/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public struct BarChartView : View {
    
    private let config: ChartConfiguration
    @State private var xAxis: XAxis
    @State private var yAxis: YAxis
    
    public init(config: ChartConfiguration) {
        self.config = config
        self._xAxis = State(initialValue: XAxis(data: config.data.xValues,
                                                labelColor: config.xAxis.labelColor,
                                                gridlineColor: config.xAxis.gridlineColor,
                                                labelCTFont: config.xAxis.labelFont,
                                                gridlineDash: config.xAxis.gridlineDash))
        self._yAxis = State(initialValue: YAxis(data: config.data.yValues,
                                                labelColor: config.yAxis.labelColor,
                                                gridlineColor: config.yAxis.gridlineColor,
                                                labelCTFont: config.yAxis.labelFont,
                                                gridlineDash: config.yAxis.gridlineDash,
                                                minGridlineSpacing: config.yAxis.minGridlineSpacing))
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
                    BarChartCollectionView(normalizedValues: self.yAxis.normalizedValues(),
                                           gradient: self.config.data.gradientColor,
                                           color: self.config.data.color,
                                           spacing: self.xAxis.spacing,
                                           barWidth: self.xAxis.barWidth,
                                           centre: self.yAxis.centre())
                        .padding([.trailing], self.yAxis.maxYLabelWidth)
                }
            }
            .padding([.top], self.topPadding())
            .padding([.bottom], self.bottomPadding())
        }.frame(minWidth: 0,
                maxWidth: self.config.frameSize.width,
                minHeight: self.config.frameSize.height,
                maxHeight: self.config.frameSize.height)
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
