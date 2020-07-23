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
    
    func testTicksInterval1() {
        let xAxis = XAxis(frameWidth: 300, data: TestData.generate(with: TestData.Values.Positive.Small.values4))
        let expectedLabels = ["0", "1", "2", "3", "4", "5", "6"]
        XCTAssert(xAxis.formattedLabels() == expectedLabels)
    }
    
    func testTicksInterval2() {
        let ref = XAxisReference()
        ref.ticksInterval = 2
        let xAxis = XAxis(frameWidth: 300,
                          data: TestData.generate(with: TestData.Values.Positive.Small.values4),
                          ref: ref)
        let expectedLabels = ["0", "2", "4", "6"]
        XCTAssert(xAxis.formattedLabels() == expectedLabels)
    }
    
    func testTicksInterval3() {
        let ref = XAxisReference()
        ref.ticksInterval = 0
        let xAxis = XAxis(frameWidth: 300,
                          data: TestData.generate(with: TestData.Values.Positive.Small.values4),
                          ref: ref)
        let expectedLabels = ["0", "1", "2", "3", "4", "5", "6"]
        XCTAssert(xAxis.formattedLabels() == expectedLabels)
    }
}
