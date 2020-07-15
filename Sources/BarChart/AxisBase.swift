//
//  AxisBase.swift
//  BarChart
//
//  Created by Roman Baitaliuk on 5/07/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public class AxisBase: ObservableObject {
    @Published public var labelsColor: Color = .black
    @Published public var ticksColor: Color = .black
    @Published public var ticksDash: [CGFloat] =  [5, 10]
    @Published public var labelsCTFont: CTFont = CTFontCreateWithName(("SFProText-Regular" as CFString), 12, nil)
    
    var labelsUIFont: UIFont {
        return UIFont(name: CTFontCopyPostScriptName(self.labelsCTFont) as String,
                      size: CTFontGetSize(self.labelsCTFont))!
    }
    
    var labelsFont: Font {
        return Font(self.labelsCTFont)
    }
    
    var maxLabelWidth: CGFloat {
        return self.formattedLabels().map { $0.width(font: self.labelsUIFont) }.max() ?? 0
    }
    
    func formattedLabels() -> [String] {
        fatalError("Needs to be overridden")
    }
}
