//
//  ChartConfiguration.swift
//  PropperCharts
//
//  Created by Roman Baitaliuk on 5/07/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public struct AxisBaseSettings {
    public var labelColor: Color = Color("labelColor", bundle: Bundle.current)
    public var gridlineColor: Color = Color("gridlineColor", bundle: Bundle.current)
    public var gridlineDash: [CGFloat] =  [5, 10]
    public var labelCTFont: CTFont = CTFontCreateWithName(("SFProText-Regular" as CFString), 12, nil)
}

public struct YAxisSettings {
    public var settings = AxisBaseSettings()
    public var minGridlineSpacing: CGFloat = 40.0
}
   
public struct XAxisSettings {
    public var settings = AxisBaseSettings()
}

public struct ChartConfiguration {
    
    public init() {}
    
    public var data = ChartData()
    
    public var yAxis = YAxisSettings()
    
    public var xAxis = XAxisSettings()
}
