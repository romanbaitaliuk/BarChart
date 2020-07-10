//
//  ChartData.swift
//  ProperCharts
//
//  Created by Roman Baitaliuk on 9/05/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public struct ChartDataEntry: Identifiable, Equatable {
    public var id = UUID()
    public var x: String
    public var y: Double
    
    public init(x: String, y: Double) {
        self.x = x
        self.y = y
    }
}

public class ChartData: ObservableObject {
    @Published public var entries: [ChartDataEntry]
    @Published public var gradientColor: GradientColor?
    @Published public var color: Color = .red
    
    public convenience init() {
        self.init(entries: [])
    }
    
    public init(entries: [ChartDataEntry]) {
        self.entries = entries
    }
    
    public init(entries: [ChartDataEntry], gradientColor: GradientColor) {
        self.entries = entries
        self.gradientColor = gradientColor
    }
    
    public init(entries: [ChartDataEntry], color: Color) {
        self.entries = entries
        self.color = color
    }
    
    var yValues: [Double] {
        return self.entries.map { $0.y }
    }
    
    var xValues: [String] {
        return self.entries.map { $0.x }
    }
}
