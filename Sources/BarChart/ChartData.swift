//
//  ChartData.swift
//  BarChart
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
    
    convenience init() {
        self.init(entries: [])
    }
    
    init(entries: [ChartDataEntry]) {
        self.entries = entries
    }
    
    var yValues: [Double] {
        return self.entries.map { $0.y }
    }
    
    var xValues: [String] {
        return self.entries.map { $0.x }
    }
}
