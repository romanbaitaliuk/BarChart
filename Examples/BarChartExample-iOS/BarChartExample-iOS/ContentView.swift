//
//  ContentView.swift
//  BarChartExample-iOS
//
//  Created by Roman Baitaliuk on 28/04/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI
import BarChart

struct ContentView: View {
    
    // MARK: - Chart Properties
    
    let chartHeight: CGFloat = 300
    let labelsFont = CTFontCreateWithName(("SFProText-Regular" as CFString), 10, nil)
    let config = ChartConfiguration()
    @State var dataColor: Color = .red
    @State var entries: [ChartDataEntry] = []
    
    // MARK: - Controls Properties
    
    @State var maxEntriesCount: Int = 0
    @State var maxChartValueRatio: Double = 10
    @State var minChartValueRatio: Double = -3
    @State var xAxisTicksIntervalValue: Double = 1
    @State var isXAxisTicksHidden: Bool = false
    
    var maxChartValue: Double {
        self.maxChartValueRatio * 5
    }
    
    var minChartValue: Double {
        self.minChartValueRatio * 5
    }
    
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
                    .foregroundColor(.white)
            }
        }.frame(height: self.chartHeight)
    }
    
    func controlsView() -> some View {
        Group {
            VStack(spacing: 0) {
                Stepper(value: self.$maxEntriesCount, in: 0...30) {
                    Text("Max entries count: \(self.maxEntriesCount)")
                }.padding(15)
                Stepper(value: self.$maxChartValueRatio, in: (self.minChartValueRatio)...20) {
                    Text("Max chart value: \(Int(self.maxChartValue))")
                }.padding(15)
                Stepper(value: self.$minChartValueRatio, in: -20...(self.maxChartValueRatio)) {
                    Text("Min chart value: \(Int(self.minChartValue))")
                }.padding(15)
                
                Button(action: {
                    let newEntries = self.randomEntries()
                    self.entries = newEntries
                }) {
                    Text("Generate entries")
                }.randomButtonStyle()
            }
            HStack {
                Button(action: {
                    self.config.data.gradientColor = nil
                    self.dataColor = Color.random
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
        for data in 0...self.maxEntriesCount {
            let randomDouble = Double.random(in: self.minChartValue...self.maxChartValue)
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
