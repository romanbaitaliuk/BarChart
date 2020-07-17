//
//  ContentView.swift
//  BarChartExample-tvOS
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
    
    let chartHeight: CGFloat = 400
    let labelsFont = CTFontCreateWithName(("SFProText-Regular" as CFString), 10, nil)
    let config = ChartConfiguration()
    @State var dataColor: Color = .red
    @State var entries: [ChartDataEntry] = []
    
    // MARK: - Controls Properties
    
    @State var maxEntriesCount: String = ""
    @State var maxChartValueRatio: String = ""
    @State var minChartValueRatio: String = ""
    @State var xAxisTicksIntervalValue: String = ""
    @State var isXAxisTicksHidden: Bool = false
    
    // MARK: - Views
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 10) {
                    self.chartView()
                    self.controlsView()
                }
                .padding(5)
            }
        }
    }
    
    func chartView() -> some View {
        ZStack {
            // Drop shadow rectangle
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.white)
                .padding(5)
                .shadow(color: .black, radius: 5)
            if self.entries.isEmpty {
                Text("No data")
            } else {
                BarChartView()
                    .modifying(\.config, value: self.config)
                    .modifying(\.config.data.entries, value: self.entries)
                    .modifying(\.config.data.color, value: self.dataColor)
                    .modifying(\.config.xAxis.labelsColor, value: .gray)
                    .modifying(\.config.xAxis.ticksColor, value: self.isXAxisTicksHidden ? .clear : .gray)
                    .modifying(\.config.xAxis.labelsCTFont, value: self.labelsFont)
                    .modifying(\.config.xAxis.ticksDash, value: [2, 4])
                    .modifying(\.config.xAxis.ticksInterval, value: Int(self.xAxisTicksIntervalValue))
                    .modifying(\.config.yAxis.labelsColor, value: .gray)
                    .modifying(\.config.yAxis.ticksColor, value: .gray)
                    .modifying(\.config.yAxis.labelsCTFont, value: self.labelsFont)
                    .modifying(\.config.yAxis.ticksDash, value: [3, 6])
                    .modifying(\.config.yAxis.minTicksSpacing, value: 30.0)
                    .modifying(\.config.yAxis.formatter, value: { (value, decimals) in
                        let format = value == 0 ? "" : "b"
                        return String(format: "%.\(decimals)f\(format)", value)
                    })
                    .padding(15)
            }
        }.frame(height: self.chartHeight)
    }
    
    func controlsView() -> some View {
        Group {
            HStack(spacing: 0) {
                TextField("Max entries count", text: self.$maxEntriesCount).padding(15)
                TextField("Max chart value", text: self.$maxChartValueRatio).padding(15)
                TextField("Min chart value", text: self.$minChartValueRatio).padding(15)
            }
            HStack {
                Button(action: {
                    let newEntries = self.randomEntries()
                    self.entries = newEntries
                }) {
                    Text("Generate entries")
                }
                Button(action: {
                    self.config.data.gradientColor = nil
                    self.dataColor = Color.random
                }) {
                    Text("Generate color")
                }
                Button(action: {
                    self.config.data.gradientColor = GradientColor(start: Color.random, end: Color.random)
                }) {
                    Text("Generate gradient")
                }
            }
            TextField("x- axis ticks interval", text: self.$xAxisTicksIntervalValue).padding(15)
            Toggle(isOn: self.$isXAxisTicksHidden, label: {
                Text("X axis ticks is hidden")
            }).padding(15)
        }
    }
    
    // MARK: - Random Helpers
    
    func randomEntries() -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        guard let maxEntriesCount = Int(self.maxEntriesCount), maxEntriesCount > 0,
            let minChartValue = Double(self.minChartValueRatio),
            let maxChartValue = Double(self.maxChartValueRatio) else { return [] }
        for data in 0..<maxEntriesCount {
            let randomDouble = Double.random(in: minChartValue...maxChartValue)
            let newEntry = ChartDataEntry(x: "\(2000+data)", y: randomDouble)
            entries.append(newEntry)
        }
        return entries
    }
}

extension Color {
    static var random: Color {
        return Color(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1))
    }
}
