//
//  AxisBase.swift
//  BarChart
//
//  Created by Roman Baitaliuk on 5/07/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public class AxisBase: ObservableObject {
    @Published public var labelColor: Color = .black
    @Published public var gridlineColor: Color = .black
    @Published public var gridlineDash: [CGFloat] =  [5, 10]
    @Published public var labelCTFont: CTFont = CTFontCreateWithName(("SFProText-Regular" as CFString), 12, nil)
    
    var labelUIFont: UIFont {
        return UIFont(name: CTFontCopyPostScriptName(self.labelCTFont) as String,
                      size: CTFontGetSize(self.labelCTFont))!
    }
    
    var labelFont: Font {
        return Font(self.labelCTFont)
    }
    
    var maxLabelWidth: CGFloat {
        return self.formattedLabels().map { $0.width(font: self.labelUIFont) }.max() ?? 0
    }
    
    func formattedLabels() -> [String] {
        fatalError("Needs to be overridden")
    }
}
