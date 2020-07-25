//
//  BarShape.swift
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

struct BarShape: Shape {
    let width, cornerRadius: CGFloat
    var start, end: CGPoint
    
    var animatableData: AnimatablePair<CGPoint.AnimatableData, CGPoint.AnimatableData> {
        get { AnimatablePair(self.start.animatableData, self.end.animatableData) }
        set { (self.start.animatableData, self.end.animatableData) = (newValue.first, newValue.second) }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let p1 = CGPoint(x: self.start.x - self.width / 2, y: self.start.y)
        let p2 = CGPoint(x: self.start.x - self.width / 2, y: self.end.y - self.cornerRadius)
        let p3 = CGPoint(x: self.start.x - self.width / 2 + self.cornerRadius, y: self.end.y)
        let p4 = CGPoint(x: self.start.x + self.width / 2 - self.cornerRadius, y: self.end.y)
        let p5 = CGPoint(x: self.start.x + self.width / 2, y: self.end.y - self.cornerRadius)
        let p6 = CGPoint(x: self.start.x + self.width / 2, y: self.start.y)

        let control1 = CGPoint(x: self.start.x - self.width / 2, y: self.end.y)
        let control2 = CGPoint(x: self.start.x + self.width / 2, y: self.end.y)

        path.move(to: p1)
        path.addLine(to: p2)
        path.addQuadCurve(to: p3, control: control1)
        path.addLine(to: p4)
        path.addQuadCurve(to: p5, control: control2)
        path.addLine(to: p6)
        path.closeSubpath()
        
        return path
    }
}
