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
    let normalizedValues: [Double]
    let gradient: GradientColor
    let layout: XAxisLayout
    let centre: CGFloat
    
    public var body: some View {
        HStack(alignment: .bottom,
               spacing: self.layout.spacing) {
                ForEach(0..<self.normalizedValues.count, id: \.self) { index in
                    BarChartCell(value: self.normalizedValues[index],
                                 index: index,
                                 width: self.layout.barWidth,
                                 gradient: self.gradient)
                        .offset(y: self.centre)
                }
        }
    }
}
