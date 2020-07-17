//
//  XAxisTests.swift
//  BarChartTests
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
