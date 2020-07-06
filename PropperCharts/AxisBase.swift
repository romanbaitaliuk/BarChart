//
//  AxisBase.swift
//  PropperCharts
//
//  Created by Roman Baitaliuk on 5/07/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

protocol AxisBase {
    var settings: AxisBaseSettings { get }
    func formattedLabels() -> [String]
}

extension AxisBase {
    var labelUIFont: UIFont {
        return UIFont(name: CTFontCopyPostScriptName(self.settings.labelCTFont) as String,
                      size: CTFontGetSize(self.settings.labelCTFont))!
    }
    
    var labelFont: Font {
        return Font(self.settings.labelCTFont)
    }
    
    var labelColor: Color {
        return self.settings.labelColor
    }
    
    var gridlineColor: Color {
        return self.settings.gridlineColor
    }
    
    var gridlineDash: [CGFloat] {
        return self.settings.gridlineDash
    }
    
    var labelCTFont: CTFont {
        return self.settings.labelCTFont
    }
}
