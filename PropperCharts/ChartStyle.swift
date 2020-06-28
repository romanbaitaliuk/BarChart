//
//  Helpers.swift
//  ProperCharts
//
//  Created by Roman Baitaliuk on 28/04/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public protocol ChartStyle {
    var backgroundColor: Color { get }
    var gradientColor: GradientColor { get }
    var labelColor: Color { get }
    var gridlineColor: Color { get }
    var dropShadowColor: Color { get }
}
