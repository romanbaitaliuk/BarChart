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
    let chartHeight: CGFloat = 300
    let labelsFont = CTFontCreateWithName(("SFProText-Regular" as CFString), 10, nil)
    let config = ChartConfiguration()
    @State var dataColor: Color = .red
    @State var entries: [ChartDataEntry] = []
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        ZStack {
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
                                    .modifying(\.config.xAxis.ticksInterval, value: 4)
                                    .modifying(\.config.xAxis.labelColor, value: Color.gray)
                                    .modifying(\.config.xAxis.gridlineColor, value: Color.gray)
                                    .modifying(\.config.xAxis.labelCTFont, value: self.labelsFont)
                                    .modifying(\.config.xAxis.gridlineDash, value: [2, 4])
                                    .modifying(\.config.yAxis.labelColor, value: Color.gray)
                                    .modifying(\.config.yAxis.gridlineColor, value: Color.gray)
                                    .modifying(\.config.yAxis.labelCTFont, value: self.labelsFont)
                                    .modifying(\.config.yAxis.gridlineDash, value: [3, 6])
                                        .modifying(\.config.yAxis.minGridlineSpacing, value: 30.0)
                                    .modifying(\.config.yAxis.formatter, value: { (value, decimals) in
                                        let format = value == 0 ? "" : "b"
                                        return String(format: "%.\(decimals)f\(format)", value)
                                    })
                                    .padding(15)
                                    .foregroundColor(.white)
                            }
                        }.frame(height: self.chartHeight)
                        Button(action: {
                            let newEntries = self.generateNewData()
                            self.entries = newEntries
                        }) {
                            Text("Generate data")
                        }
                        Button(action: {
                            self.config.data.gradientColor = nil
                            self.dataColor = Color.random
                        }) {
                            Text("Generate solid color")
                        }
                        Button(action: {
                            self.config.data.gradientColor = GradientColor(start: Color.random, end: Color.random)
                        }) {
                            Text("Generate gradient")
                        }
                        .navigationBarTitle(Text("BarChart"))
                    }
                    .padding(5)
                }
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
    func generateNewData() -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        for data in 0...20 {
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
