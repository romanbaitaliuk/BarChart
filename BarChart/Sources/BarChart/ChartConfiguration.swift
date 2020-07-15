//
//  ChartConfiguration.swift
//  PropperCharts
//
//  Created by Roman Baitaliuk on 5/07/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI
import Combine

public class ChartConfiguration: ObservableObject {
    public var data = ChartData()
    public var xAxis = XAxis()
    public var yAxis = YAxis()
    
    private var dataCancellable: AnyCancellable?
    private var xAxisCancellable: AnyCancellable?
    private var yAxisCancellable: AnyCancellable?
    
    public init() {
        self.dataCancellable = self.data.objectWillChange.sink(receiveValue: { _ in
            self.updateAxesData()
            self.objectWillChange.send()
        })
        
        self.xAxisCancellable = self.xAxis.objectWillChange.sink(receiveValue: { _ in
            self.objectWillChange.send()
        })
        
        self.yAxisCancellable = self.yAxis.objectWillChange.sink(receiveValue: { _ in
            self.objectWillChange.send()
        })
    }
    
    /// Updating axes in the exact order
    func updateAxes(frameSize: CGSize) {
        self.yAxis.frameHeight = frameSize.height
        let frameWidth = frameSize.width - self.yAxis.maxLabelWidth
        self.xAxis.frameWidth = frameWidth
    }
    
    func updateAxesData() {
        self.yAxis.data = self.data.yValues
        self.xAxis.data = self.data.entries
    }
}
