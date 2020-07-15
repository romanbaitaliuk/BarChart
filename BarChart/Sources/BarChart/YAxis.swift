//
//  YAxisLayout.swift
//  ProperCharts
//
//  Created by Roman Baitaliuk on 19/06/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import SwiftUI

public class YAxis: AxisBase {
    
    // MARK: - Public Properties
    
    @Published public var minGridlineSpacing: CGFloat = 40.0
    
    @Published public var formatter: ((Double, Int) -> String) = {
        return { return String(format: "%.\($1)f", $0) }
    }()
    
    // MARK: - Internal Properties
    
    @Published var data: [Double] = [] {
        didSet {
            self.updateScaler()
        }
    }
    
    @Published var frameHeight: CGFloat? {
        didSet {
            self.updateScaler()
        }
    }
    
    var scaler: YAxisScaler?
    
    // MARK: - Private Properties
    
    private var maxTicks: Int? {
        guard let frameHeight = self.frameHeight,
            self.minGridlineSpacing != 0 else { return nil }
        return Int(frameHeight / self.minGridlineSpacing)
    }
    
    // MARK: - Internal Methods
    
    override func formattedLabels() -> [String] {
        guard let tickSpacing = self.scaler?.tickSpacing else { return [] }
        return self.scaler?.scaledValues().map { self.formatter($0, tickSpacing.decimalsCount()) } ?? []
    }
    
    func labelValue(at index: Int) -> Double? {
        return self.scaler?.scaledValues()[index]
    }
    
    func pixelsRatio() -> CGFloat? {
        guard let frameHeight = self.frameHeight,
            let verticalDistance = self.verticalDistance(),
            verticalDistance != 0 else { return nil }
        return frameHeight / CGFloat(verticalDistance)
    }
    
    func centre() -> CGFloat? {
        guard let chartMin = self.scaler?.scaledMin,
            let pixelsRatio = self.pixelsRatio() else { return nil }
        return CGFloat(chartMin) * pixelsRatio
    }
       
    func normalizedValues() -> [Double] {
        guard let verticalDistance = self.verticalDistance(),
            verticalDistance != 0 else { return [] }
        return self.data.map { $0 / verticalDistance }
    }
    
    // MARK: - Private Methods
    
    private func updateScaler() {
        guard let minValue = self.data.min(),
            let maxValue = self.data.max(),
            let maxTicks = self.maxTicks else {
                self.scaler = nil
                return
        }
        let adjustedMin = minValue > 0 ? 0 : minValue
        let adjustedMax = maxValue < 0 ? 0 : maxValue
        self.scaler = YAxisScaler(min: adjustedMin, max: adjustedMax, maxTicks: maxTicks)
    }
    
    private func verticalDistance() -> Double? {
        guard let chartMax = self.scaler?.scaledMax,
            let chartMin = self.scaler?.scaledMin else { return nil }
        return abs(chartMax) + abs(chartMin)
    }
}
