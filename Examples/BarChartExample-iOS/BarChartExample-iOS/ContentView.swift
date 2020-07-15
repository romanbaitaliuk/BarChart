//
//  ContentView.swift
//  BarChartExample-iOS
//
//  Created by Roman Baitaliuk on 28/04/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI
import BarChart

extension Color {
    static var random: Color {
        return Color(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1))
    }
}

struct ContentView: View {
    let chartHeight: CGFloat = 200
    
    let config = ChartConfiguration()
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    ScrollView {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(.white)
                                .padding(10)
                                .shadow(color: .black, radius: 5)
                            BarChartView()
                                .modifying(\.config, value: self.config)
                                .modifying(\.config.data.entries, value: self.generateNewData())
                                .modifying(\.config.yAxis.formatter, value: { (value, decimals) in
                                    return String(format: "%.\(decimals)fB", value)
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
                        }.navigationBarTitle(Text("Bar Chart"))
                    }.padding()
                }
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
    func generateNewData() -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        for data in 0...20 {
            let randomDouble = Double.random(in: -1000...1000)
            let newEntry = ChartDataEntry(x: "\(2000+data)", y: randomDouble)
            entries.append(newEntry)
        }
        print(entries.map { $0.y })
        return entries
    }
}
