//
//  BarChartCollection.swift
//  ProperCharts
//
//  Created by Roman Baitaliuk on 28/04/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI
import Foundation

public struct BarChartCollectionView: View {
    let data: [Double]
    let gradient: GradientColor
    
    public var body: some View {
        GeometryReader { proxy in
            HStack(alignment: .bottom,
                   spacing: self.xAxisLayout(proxy: proxy).spacing) {
                    ForEach(0..<self.data.count, id: \.self) { index in
                        BarChartCell(value: self.yAxis(proxy).normalizedValues()[index],
                                     index: index,
                                     width: self.xAxisLayout(proxy: proxy).barWidth,
                                     gradient: self.gradient)
                            .offset(y: self.yAxis(proxy).centre())
                    }
            }
        }
    }
    
    func xAxisLayout(proxy: GeometryProxy) -> XAxisLayout {
        return XAxisLayout(dataCount: self.data.count,
                           frameWidth: proxy.size.width)
    }
    
    func yAxis(_ proxy: GeometryProxy) -> YAxis {
        return YAxis(data: self.data, frameHeight: proxy.size.height)
    }
}
