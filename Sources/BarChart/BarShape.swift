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

enum RoundedCorner: CaseIterable {
    case topLeft, topRight, bottomRight, bottomLeft
}

struct BarShape: Shape {
    let cornerRadius: CGFloat
    let corners: [RoundedCorner]
    
    func radius(for corner: RoundedCorner) -> CGFloat {
        if self.corners.contains(corner) {
            return self.cornerRadius
        }
        return 0
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let control1 = CGPoint(x: rect.minX, y: rect.maxY)
        let control2 = CGPoint(x: rect.maxX, y: rect.maxY)
        let control3 = CGPoint(x: rect.maxX, y: rect.minY)
        let control4 = CGPoint(x: rect.minX, y: rect.minY)
        
        let p1 = CGPoint(x: rect.minX, y: rect.minY + self.radius(for: .bottomLeft))
        let p2 = CGPoint(x: rect.minX, y: rect.maxY - self.radius(for: .topLeft))
        let p3 = CGPoint(x: rect.minX + self.radius(for: .topLeft), y: rect.maxY)
        let p4 = CGPoint(x: rect.maxX - self.radius(for: .topRight), y: rect.maxY)
        let p5 = CGPoint(x: rect.maxX, y: rect.maxY - self.radius(for: .topRight))
        let p6 = CGPoint(x: rect.maxX, y: rect.minY + self.radius(for: .bottomRight))
        let p7 = CGPoint(x: rect.maxX - self.radius(for: .bottomRight), y: rect.minY)
        let p8 = CGPoint(x: rect.minX + self.radius(for: .bottomLeft), y: rect.minY)
        
        path.move(to: p1)
        path.addLine(to: p2)
        path.addQuadCurve(to: p3, control: control1)
        path.addLine(to: p4)
        path.addQuadCurve(to: p5, control: control2)
        path.addLine(to: p6)
        path.addQuadCurve(to: p7, control: control3)
        path.addLine(to: p8)
        path.addQuadCurve(to: p1, control: control4)
        
        return path
    }
}
