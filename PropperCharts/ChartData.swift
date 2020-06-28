//
//  ChartData.swift
//  ProperCharts
//
//  Created by Roman Baitaliuk on 9/05/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public struct ChartDataEntry {
    var x: String
    var y: Double
    
    public init(x: String, y: Double) {
        self.x = x
        self.y = y
    }
}

public class ChartData: ObservableObject {
    @Published var entries: [ChartDataEntry]
    
    public init(entries: [ChartDataEntry]) {
        self.entries = entries
    }
    
    var yValues: [Double] {
        return self.entries.map { $0.y }
    }
    
    var xValues: [String] {
        return self.entries.map { $0.x }
    }
    
    var count: Int {
        return self.entries.count
    }
}
