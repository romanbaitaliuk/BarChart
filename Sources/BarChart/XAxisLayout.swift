//
//  XAxisLayout.swift
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

struct XAxisLayout {
    private let frameWidth: CGFloat
    private let dataCount: Int
    
    private(set) var spacing: CGFloat?
    private(set) var barWidth: CGFloat?
    
    init(frameWidth: CGFloat, dataCount: Int) {
        self.frameWidth = frameWidth
        self.dataCount = dataCount
        self.calculate()
    }
    
    func barCentre(at index: Int) -> CGFloat? {
        guard let barWidth = self.barWidth,
            let spacing = self.spacing else { return nil }
        if self.dataCount == 1 {
            return spacing + barWidth / 2
        } else {
            let centre = barWidth / 2
            return barWidth * CGFloat(index + 1) + spacing * CGFloat(index) - centre
        }
    }
    
    private mutating func calculate() {
        guard self.dataCount != 0 else { return }
            
        let barWidth = self.frameWidth / (CGFloat(self.dataCount) * 1.5)
        self.barWidth = barWidth
        
        if self.dataCount == 1 {
            self.spacing = (self.frameWidth - barWidth) / 2
        } else {
            self.spacing = self.frameWidth / CGFloat((self.dataCount - 1) * 3)
        }
    }
}
