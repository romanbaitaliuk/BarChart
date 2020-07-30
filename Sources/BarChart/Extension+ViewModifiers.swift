//
//  Extension+ViewModifiers.swift
//  BarChart
//
//  Copyright (c) 2020 Roman Baitaliuk
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

import SwiftUI

public typealias BarChartView = SelectableBarChartView<EmptyView>

#if !os(tvOS)
public extension SelectableBarChartView {
    func onBarSelection(_ callback: @escaping (ChartDataEntry, CGPoint) -> ()) -> Self {
        SelectableBarChartView(config: self.config, selectionCallback: callback)
    }
    
    func selectionView(@ViewBuilder view: () -> SelectionView) -> Self {
        SelectableBarChartView(config: self.config, selectionCallback: self.selectionCallback, selectionView: view())
    }
}
#endif

extension View {
    func onSelect(callback: @escaping () -> ()) -> some View {
        return self.modifier(Selectable(callback: callback))
    }
}

struct Selectable: ViewModifier {
    let callback: () -> ()
    
    func body(content: Content) -> some View {
        Group {
            #if !os(tvOS)
                content
                    .onTapGesture {
                        self.callback()
                    }
            #else
                content
            #endif
        }
    }
}
