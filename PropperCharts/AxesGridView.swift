//
//  AxesGridView.swift
//  ProperCharts
//
//  Created by Roman Baitaliuk on 28/04/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

struct AxesGridView: View {
    
    @ObservedObject var data: ChartData
    let gridlineColor: Color
    let labelColor: Color
    let xAxis: XAxis
    let yAxis: YAxis
    let frameSize: CGSize
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Draw horizontal zero line
            self.zeroHorizontalLinePath()
                .stroke(self.gridlineColor,
                        style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
                .rotationEffect(.degrees(180), anchor: .center)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .animation(.easeOut(duration: 0.2))
            // Draw horizontal dashed gridlines
            ForEach((0..<self.yAxis.labels().count), id: \.self) { index in
                HStack(alignment: .center) {
                    self.horizontalGridlinePath(at: index)
                        .stroke(self.gridlineColor,
                                style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [5, 10]))
                        .rotationEffect(.degrees(180), anchor: .center)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        .animation(.easeOut(duration: 0.2))
                    Text("\(self.yAxis.label(at: index), specifier: AxisLabelUtils.specifier(value: self.yAxis.step()))")
                        .font(AxisLabelUtils.font)
                        .offset(y: self.yLabelVerticalOffset(at: index))
                        .foregroundColor(self.labelColor)
                }
            }
            // Draw vertical dashed gridlines
            ForEach((0..<self.xAxis.labels().count), id: \.self) { index in
                VStack(alignment: .center) {
                    self.verticalGridlinePath(at: index)
                        .stroke(self.gridlineColor,
                                style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [5, 10]))
                        .animation(.easeOut(duration: 0.2))
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
    
    func verticalGridlinePath(x: CGFloat) -> Path {
        var vLine = Path()
        vLine.move(to: CGPoint(x: x, y: 0))
        vLine.addLine(to: CGPoint(x: x, y: self.frameSize.height))
        return vLine
    }
    
    func verticalGridlinePath(at index: Int) -> Path {
        let x = self.verticalGridlineX(at: index)
        return self.verticalGridlinePath(x: x)
    }
    
    func verticalGridlineX(at index: Int) -> CGFloat {
        let label = self.xAxis.label(at: index)
        let indexAtFullRange = self.xAxis.data.firstIndex(where: { $0 == label })!
        return self.xAxis.layout.barCentre(at: indexAtFullRange)
    }
    
    // MARK: - Y Axis
    
    func horizontalGridlinePath(y: CGFloat) -> Path {
        let maxYLabelWidth = AxisLabelUtils.maxWidth(yValues: self.data.yValues, frameHeight: self.frameSize.height)
        var hLine = Path()
        hLine.move(to: CGPoint(x: 0, y: y))
        hLine.addLine(to: CGPoint(x: self.frameSize.width - maxYLabelWidth, y: y))
        return hLine
    }
    
    func horizontalGridlinePath(at index: Int) -> Path {
        let y = self.horizontalGridlineY(at: index)
        return self.horizontalGridlinePath(y: y)
    }
    
    func zeroHorizontalLinePath() -> Path {
        let maxYLabelWidth = AxisLabelUtils.maxWidth(yValues: self.data.yValues, frameHeight: self.frameSize.height)
        var hLine = Path()
        let centreY = self.yAxis.centre() * (-1)
        hLine.move(to: CGPoint(x: 0, y: centreY))
        hLine.addLine(to: CGPoint(x: self.frameSize.width - maxYLabelWidth, y: centreY))
        return hLine
    }
    
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
