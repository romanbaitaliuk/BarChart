//
//  BarChartCell.swift
//  StockFinancials
//
//  Created by Roman Baitaliuk on 28/04/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public struct BarChartCell: View {
    
    // MARK: - Properties
    
    let value: Double
    let index: Int
    let width: CGFloat
    let gradient: GradientColor
    
    @State var scaleValue: Double = 0
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(LinearGradient(gradient: self.gradient.getGradient(),
                                     startPoint: .bottom,
                                     endPoint: .top))
            }
            .frame(width: self.width)
            .scaleEffect(CGSize(width: 1, height: self.scaleValue), anchor: .bottom)
            .onAppear(){
                self.scaleValue = self.value
            }
            .animation(Animation.spring().delay(Double(self.index) * 0.04))
    }
}
