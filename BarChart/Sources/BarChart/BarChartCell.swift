//
//  BarChartCell.swift
//  ProperCharts
//
//  Created by Roman Baitaliuk on 28/04/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

struct BarChartCell: View {
    let width: CGFloat
    let height: CGFloat
    let gradient: Gradient?
    let color: Color
    
    var body: some View {
        Group {
            if self.gradient != nil {
                GradientColorRectangle(gradient: self.gradient!)
            } else {
                SolidColorRectangle(color: self.color)
            }
        }.frame(width: self.width, height: self.height)
    }
}

struct SolidColorRectangle: View {
    let color: Color
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(self.color)
    }
}

struct GradientColorRectangle: View {
    let gradient: Gradient
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(LinearGradient(gradient: self.gradient,
                                 startPoint: .bottom,
                                 endPoint: .top))
    }
}
