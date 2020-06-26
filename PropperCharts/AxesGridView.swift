//
//  AxesGridView.swift
//  BarChart
//
//  Created by Roman Baitaliuk on 28/04/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

struct AxesGridView: View {
    
    @ObservedObject var data: ChartData
    let gridlineColor: Color
    let labelColor: Color
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                // Draw horizontal zero line
                self.zeroHorizontalLinePath(proxy: proxy)
                    .stroke(self.gridlineColor,
                            style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
                    .rotationEffect(.degrees(180), anchor: .center)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .animation(.easeOut(duration: 0.2))
                // Draw horizontal dashed gridlines
                ForEach((0...self.yAxis().labels().count - 1), id: \.self) { index in
                    HStack(alignment: .center) {
                        self.horizontalGridlinePath(at: index,
                                                    proxy: proxy)
                            .stroke(self.gridlineColor,
                                    style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [5, 10]))
                            .rotationEffect(.degrees(180), anchor: .center)
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                            .animation(.easeOut(duration: 0.2))
                        Text("\(self.yAxis().label(at: index), specifier: "%.2f")")
                            .font(AxisLabelInfo.font)
                            .offset(y: self.yLabelVerticalOffset(at: index,
                                                                 proxy: proxy))
                            .foregroundColor(self.labelColor)
                    }
                }
                // Draw vertical dashed gridlines
                ForEach((0...self.xAxis(proxy: proxy).labels().count - 1), id: \.self) { index in
                    VStack(alignment: .center) {
                        self.verticalGridlinePath(at: index, proxy: proxy)
                            .stroke(self.gridlineColor,
                                    style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [5, 10]))
                            .animation(.easeOut(duration: 0.2))
                        Text(self.xAxis(proxy: proxy).label(at: index))
                            .font(AxisLabelInfo.font)
                            .offset(x: self.xLabelHorizontalOffset(proxy: proxy, index: index),
                                    y: AxisLabelInfo.height + AxisLabelInfo.halfHeight)
                            .foregroundColor(self.labelColor)
                    }
                }
            }
        }
    }
    
    // MARK: - X Axis
    
    func xLabelHorizontalOffset(proxy: GeometryProxy,
                                index: Int) -> CGFloat {
        let gridlineX = self.verticalGridlineX(at: index, proxy: proxy)
        let x = gridlineX - proxy.size.width / 2
        return x
    }
    
    func verticalGridlinePath(x: CGFloat,
                              proxy: GeometryProxy) -> Path {
        var vLine = Path()
        vLine.move(to: CGPoint(x: x, y: 0))
        vLine.addLine(to: CGPoint(x: x, y: proxy.size.height))
        return vLine
    }
    
    func verticalGridlinePath(at index: Int,
                              proxy: GeometryProxy) -> Path {
        let x = self.verticalGridlineX(at: index, proxy: proxy)
        return self.verticalGridlinePath(x: x, proxy: proxy)
    }
    
    func verticalGridlineX(at index: Int,
                           proxy: GeometryProxy) -> CGFloat {
        let xAxis = self.xAxis(proxy: proxy)
        let label = xAxis.label(at: index)
        let indexAtFullRange = xAxis.data.firstIndex(where: { $0 == label })!
        return self.xAxis(proxy: proxy).layout.barCentre(at: indexAtFullRange)
    }
    
    // MARK: - Y Axis
    
    func horizontalGridlinePath(y: CGFloat,
                                proxy: GeometryProxy) -> Path {
        let maxYLabelWidth = AxisLabelInfo.maxWidth(values: self.data.yValues)
        var hLine = Path()
        hLine.move(to: CGPoint(x: 0, y: y))
        hLine.addLine(to: CGPoint(x: proxy.size.width - maxYLabelWidth, y: y))
        return hLine
    }
    
    func horizontalGridlinePath(at index: Int,
                                proxy: GeometryProxy) -> Path {
        let y = self.horizontalGridlineY(at: index, proxy: proxy)
        return self.horizontalGridlinePath(y: y, proxy: proxy)
    }
    
    func zeroHorizontalLinePath(proxy: GeometryProxy) -> Path {
        let maxYLabelWidth = AxisLabelInfo.maxWidth(values: self.data.yValues)
        var hLine = Path()
        let centreY = self.yAxis().centre(proxy: proxy) * (-1)
        hLine.move(to: CGPoint(x: 0, y: centreY))
        hLine.addLine(to: CGPoint(x: proxy.size.width - maxYLabelWidth, y: centreY))
        return hLine
    }
    
    func yLabelVerticalOffset(at index: Int,
                              proxy: GeometryProxy) -> CGFloat {
        let gridlineY = self.horizontalGridlineY(at: index, proxy: proxy)
        let y = (proxy.size.height - gridlineY) - (proxy.size.height / 2)
        return y
    }
    
    func horizontalGridlineY(at index: Int,
                             proxy: GeometryProxy) -> CGFloat {
        let label = self.yAxis().label(at: index)
        return (CGFloat(label) - CGFloat(self.yAxis().chartMin)) * self.yAxis().pixelsRatio(proxy: proxy)
    }
    
    func yAxis() -> YAxis {
        return YAxis(data: self.data.yValues)
    }
    
    func xAxis(proxy: GeometryProxy) -> XAxis {
        let barChartWidth = proxy.size.width - AxisLabelInfo.maxWidth(values: self.data.yValues)
        return XAxis(data: self.data.xValues,
                     frameWidth: barChartWidth)
    }
}
