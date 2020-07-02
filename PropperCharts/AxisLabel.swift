//
//  AxisLabel.swift
//  PropperCharts
//
//  Created by Roman Baitaliuk on 2/07/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

protocol AxisLabel {
    var fontSize: CGFloat { get }
    var uiFont: UIFont { get }
    var color: Color { get }
    var text: String { get }
    func width() -> CGFloat
}

extension AxisLabel {
    var fontSize: CGFloat {
        return 12
    }
    
    var uiFont: UIFont {
        return UIFont.systemFont(ofSize: self.fontSize)
    }
    
    var font: Font {
        // TODO: Improve this
        return Font.system(size: self.fontSize)
    }
    
    var height: CGFloat {
        let anyString = String()
        return anyString.heightOfString(usingFont: self.uiFont)
    }
    
    var color: Color {
        return .gray
    }
}

struct YAxisLabel: AxisLabel {
    var value: Double
    
    // TODO: Add step specifier
    var text: String {
        return String(format: String(self.value), self.specifier())
    }
    
    func specifier() -> String {
        let absoluteValue = abs(self.value)
        if absoluteValue > 0 && absoluteValue < 1 {
            let decimalsCount = absoluteValue.decimalsCount()
            return "%.\(decimalsCount)f"
        } else if absoluteValue >= 1 {
            let decimalPart = self.value.truncatingRemainder(dividingBy: 1)
            return decimalPart == 0 ? "%.0f" : "%.1f"
        } else {
            return "%.0f"
        }
    }
    
    func width() -> CGFloat {
        let valueString = String(format: self.specifier(), self.value)
        let width = valueString.widthOfString(usingFont: self.uiFont)
        return width
    }
}

struct XAxisLabel: AxisLabel {
    var text: String
    
    func width() -> CGFloat {
        return self.text.widthOfString(usingFont: self.uiFont)
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

struct LabelView: View {
    let label: AxisLabel
    
    var body: some View {
        Text(self.label.text)
            .font(self.label.font)
            .foregroundColor(self.label.color)
    }
}
