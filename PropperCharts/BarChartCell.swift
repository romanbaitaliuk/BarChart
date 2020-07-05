//
//  BarChartCell.swift
//  ProperCharts
//
//  Created by Roman Baitaliuk on 28/04/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

struct BarChartCell: View {
    let value: Double
    let index: Int
    let width: CGFloat
    let gradient: GradientColor?
    let color: Color
    
    @State var scaleValue: Double = 0
    
    var body: some View {
        ZStack {
            if self.gradient != nil {
                    GradientColorRectangle(gradient: self.gradient!)
                } else {
                    SolidColorRectangle(color: self.color)
                }
            }
            .frame(width: self.width)
            .scaleEffect(CGSize(width: 1, height: self.scaleValue), anchor: .bottom)
            .onAppear(){
                self.scaleValue = self.value
            }
            .animation(Animation.spring().delay(Double(self.index) * 0.04))
    }
}

struct SolidColorRectangle: View {
    let color: Color
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(color)
    }
}

struct GradientColorRectangle: View {
    let gradient: GradientColor
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(LinearGradient(gradient: self.gradient.getGradient(),
                                 startPoint: .bottom,
                                 endPoint: .top))
    }
}
