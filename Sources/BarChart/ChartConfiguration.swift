//
//  ChartConfiguration.swift
//  BarChart
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
    private var dataEntriesCancellable: AnyCancellable?
    
    public init() {
        self.dataCancellable = self.data.objectWillChange.sink { value in
            self.objectWillChange.send()
        }
        
        self.dataEntriesCancellable = self.data.$entries.sink { newEntries in
            self.updateAxesData(entries: newEntries)
            self.objectWillChange.send()
        }
        
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
    
    func updateAxesData(entries: [ChartDataEntry]) {
        self.yAxis.data = entries.map { $0.y }
        self.xAxis.data = entries
    }
}
