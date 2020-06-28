//
//  XAxis.swift
//  ProperCharts
//
//  Created by Roman Baitaliuk on 19/06/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import Foundation
import SwiftUI

struct XAxisLayout {
    let dataCount: Int
    let frameWidth: CGFloat
    
    var barWidth: CGFloat {
        return self.frameWidth / (CGFloat(self.dataCount) * 1.5)
    }
    
    var spacing: CGFloat {
        return self.frameWidth / CGFloat((self.dataCount - 1) * 3)
    }
    
    init(dataCount: Int,
         frameWidth: CGFloat) {
        self.dataCount = dataCount
        self.frameWidth = frameWidth
    }
    
    func barCentre(at index: Int) -> CGFloat {
        let centre = self.barWidth / 2
        return self.barWidth * CGFloat(index + 1) + self.spacing * CGFloat(index) - centre
    }
}
