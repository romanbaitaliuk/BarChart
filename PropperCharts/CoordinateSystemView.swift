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
    let xAxis: XAxis
    let yAxis: YAxis
    let frameSize: CGSize
    let botomPadding: CGFloat
    
    var body: some View {
        ZStack(alignment: .center) {
            // Draw horizontal zero line
            GridlineView(points: self.zeroHorizontalGridlinePoints(),
                         isDashed: false,
                         color: self.yAxis.gridlineColor,
                         isInverted: true)
            // Draw horizontal dashed gridlines
            ForEach((0..<self.yAxis.labels().count), id: \.self) { index in
                HStack(alignment: .center) {
                    GridlineView(points: self.horizontalGridlinePoints(index: index),
                                 isDashed: self.yAxis.gridlineIsDashed,
                                 color: self.yAxis.gridlineColor,
                                 isInverted: true)
                    LabelView(text: self.yAxis.formattedLabels()[index],
                              font: self.yAxis.labelFont,
                              color: self.yAxis.labelColor)
                        .offset(y: self.yLabelVerticalOffset(at: index))
                }
            }
            // Draw vertical dashed gridlines
            ForEach((0..<self.xAxis.formattedLabels().count), id: \.self) { index in
                VStack(alignment: .center) {
                    GridlineView(points: self.verticalGridlinePoints(index: index),
                                 isDashed: self.xAxis.gridlineIsDashed,
                                 color: self.xAxis.gridlineColor,
                                 isInverted: false)
                    LabelView(text: self.xAxis.formattedLabels()[index],
                              font: self.xAxis.labelFont,
                              color: self.xAxis.labelColor)
                        .offset(x: self.xLabelHorizontalOffset(index: index),
                                y: self.botomPadding)
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
        let label = self.xAxis.formattedLabels()[index]
        // TODO: Improve x axis label formatting
        let indexAtFullRange = self.xAxis.data.firstIndex(where: { $0 == label })!
        return self.xAxis.layout.barCentre(at: indexAtFullRange)
    }
    
    func verticalGridlinePoints(index: Int) -> (CGPoint, CGPoint) {
        let x = self.verticalGridlineX(at: index)
        return (CGPoint(x: x, y: 0), CGPoint(x: x, y: self.frameSize.height))
    }
    
    // MARK: - Y Axis
    
    func yLabelVerticalOffset(at index: Int) -> CGFloat {
        let gridlineY = self.horizontalGridlineY(at: index)
        let y = (self.frameSize.height - gridlineY) - (self.frameSize.height / 2)
        return y
    }
    
    func horizontalGridlineY(at index: Int) -> CGFloat {
        let label = self.yAxis.labels()[index]
        return (CGFloat(label) - CGFloat(self.yAxis.chartMin)) * self.yAxis.pixelsRatio()
    }
    
    func horizontalGridlinePoints(index: Int) -> (CGPoint, CGPoint) {
        let y = self.horizontalGridlineY(at: index)
        return self.horizontalGridlinePoints(y: y)
    }
    
    func zeroHorizontalGridlinePoints() -> (CGPoint, CGPoint) {
        let y = self.yAxis.centre() * (-1)
        return self.horizontalGridlinePoints(y: y)
    }
    
    func horizontalGridlinePoints(y: CGFloat) -> (CGPoint, CGPoint) {
        return (CGPoint(x: 0, y: y), CGPoint(x: self.xAxis.frameWidth, y: y))
    }
}

struct GridlineView: View {
    let points: (CGPoint, CGPoint)
    let isDashed: Bool
    let color: Color
    let isInverted: Bool
    
    var body: some View {
        self.verticalGridlinePath()
            .stroke(self.color,
                    style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: self.isDashed ? [5, 10] : []))
            .animation(.easeOut(duration: 0.2))
            .rotationEffect(.degrees(self.isInverted ? 180 : 0), anchor: .center)
            .rotation3DEffect(.degrees(self.isInverted ? 180 : 0), axis: (x: 0, y: 1, z: 0))
    }
    
    func verticalGridlinePath() -> Path {
        var vLine = Path()
        vLine.move(to: self.points.0)
        vLine.addLine(to: self.points.1)
        return vLine
    }
}

struct LabelView: View {
    let text: String
    let font: Font
    let color: Color
    
    var body: some View {
        Text(self.text)
            .font(self.font)
            .foregroundColor(self.color)
    }
}
