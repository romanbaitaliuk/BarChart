//
//  XAxisLayout.swift
//  PropperCharts
//
//  Created by Roman Baitaliuk on 14/07/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

struct XAxisLayout {
    private let frameWidth: CGFloat
    private let dataCount: Int
    
    private(set) var spacing: CGFloat?
    private(set) var barWidth: CGFloat?
    
    init(frameWidth: CGFloat, dataCount: Int) {
        self.frameWidth = frameWidth
        self.dataCount = dataCount
        self.calculate()
    }
    
    func barCentre(at index: Int) -> CGFloat? {
        guard let barWidth = self.barWidth,
            let spacing = self.spacing else { return nil }
        if self.dataCount == 1 {
            return spacing + barWidth / 2
        } else {
            let centre = barWidth / 2
            return barWidth * CGFloat(index + 1) + spacing * CGFloat(index) - centre
        }
    }
    
    private mutating func calculate() {
        guard self.dataCount != 0 else { return }
            
        let barWidth = self.frameWidth / (CGFloat(self.dataCount) * 1.5)
        self.barWidth = barWidth
        
        if self.dataCount == 1 {
            self.spacing = (self.frameWidth - barWidth) / 2
        } else {
            self.spacing = self.frameWidth / CGFloat((self.dataCount - 1) * 3)
        }
    }
}
