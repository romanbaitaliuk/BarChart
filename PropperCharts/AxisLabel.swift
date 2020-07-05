//
//  AxisLabel.swift
//  PropperCharts
//
//  Created by Roman Baitaliuk on 2/07/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

private extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
}

struct LabelDimensions {
    static func height(text: String, font: UIFont) -> CGFloat {
        return text.heightOfString(usingFont: font)
    }
    
    static func width(text: String, font: UIFont) -> CGFloat {
        return text.widthOfString(usingFont: font)
    }
}
