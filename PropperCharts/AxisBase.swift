//
//  AxisBase.swift
//  PropperCharts
//
//  Created by Roman Baitaliuk on 5/07/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

protocol AxisBase {
    var labelColor: Color { get }
    var gridlineColor: Color { get }
    var labelCTFont: CTFont { get }
    var gridlineDash: [CGFloat] { get }
    func formattedLabels() -> [String]
}

extension AxisBase {
    var labelUIFont: UIFont {
        return UIFont(name: CTFontCopyPostScriptName(self.labelCTFont) as String, size: CTFontGetSize(self.labelCTFont))!
    }
    
    var labelFont: Font {
        return Font(self.labelCTFont)
    }
    
    var maxYLabelWidth: CGFloat {
        return self.formattedLabels().map { $0.width(font: self.labelUIFont) }.max() ?? 0
    }
}
