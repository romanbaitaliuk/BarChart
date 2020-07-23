//
//  AxisBase.swift
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

public class AxisBase: ObservableObject {
    @Published public var labelsColor: Color = .black
    @Published public var ticksColor: Color = .black
    @Published public var ticksDash: [CGFloat] =  [5, 10]
    @Published public var labelsCTFont: CTFont = CTFontCreateWithName(("SFProText-Regular" as CFString), 12, nil)
    
    var labelsFont: Font {
        return Font(self.labelsCTFont)
    }
}

public class XAxisReference: AxisBase {
    /// Horizontal interval between the bars
    @Published public var ticksInterval: Int? {
        didSet {
            self.validateTicksInterval()
        }
    }
    
    private func validateTicksInterval() {
        if let newValue = self.ticksInterval, newValue < 1 {
            self.ticksInterval = nil
        }
    }
}

public class YAxisReference: AxisBase {
    /// Minimum spacing between the ticks in pixels
    @Published public var minTicksSpacing: CGFloat = 40.0 {
        didSet {
            self.validateMinTicksSpacing()
        }
    }
    
    @Published public var formatter: ((Double, Int) -> String) = {
        return { return String(format: "%.\($1)f", $0) }
    }()
    
    private func validateMinTicksSpacing() {
        if minTicksSpacing <= 0 {
            self.minTicksSpacing = 40.0
        }
    }
}
