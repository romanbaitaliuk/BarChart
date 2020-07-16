//
//  XAxisTests.swift
//  BarChartTests
//
//  Created by Roman Baitaliuk on 26/06/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import Foundation

import XCTest
@testable import BarChart

class XAxisTests: XCTestCase {
    
    var xAxis = XAxis()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        self.xAxis = XAxis()
    }
    
    func testTicksInterval1() {
        self.xAxis.frameWidth = 300
        self.xAxis.data = TestData.generate(with: TestData.Values.Positive.Small.values4)
        let expectedLabels = ["0", "1", "2", "3", "4", "5", "6"]
        XCTAssert(self.xAxis.formattedLabels() == expectedLabels)
    }
    
    func testTicksInterval2() {
        self.xAxis.frameWidth = 300
        self.xAxis.data = TestData.generate(with: TestData.Values.Positive.Small.values4)
        self.xAxis.ticksInterval = 2
        let expectedLabels = ["0", "2", "4", "6"]
        XCTAssert(self.xAxis.formattedLabels() == expectedLabels)
    }
    
    func testTicksInterval3() {
        self.xAxis.frameWidth = 300
        self.xAxis.data = TestData.generate(with: TestData.Values.Positive.Small.values4)
        self.xAxis.ticksInterval = 0
        let expectedLabels = ["0", "1", "2", "3", "4", "5", "6"]
        XCTAssert(self.xAxis.formattedLabels() == expectedLabels)
    }
    
    func testTicksInterval4() {
        self.xAxis.frameWidth = 300
        self.xAxis.data = TestData.generate(with: TestData.Values.Positive.Small.values4)
        self.xAxis.ticksInterval = nil
        let expectedLabels = ["0", "1", "2", "3", "4", "5", "6"]
        XCTAssert(self.xAxis.formattedLabels() == expectedLabels)
    }
    
    func testTicksInterval5() {
        self.xAxis.frameWidth = 300
        self.xAxis.data = TestData.generate(with: TestData.Values.Positive.Small.values4)
        self.xAxis.ticksInterval = 7
        let expectedLabels = ["6"]
        XCTAssert(self.xAxis.formattedLabels() == expectedLabels)
    }
}
