//
//  Extensions.swift
//  PropperCharts
//
//  Created by Roman Baitaliuk on 9/07/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public extension View {
    func modifying<T>(_ keyPath: WritableKeyPath<Self, T>, value: T) -> Self {
        var copy = self
        copy[keyPath: keyPath] = value
        return copy
    }
}
