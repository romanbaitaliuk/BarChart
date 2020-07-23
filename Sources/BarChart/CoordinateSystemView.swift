//
//  CoordinateSystemView.swift
//  BarChart
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

struct CoordinateSystemView: View {
    let yAxis: YAxis
    let xAxis: XAxis
    let frameSize: CGSize
    
    var body: some View {
        ZStack(alignment: .center) {
            if !self.yAxis.formattedLabels().isEmpty {
                YAxisView(yAxis: self.yAxis,
                          frameSize: self.frameSize,
                          xLabelsHeight: String().height(ctFont: self.xAxis.ref.labelsCTFont))
                XAxisView(xAxis: self.xAxis,
                          frameSize: CGSize(width: self.frameSize.width,
                                            height: self.yAxis.frameHeight))
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
    let xAxis: XAxis
    let frameSize: CGSize
    
    var body: some View {
        ForEach((0..<self.xAxis.formattedLabels().count), id: \.self) { index in
            VStack(alignment: .center) {
                TickView(points: self.tickPoints(index: index),
                         dash: self.xAxis.ref.ticksDash,
                         color: self.xAxis.ref.ticksColor,
                         isInverted: false)
                LabelView(text: self.xAxis.formattedLabels()[index],
                          font: self.xAxis.ref.labelsFont,
                          color: self.xAxis.ref.labelsColor)
                    .offset(x: self.labelOffsetX(index: index))
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
            let centre = self.xAxis.layout.barCentre(at: indexAtFullRange) else { return 0 }
        return centre
    }
    
    func tickPoints(index: Int) -> (CGPoint, CGPoint) {
        let x = self.tickX(at: index)
        return (CGPoint(x: x, y: 0), CGPoint(x: x, y: self.frameSize.height))
    }
}

struct YAxisView: View {
    let yAxis: YAxis
    let frameSize: CGSize
    let xLabelsHeight: CGFloat
    
    var body: some View {
        ForEach((0..<self.yAxis.formattedLabels().count), id: \.self) { index in
            HStack(alignment: .center) {
                TickView(points: self.tickPoints(index: index),
                         dash: self.yAxis.labelValue(at: index) == 0 ? [] : self.yAxis.ref.ticksDash,
                         color: self.yAxis.ref.ticksColor,
                         isInverted: true)
                LabelView(text: self.yAxis.formattedLabels()[index],
                          font: self.yAxis.ref.labelsFont,
                          color: self.yAxis.ref.labelsColor)
                    .offset(y: self.labelOffsetY(at: index))
            }
        }
    }
    
    func labelOffsetY(at index: Int) -> CGFloat {
        let tickY = self.tickY(at: index)
        let height = self.frameSize.height
        let y = (height - tickY) - (height / 2)
        return y
    }
    
    func tickY(at index: Int) -> CGFloat {
        guard let chartMin = self.yAxis.scaler?.scaledMin,
            let pixelsRatio = self.yAxis.pixelsRatio(),
            let label = self.yAxis.labelValue(at: index) else { return 0 }
        let shift = String().height(ctFont: self.yAxis.ref.labelsCTFont) + self.xLabelsHeight
        return (CGFloat(label) - CGFloat(chartMin)) * pixelsRatio + shift
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
