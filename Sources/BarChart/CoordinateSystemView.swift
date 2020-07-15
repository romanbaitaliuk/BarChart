//
//  CoordinateSystemView.swift
//  BarChart
//
//  Created by Roman Baitaliuk on 28/04/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

struct CoordinateSystemView: View {
    @ObservedObject var xAxis: XAxis
    @ObservedObject var yAxis: YAxis
    let frameSize: CGSize
    
    // Offset for x labels to draw outside of the given size
    let labelOffsetY: CGFloat
    
    var body: some View {
        ZStack(alignment: .center) {
            if !self.yAxis.formattedLabels().isEmpty {
                YAxisView(yAxis: self.yAxis,
                          frameSize: self.frameSize)
                XAxisView(xAxis: self.xAxis,
                          frameSize: self.frameSize,
                          labelOffsetY: self.labelOffsetY)
            }
        }
    }
}

struct TickView: View {
    let points: (CGPoint, CGPoint)
    let dash: [CGFloat]
    let color: Color
    let isInverted: Bool
    
    var body: some View {
        self.linePath()
            .stroke(self.color,
                    style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: self.dash))
            .rotationEffect(.degrees(self.isInverted ? 180 : 0), anchor: .center)
            .rotation3DEffect(.degrees(self.isInverted ? 180 : 0), axis: (x: 0, y: 1, z: 0))
    }
    
    func linePath() -> Path {
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
    @ObservedObject var xAxis: XAxis
    let frameSize: CGSize
    let labelOffsetY: CGFloat
    
    var body: some View {
        ForEach((0..<self.xAxis.formattedLabels().count), id: \.self) { index in
            VStack(alignment: .center) {
                TickView(points: self.tickPoints(index: index),
                             dash: self.xAxis.ticksDash,
                             color: self.xAxis.ticksColor,
                             isInverted: false)
                LabelView(text: self.xAxis.formattedLabels()[index],
                          font: self.xAxis.labelsFont,
                          color: self.xAxis.labelsColor)
                    .offset(x: self.labelOffsetX(index: index),
                            y: self.labelOffsetY)
            }
        }
    }
    
    func labelOffsetX(index: Int) -> CGFloat {
        let tickX = self.tickX(at: index)
        let x = tickX - self.frameSize.width / 2
        return x
    }
    
    func tickX(at index: Int) -> CGFloat {
        let chartEntry = self.xAxis.chartEntry(at: index)
        guard let indexAtFullRange = self.xAxis.data.firstIndex(where: { $0 == chartEntry }),
            let centre = self.xAxis.layout?.barCentre(at: indexAtFullRange) else { return 0 }
        return centre
    }
    
    func tickPoints(index: Int) -> (CGPoint, CGPoint) {
        let x = self.tickX(at: index)
        return (CGPoint(x: x, y: 0), CGPoint(x: x, y: self.frameSize.height))
    }
}

struct YAxisView: View {
    @ObservedObject var yAxis: YAxis
    let frameSize: CGSize
    
    var body: some View {
        ForEach((0..<self.yAxis.formattedLabels().count), id: \.self) { index in
            HStack(alignment: .center) {
                TickView(points: self.tickPoints(index: index),
                             dash: self.yAxis.labelValue(at: index) == 0 ? [] : self.yAxis.ticksDash,
                             color: self.yAxis.ticksColor,
                             isInverted: true)
                LabelView(text: self.yAxis.formattedLabels()[index],
                          font: self.yAxis.labelsFont,
                          color: self.yAxis.labelsColor)
                    .offset(y: self.labelOffsetY(at: index))
            }
        }
    }
    
    func labelOffsetY(at index: Int) -> CGFloat {
        let tickY = self.tickY(at: index)
        let y = (self.frameSize.height - tickY) - (self.frameSize.height / 2)
        return y
    }
    
    func tickY(at index: Int) -> CGFloat {
        guard let chartMin = self.yAxis.scaler?.scaledMin,
            let pixelsRatio = self.yAxis.pixelsRatio(),
            let label = self.yAxis.labelValue(at: index) else { return 0 }
        return (CGFloat(label) - CGFloat(chartMin)) * pixelsRatio
    }
    
    func tickPoints(index: Int) -> (CGPoint, CGPoint) {
        let y = self.tickY(at: index)
        return self.tickPoints(y: y)
    }
    
    func tickPoints(y: CGFloat) -> (CGPoint, CGPoint) {
        let endPointX = self.frameSize.width - self.yAxis.maxLabelWidth
        return (CGPoint(x: 0, y: y), CGPoint(x: endPointX, y: y))
    }
}
