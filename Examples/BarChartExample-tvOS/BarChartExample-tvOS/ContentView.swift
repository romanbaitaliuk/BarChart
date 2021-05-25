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
    let config = ChartConfiguration()
    @State var entries: [ChartDataEntry] = []
    
    // MARK: - Controls Properties
    
    @State var maxEntriesCount: String = ""
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
            Text("No data").opacity(self.entries.isEmpty ? 1.0 : 0.0)
            BarChartView(config: self.config)
                .onAppear() {
                    let labelsFont = CTFontCreateWithName(("SFProText-Regular" as CFString), 10, nil)
                    self.config.data.color = .red
                    self.config.xAxis.labelsColor = .gray
                    self.config.xAxis.ticksColor = .gray
                    self.config.labelsCTFont = labelsFont
                    self.config.xAxis.ticksStyle = StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [2, 4])
                    self.config.yAxis.labelsColor = .gray
                    self.config.yAxis.ticksColor = .gray
                    self.config.yAxis.ticksStyle = StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [2, 4])
                    self.config.yAxis.minTicksSpacing = 30.0
                    self.config.yAxis.formatter = { (value, decimals) in
                        let format = value == 0 ? "" : "b"
                        return String(format: "%.\(decimals)f\(format)", value)
                    }
                }
                .animation(.easeInOut)
                .onReceive([self.isXAxisTicksHidden].publisher.first()) { (value) in
                    self.config.xAxis.ticksColor = value ? .clear : .gray
                }
                .onReceive([self.xAxisTicksIntervalValue].publisher.first()) { (value) in
                    self.config.xAxis.ticksInterval = Int(value)
                }
                .padding(15)
        }.frame(height: self.chartHeight)
    }
    
    func controlsView() -> some View {
        Group {
            TextField("Max entries count", text: self.$maxEntriesCount).padding(15)
            HStack {
                Button(action: {
                    let newEntries = self.randomEntries()
                    self.entries = newEntries
                    self.config.data.entries = newEntries
                }) {
                    Text("Generate entries")
                }
                Button(action: {
                    self.config.data.color = Color.random
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
        guard let maxEntriesCount = Int(self.maxEntriesCount), maxEntriesCount > 0 else { return [] }
        for data in 0..<maxEntriesCount {
            let randomDouble = Double.random(in: -15...50)
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
