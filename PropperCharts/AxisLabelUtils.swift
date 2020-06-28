//
//  AxisLabelUtils.swift
//  StockFinancials
//
//  Created by Roman Baitaliuk on 19/06/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

struct AxisLabelUtils {
    static let uiFont = UIFont.systemFont(ofSize: 12)
    static let font = Font.system(size: 12)
    
    static var height: CGFloat {
        let anyString = String()
        return anyString.heightOfString(usingFont: AxisLabelUtils.uiFont)
    }
    
    static var halfHeight: CGFloat {
        return AxisLabelUtils.height / 2
    }
    
    static func maxWidth(yValues: [Double]) -> CGFloat {
        var maxWidth: CGFloat = 0
        let lables = YAxis(data: yValues).labels()
        for value in lables {
            let specifier = self.specifier(value: value)
            let valueString = String(format: specifier, value)
            let width = valueString.widthOfString(usingFont: AxisLabelUtils.uiFont)
            if width > maxWidth {
                maxWidth = width
            }
        }
        return maxWidth
    }
    
    static func specifier(value: Double) -> String {
        let absoluteValue = abs(value)
        if absoluteValue > 0 && absoluteValue < 1 {
            let decimalsCount = absoluteValue.decimalsCount()
            return "%.\(decimalsCount)f"
        } else if absoluteValue >= 1 {
            let decimalPart = value.truncatingRemainder(dividingBy: 1)
            return decimalPart == 0 ? "%.0f" : "%.1f"
        } else {
            return "%.0f"
        }
    }
    
    static func width(value: String) -> CGFloat {
        return value.widthOfString(usingFont: AxisLabelUtils.uiFont)
    }
}

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

    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}
