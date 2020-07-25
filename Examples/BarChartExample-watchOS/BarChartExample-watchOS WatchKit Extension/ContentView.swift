//
//  ContentView.swift
//  BarChartExample-watchOS WatchKit Extension
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
import BarChart

struct ContentView: View {
    
    // MARK: - Chart Properties
    let config = ChartConfiguration()
    
    var body: some View {
        GeometryReader { geometry in
            BarChartView(config: self.config)
                .onAppear() {
                    let font = CTFontCreateWithName(("SFProText-Regular" as CFString), 8, nil)
                    self.config.data.entries = self.randomEntries()
                    self.config.labelsCTFont = font
                    self.config.xAxis.labelsColor = .white
                    self.config.xAxis.ticksColor = .white
                    self.config.yAxis.labelsColor = .white
                    self.config.yAxis.ticksColor = .white
                    self.config.yAxis.minTicksSpacing = 20.0
                }
                .animation(Animation.easeInOut.delay(1.0))
                .frame(height: geometry.size.height)
        }
    }
    
    // MARK: - Random Helpers
    
    func randomEntries() -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        for data in 0..<8 {
            let randomDouble = Double.random(in: 0...10)
            let newEntry = ChartDataEntry(x: "\(data)", y: randomDouble)
            entries.append(newEntry)
        }
        return entries
    }
}
