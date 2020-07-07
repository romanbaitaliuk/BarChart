//
//  CoordinateSystemView.swift
//  ProperCharts
//
//  Created by Roman Baitaliuk on 28/04/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

struct CoordinateSystemView: View {
    let xAxis: XAxis
    let yAxis: YAxis
    let frameSize: CGSize
    
    // Offset for x labels to draw outside of the given size
    let labelOffsetY: CGFloat
    
    var body: some View {
        ZStack(alignment: .center) {
            YAxisView(yAxis: self.yAxis,
                      frameSize: self.frameSize)
            XAxisView(xAxis: self.xAxis,
                      frameSize: self.frameSize,
                      labelOffsetY: self.labelOffsetY)
        }
    }
}

struct GridlineView: View {
    let points: (CGPoint, CGPoint)
    let dash: [CGFloat]
    let color: Color
    let isInverted: Bool
    
    var body: some View {
        self.verticalGridlinePath()
            .stroke(self.color,
                    style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: self.dash))
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

struct XAxisView: View {
    let xAxis: XAxis
    let frameSize: CGSize
    let labelOffsetY: CGFloat
    
    var body: some View {
        ForEach((0..<self.xAxis.formattedLabels().count), id: \.self) { index in
            VStack(alignment: .center) {
                GridlineView(points: self.verticalGridlinePoints(index: index),
                             dash: self.xAxis.gridlineDash,
                             color: self.xAxis.gridlineColor,
                             isInverted: false)
                LabelView(text: self.xAxis.formattedLabels()[index],
                          font: self.xAxis.labelFont,
                          color: self.xAxis.labelColor)
                    .offset(x: self.xLabelHorizontalOffset(index: index),
                            y: self.labelOffsetY)
            }
        }
    }
    
    func xLabelHorizontalOffset(index: Int) -> CGFloat {
        let gridlineX = self.verticalGridlineX(at: index)
        let x = gridlineX - self.frameSize.width / 2
        return x
    }
    
    func verticalGridlineX(at index: Int) -> CGFloat {
        let label = self.xAxis.formattedLabels()[index]
        if let indexAtFullRange = self.xAxis.data.firstIndex(where: { $0 == label }) {
            return self.xAxis.barCentre(at: indexAtFullRange)
        }
        return 0
    }
    
    func verticalGridlinePoints(index: Int) -> (CGPoint, CGPoint) {
        let x = self.verticalGridlineX(at: index)
        return (CGPoint(x: x, y: 0), CGPoint(x: x, y: self.frameSize.height))
    }
}

struct YAxisView: View {
    let yAxis: YAxis
    let frameSize: CGSize
    
    var body: some View {
        ForEach((0..<self.yAxis.labels().count), id: \.self) { index in
            HStack(alignment: .center) {
                GridlineView(points: self.horizontalGridlinePoints(index: index),
                             dash: self.yAxis.labels()[index] == 0 ? [] : self.yAxis.gridlineDash,
                             color: self.yAxis.gridlineColor,
                             isInverted: true)
                LabelView(text: self.yAxis.formattedLabels()[index],
                          font: self.yAxis.labelFont,
                          color: self.yAxis.labelColor)
                    .offset(y: self.yLabelVerticalOffset(at: index))
            }
        }
    }
    
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
    
    func horizontalGridlinePoints(y: CGFloat) -> (CGPoint, CGPoint) {
        let endPointX = self.frameSize.width - self.yAxis.maxYLabelWidth
        return (CGPoint(x: 0, y: y), CGPoint(x: endPointX, y: y))
    }
}
