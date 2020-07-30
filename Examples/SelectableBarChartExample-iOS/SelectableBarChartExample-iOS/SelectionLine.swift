//
//  SelectionLine.swift
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

struct SelectionLine: View {
    let location: CGPoint?
    let height: CGFloat
    let color = Color(red: 100/255, green: 100/255, blue: 100/255)

    var body: some View {
        Group {
            if location != nil {
                self.centreLine()
                    .stroke(lineWidth: 2)
                    .offset(x: self.location!.x)
                    .foregroundColor(self.color)
                    /* '.id(UUID())' will prevent view from slide animation.
                        Because this view is a child view and passed to 'BarChartView' parent, parent might already has animation.
                        So, If you want to disable it, just call '.animation(nil)' instead of '.id(UUID())' */
                    .id(UUID())
            }
        }
    }

    func centreLine() -> Path {
        var path = Path()
        let p1 = CGPoint(x: 0, y: 0)
        let p2 = CGPoint(x: 0, y: self.height)
        path.move(to: p1)
        path.addLine(to: p2)
        return path
    }
}
