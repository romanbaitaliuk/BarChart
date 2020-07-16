//
//  ChartConfiguration.swift
//  BarChart
//
//  Copyright (c) 2020 Roman Baitaliuk
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

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
