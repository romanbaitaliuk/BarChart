//
//  SelectionIndicator.swift
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

struct SelectionIndicator: View {
    let entry: ChartDataEntry
    let location: CGFloat
    let infoRectangleColor: Color
    let infoRectangleWidth: CGFloat = 70
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                RoundedRectangle(cornerRadius: 3.0)
                    .foregroundColor(self.infoRectangleColor)
                VStack(alignment: .leading) {
                    HStack(alignment: .bottom, spacing: 2) {
                        Text("\(Int(self.entry.y))").font(.headline).fontWeight(.bold)
                        Text("b").font(.footnote)
                            .foregroundColor(.gray).fontWeight(.bold)
                    }
                    Text(self.entry.x)
                        .font(.footnote).foregroundColor(.gray).fontWeight(.bold)
                }
            }
            .frame(width: self.infoRectangleWidth)
            .offset(x: self.positionX(proxy, location: self.location))
            // '.id(UUID())' will prevent view from slide animation.
            .id(UUID())
        }
    }
    
    func positionX(_ proxy: GeometryProxy, location: CGFloat) -> CGFloat {
        let selectorCentre = self.infoRectangleWidth / 2
        let startX = location - selectorCentre
        if startX < 0 {
            return 0
        } else if startX + self.infoRectangleWidth > proxy.size.width {
            return proxy.size.width - self.infoRectangleWidth
        } else {
            return startX
        }
    }
}
