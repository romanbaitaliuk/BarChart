//
//  ContentView.swift
//  BarChartExample-iOS
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
    
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()
    
    // MARK: - Chart Properties
    
    let chartHeight: CGFloat = 300
    let config = ChartConfiguration()
    @State var entries = [ChartDataEntry]()
    
    // MARK: - Controls Properties
    
    @State var maxEntriesCount: Int = 10
    @State var xAxisTicksIntervalValue: Double = 1
    @State var isXAxisTicksHidden: Bool = false
    
    // MARK: - Views
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 10) {
                    self.chartView()
                    self.controlsView()
                    .navigationBarTitle(Text("BarChart"))
                }
                .padding(5)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func chartView() -> some View {
        ZStack {
            // Drop shadow rectangle
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.white)
                .padding(5)
                .shadow(color: .black, radius: 5)
//                Text("No data").opacity(self.entries.isEmpty ? 1.0 : 0.0)
                BarChartView(config: self.config)
                    .onAppear() {
                        let labelsFont = CTFontCreateWithName(("SFProText-Regular" as CFString), 10, nil)
                        self.config.data.entries = self.randomEntries()
                        self.config.data.color = .red
                        self.config.xAxis.labelsColor = .gray
                        self.config.xAxis.ticksColor = .gray
                        self.config.labelsCTFont = labelsFont
                        self.config.xAxis.ticksDash = []
                        self.config.yAxis.labelsColor = .gray
                        self.config.yAxis.ticksColor = .gray
                        self.config.yAxis.ticksDash = []
                        self.config.yAxis.minTicksSpacing = 30.0
                        self.config.yAxis.formatter = { (value, decimals) in
                            let format = value == 0 ? "" : "b"
                            return String(format: "%.\(decimals)f\(format)", value)
                        }
                    }
                    .onReceive([self.isXAxisTicksHidden].publisher.first()) { (value) in
                        self.config.xAxis.ticksColor = value ? .clear : .gray
                    }
                    .onReceive([self.xAxisTicksIntervalValue].publisher.first()) { (value) in
                        self.config.xAxis.ticksInterval = Int(value)
                    }
                    .onReceive(self.orientationChanged) { _ in
                        self.config.objectWillChange.send()
                    }
                    .padding(15)
        }.frame(height: self.chartHeight)
    }
    
    func controlsView() -> some View {
        Group {
            VStack(spacing: 0) {
                Stepper(value: self.$maxEntriesCount, in: 0...30) {
                    Text("Max entries count: \(self.maxEntriesCount)")
                }.padding(15)
                Button(action: {
                    let newEntries = self.randomEntries()
                    self.entries = newEntries
                    self.config.data.entries = newEntries
                }) {
                    Text("Generate entries")
                }.randomButtonStyle()
            }
            HStack {
                Button(action: {
                    self.config.data.color = Color.random
                }) {
                    Text("Generate color")
                }.randomButtonStyle()
                Button(action: {
                    self.config.data.gradientColor = GradientColor(start: Color.random, end: Color.random)
                }) {
                    Text("Generate gradient")
                }.randomButtonStyle()
            }
            Stepper(value: self.$xAxisTicksIntervalValue, in: 1...4) {
                Text("X axis ticks interval: \(Int(self.xAxisTicksIntervalValue))")
            }.padding(15)
            Toggle(isOn: self.$isXAxisTicksHidden, label: {
                Text("X axis ticks is hidden")
            }).padding(15)
        }
    }
    
    // MARK: - Random Helpers
    
    func randomEntries() -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        guard self.maxEntriesCount > 0 else { return [] }
        for data in 0..<self.maxEntriesCount {
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

// MARK: - Modifers

struct RandomButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
    }
}

extension View {
    func randomButtonStyle() -> some View {
        self.modifier(RandomButtonStyle())
    }
}
