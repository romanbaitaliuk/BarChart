//
//  AxisLabelInfo.swift
//  StockFinancials
//
//  Created by Roman Baitaliuk on 19/06/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

struct AxisLabelInfo {
    static let uiFont = UIFont.systemFont(ofSize: 12)
    static let font = Font.system(size: 12)
    
    static var height: CGFloat {
        let anyString = String()
        return anyString.heightOfString(usingFont: AxisLabelInfo.uiFont)
    }
    
    static var halfHeight: CGFloat {
        return AxisLabelInfo.height / 2
    }
    
    static func maxWidth(values: [Double]) -> CGFloat {
        let minY = values.min() ?? 0
        let maxY = values.max() ?? 0
        let value = minY < 0 ? minY : maxY
        let valueString = String(format: "%.2f", value)
        return valueString.widthOfString(usingFont: AxisLabelInfo.uiFont)
    }
    
    static func width(value: String) -> CGFloat {
        return value.widthOfString(usingFont: AxisLabelInfo.uiFont)
    }
}

extension String {
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

    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}
