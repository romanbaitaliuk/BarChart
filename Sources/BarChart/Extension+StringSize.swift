//
//  Extension+StringSize.swift
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

extension String {
    func width(ctFont: CTFont) -> CGFloat {
        return self.size(ctFont: ctFont).width
    }

    func height(ctFont: CTFont) -> CGFloat {
        return self.size(ctFont: ctFont).height
    }
    
    func size(ctFont: CTFont) -> CGSize {
        let attributes = [NSAttributedString.Key.init(kCTFontAttributeName as String): ctFont]
        let attString = NSAttributedString(string: self, attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        let range = CFRange(location: 0, length: 0)
        let frame = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, range, nil, .zero, nil)
        return frame
    }
}
