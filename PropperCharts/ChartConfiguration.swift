//
//  ChartConfiguration.swift
//  PropperCharts
//
//  Created by Roman Baitaliuk on 4/07/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

protocol ChartConfiguration {
    var data: ChartData { get }
    
    // Styles
    var backgroundColor: Color { get }
    var dropShadowColor: Color { get }
    
    // Data set
    var gradientColor: GradientColor { get }
    
    // Y axis
    var gridlineSpecing: CGFloat { get }
    
    // X Axis
    var barWidth: CGFloat { get }
    var barSpacing: CGFloat { get }
}
