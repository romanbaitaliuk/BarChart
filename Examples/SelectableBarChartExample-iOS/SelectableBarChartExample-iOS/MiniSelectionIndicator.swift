//
//  MiniSelectionIndicator.swift
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
import BarChart

struct MiniSelectionIndicator: View {
    let entry: ChartDataEntry?
    let location: CGPoint?

    let height: CGFloat = 30
    let width: CGFloat = 40
    let spaceFromBar: CGFloat = 5
    let color: Color = Color(red: 230/255, green: 230/255, blue: 230/255)

    var body: some View {
        Group {
            if location != nil && self.entry != nil {
                ZStack {
                    RoundedRectangle(cornerRadius: 3.0)
                        .foregroundColor(self.color)
                    Text("\(Int(self.entry!.y))").font(.system(size: 12)).fontWeight(.bold)
                }
                .zIndex(1)
                .frame(width: self.width, height: self.height)
                .offset(x: self.location!.x - self.width / 2, y: self.location!.y - (self.height + self.spaceFromBar))
            }
        }
    }
}
