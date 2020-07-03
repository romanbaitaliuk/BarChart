//
//  CoordinateSystemView.swift
//  ProperCharts
//
//  Created by Roman Baitaliuk on 28/04/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

struct CoordinateSystemView: View {
    
    @ObservedObject var data: ChartData
    let gridlineColor: Color
    let labelColor: Color
    let xAxis: XAxis
    let yAxis: YAxis
    let frameSize: CGSize
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Draw horizontal zero line
            YGridlineView(y: self.yAxis.centre() * (-1),
                          length: self.xAxis.frameWidth,
                          isDashed: false,
                          color: self.gridlineColor)
            // Draw horizontal dashed gridlines
            ForEach((0..<self.yAxis.labels().count), id: \.self) { index in
                HStack(alignment: .center) {
                    YGridlineView(y: self.horizontalGridlineY(at: index),
                                  length: self.xAxis.frameWidth,
                                  isDashed: true,
                                  color: self.gridlineColor)
                    Text("\(self.yAxis.label(at: index), specifier: AxisLabelUtils.specifier(value: self.yAxis.step()))")
                        .font(AxisLabelUtils.font)
                        .offset(y: self.yLabelVerticalOffset(at: index))
                        .foregroundColor(self.labelColor)
                }
            }
            // Draw vertical dashed gridlines
            ForEach((0..<self.xAxis.labels().count), id: \.self) { index in
                VStack(alignment: .center) {
                    XGridlineView(x: self.verticalGridlineX(at: index),
                                  length: self.frameSize.height,
                                  isDashed: true,
                                  color: self.gridlineColor)
                    Text(self.xAxis.label(at: index))
                        .font(AxisLabelUtils.font)
                        .offset(x: self.xLabelHorizontalOffset(index: index),
                                y: AxisLabelUtils.height + AxisLabelUtils.halfHeight)
                        .foregroundColor(self.labelColor)
                }
            }
        }
    }
    
    // MARK: - X Axis
    
    func xLabelHorizontalOffset(index: Int) -> CGFloat {
        let gridlineX = self.verticalGridlineX(at: index)
        let x = gridlineX - self.frameSize.width / 2
        return x
    }
    
    func verticalGridlineX(at index: Int) -> CGFloat {
        let label = self.xAxis.label(at: index)
        let indexAtFullRange = self.xAxis.data.firstIndex(where: { $0 == label })!
        return self.xAxis.layout.barCentre(at: indexAtFullRange)
    }
    
    // MARK: - Y Axis
    
    func yLabelVerticalOffset(at index: Int) -> CGFloat {
        let gridlineY = self.horizontalGridlineY(at: index)
        let y = (self.frameSize.height - gridlineY) - (self.frameSize.height / 2)
        return y
    }
    
    func horizontalGridlineY(at index: Int) -> CGFloat {
        let label = self.yAxis.label(at: index)
        return (CGFloat(label) - CGFloat(self.yAxis.chartMin)) * self.yAxis.pixelsRatio()
    }
}

struct XGridlineView: View {
    let x: CGFloat
    let length: CGFloat
    let isDashed: Bool
    let color: Color
    
    var body: some View {
        self.verticalGridlinePath()
            .stroke(self.color,
                    style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [5, 10]))
            .animation(.easeOut(duration: 0.2))
    }
    
    func verticalGridlinePath() -> Path {
        var vLine = Path()
        vLine.move(to: CGPoint(x: self.x, y: 0))
        vLine.addLine(to: CGPoint(x: self.x, y: self.length))
        return vLine
    }
}

struct YGridlineView: View {
    let y: CGFloat
    let length: CGFloat
    let isDashed: Bool
    let color: Color
    
    var body: some View {
        self.horizontalGridlinePath()
            .stroke(self.color,
                    style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: self.isDashed ? [5, 10] : []))
            .rotationEffect(.degrees(180), anchor: .center)
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            .animation(.easeOut(duration: 0.2))
    }
    
    func horizontalGridlinePath() -> Path {
        var hLine = Path()
        hLine.move(to: CGPoint(x: 0, y: self.y))
        hLine.addLine(to: CGPoint(x: self.length, y: self.y))
        return hLine
    }
}
