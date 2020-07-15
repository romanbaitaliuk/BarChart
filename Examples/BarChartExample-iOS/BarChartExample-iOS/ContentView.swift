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
    let config = ChartConfiguration()
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    ScrollView {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(.white)
                                .padding(5)
                                .shadow(color: .black, radius: 5)
                            BarChartView()
                                .modifying(\.config, value: self.config)
                                .modifying(\.config.xAxis.ticksInterval, value: 4)
                                .modifying(\.config.xAxis.labelColor, value: Color.gray)
                                .modifying(\.config.xAxis.gridlineColor, value: Color.gray)
                                .modifying(\.config.yAxis.labelColor, value: Color.gray)
                                .modifying(\.config.yAxis.gridlineColor, value: Color.gray)
                                .modifying(\.config.data.entries, value: self.generateNewData())
                                .modifying(\.config.yAxis.formatter, value: { (value, decimals) in
                                    let format = value == 0 ? "" : "b"
                                    return String(format: "%.\(decimals)f\(format)", value)
                                })
                                .frame(height: self.chartHeight)
                                .padding(15)
                                .foregroundColor(.white)
                        }
                        Spacer(minLength: 15)
                        Button(action: {
                            let newEntries = self.generateNewData()
                            self.config.data.entries = newEntries
                            self.config.data.color = Color.random
                        }) {
                            Text("Generate data")
                        }.navigationBarTitle(Text("BarChart"))
                    }.padding()
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
