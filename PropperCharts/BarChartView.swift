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
            AxesGridView(data: self.data,
                         gridlineColor: self.currentStyle().gridlineColor,
                         labelColor: self.currentStyle().labelColor)
                .padding([.top], AxisLabelUtils.halfHeight)
                .padding([.bottom], AxisLabelUtils.height + AxisLabelUtils.halfHeight)
            BarChartCollectionView(data: self.data.yValues,
                                   gradient: self.currentStyle().gradientColor)
                .padding([.trailing], AxisLabelUtils.maxWidth(yValues: self.data.yValues,
                                                              frameHeight: self.frameSize.height - AxisLabelUtils.height * 2))
                .padding([.top], AxisLabelUtils.halfHeight)
                .padding([.bottom], AxisLabelUtils.height + AxisLabelUtils.halfHeight)
        }.frame(minWidth: 0,
                maxWidth: self.frameSize.width,
                minHeight: self.frameSize.height,
                maxHeight: self.frameSize.height)
    }
    
    func currentStyle() -> ChartStyle {
        if let darkModeStyle = self.darkModeStyle {
            return self.colorScheme == .dark ? darkModeStyle : self.style
        } else {
            return self.style
        }
    }
}
