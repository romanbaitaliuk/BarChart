//
//  GradientColor.swift
//  BarChart
//
//  Created by Roman Baitaliuk on 26/06/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public struct GradientColor {
    public let start: Color
    public let end: Color
    
    public init(start: Color, end: Color) {
        self.start = start
        self.end = end
    }
    
    public func gradient() -> Gradient {
        return Gradient(colors: [start, end])
    }
}
