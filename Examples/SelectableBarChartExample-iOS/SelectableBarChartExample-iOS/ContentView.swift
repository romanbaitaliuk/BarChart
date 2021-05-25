//
//  ContentView.swift
//  SelectableBarChartExample-iOS
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
    
    // MARK: - Selection Indicator
    
    let selectionIndicatorHeight: CGFloat = 60
    @State var selectedBarTopCentreLocation: CGPoint?
    @State var selectedEntry: ChartDataEntry?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 10) {
                    self.selectableChartView()
                    self.miniSelectableChartView()
                    Button(action: {
                        self.resetSelection()
                        self.config.data.entries = self.randomEntries()
                    }, label: {
                        Text("Random entries")
                    })
                    .onReceive(self.orientationChanged) { _ in
                        self.config.objectWillChange.send()
                        self.resetSelection()
                    }
                    .onAppear() {
                        // SwiftUI bug, onAppear is called before the view frame is calculated
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                            self.config.data.entries = self.randomEntries()
                            self.config.objectWillChange.send()
                        })
                    }
                    .navigationBarTitle(Text("SelectableBarChart"))
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Views
    
    func selectableChartView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            self.selectionIndicatorView()
            self.chartView()
        }
        .frame(height: chartHeight)
        .padding(15)
    }
    
    func miniSelectableChartView() -> some View {
        SelectableBarChartView<MiniSelectionIndicator>(config: self.config)
            .onBarSelection { entry, location in
                self.selectedBarTopCentreLocation = location
                self.selectedEntry = entry
            }
            .selectionView {
                MiniSelectionIndicator(entry: self.selectedEntry,
                                       location: self.selectedBarTopCentreLocation)
            }
            .frame(height: self.chartHeight - self.selectionIndicatorHeight)
            .padding(15)
    }
    
    func chartView() -> some View {
        GeometryReader { proxy in
            SelectableBarChartView<SelectionLine>(config: self.config)
                .onBarSelection { entry, location in
                    self.selectedBarTopCentreLocation = location
                    self.selectedEntry = entry
                }
                .selectionView {
                    SelectionLine(location: self.selectedBarTopCentreLocation,
                                  height: proxy.size.height - 17)
                }
        }
    }
    
    func selectionIndicatorView() -> some View {
        Group {
            if self.selectedEntry != nil && self.selectedBarTopCentreLocation != nil {
                SelectionIndicator(entry: self.selectedEntry!,
                                   location: self.selectedBarTopCentreLocation!.x,
                                   infoRectangleColor: Color(red: 241/255, green: 242/255, blue: 245/255))
            } else {
                Rectangle().foregroundColor(.clear)
            }
        }
        .frame(height: self.selectionIndicatorHeight)
    }
    
    func randomEntries() -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        for data in 0..<15 {
            let randomDouble = Double.random(in: -20...50)
            let newEntry = ChartDataEntry(x: "\(2000+data)", y: randomDouble)
            entries.append(newEntry)
        }
        return entries
    }
    
    func resetSelection() {
        self.selectedBarTopCentreLocation = nil
        self.selectedEntry = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
