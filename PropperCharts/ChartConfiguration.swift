//
//  ChartConfiguration.swift
//  PropperCharts
//
//  Created by Roman Baitaliuk on 5/07/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public struct ChartConfiguration {
    public var data: ChartData
    public let frameSize: CGSize
    public var xAxis: XAxis = XAxis()
    public var yAxis: YAxis = YAxis()
    public var backgroundColor: Color = Color("backgroundColor", bundle: Bundle.current)
    public var dropShadow: Bool = false
    public var dropShadowColor = Color("dropShadowColor", bundle: Bundle.current)
    
    public init(data: ChartData, frameSize: CGSize) {
        self.data = data
        self.frameSize = frameSize
    }
    
    public struct XAxis {
        public var labelColor: Color = Color("labelColor", bundle: Bundle.current)
        public var gridlineColor: Color = Color("gridlineColor", bundle: Bundle.current)
        public var gridlineDash: [CGFloat] = [5, 10]
        public var labelFont: CTFont = CTFontCreateWithName(("SFProText-Regular" as CFString), 12, nil)
    }
    
    public struct YAxis {
        public var labelColor: Color = Color("labelColor", bundle: Bundle.current)
        public var gridlineColor: Color = Color("gridlineColor", bundle: Bundle.current)
        public var gridlineDash: [CGFloat] = [5, 10]
        public var labelFont: CTFont = CTFontCreateWithName(("SFProText-Regular" as CFString), 12, nil)
        public var minGridlineSpacing: CGFloat = 40.0
    }
}

extension Bundle {
    static var current: Bundle {
        class __ { }
        return Bundle(for: __.self)
    }
}
