//
//  PropperChartsTests.swift
//  PropperChartsTests
//
//  Created by Roman Baitaliuk on 26/06/20.
//  Copyright © 2020 Roman Baitaliuk. All rights reserved.
//

import XCTest
@testable import PropperCharts

class YAxisTests: XCTestCase {
    
    var yAxis = YAxis()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        self.yAxis = YAxis()
    }

    func testScalerUpdate() throws {
        self.yAxis.frameHeight = 400
        XCTAssert(yAxis.scaler == nil)
        self.yAxis.data = []
        XCTAssert(yAxis.scaler == nil)
        self.yAxis.data = [1, 2, 3]
        XCTAssert(yAxis.scaler != nil)
        self.yAxis.frameHeight = nil
        XCTAssert(yAxis.scaler == nil)
        self.yAxis.frameHeight = 1
        XCTAssert(yAxis.scaler != nil)
    }
    
    func testScaler1() {
        self.yAxis.frameHeight = 0
        self.yAxis.data = [1, 2, 3]
        XCTAssert(self.yAxis.scaler?.tickSpacing == nil)
        XCTAssert(self.yAxis.scaler?.scaledMin == nil)
        XCTAssert(self.yAxis.scaler?.scaledMax == nil)
    }
    
    func testScaler2() {
        self.yAxis.frameHeight = 400
        self.yAxis.data = [10]
        XCTAssert(self.yAxis.scaler?.tickSpacing == 1)
        XCTAssert(self.yAxis.scaler?.scaledMin == 0)
        XCTAssert(self.yAxis.scaler?.scaledMax == 10)
    }
    
    func testScaler3() {
        self.yAxis.frameHeight = 600
        self.yAxis.minGridlineSpacing = 100
        self.yAxis.data = [5, 7, 14]
        XCTAssert(self.yAxis.scaler?.tickSpacing == 5)
        XCTAssert(self.yAxis.scaler?.scaledMin == 0)
        XCTAssert(self.yAxis.scaler?.scaledMax == 15)
    }
    
    func testMaxTicks1() {
        let frameHeight: CGFloat = 400
        let minGridlineSpacing: CGFloat = 50
        
        self.yAxis.frameHeight = frameHeight
        self.yAxis.minGridlineSpacing = minGridlineSpacing
        self.yAxis.data = [1, 2, 3, 4]
        
        let maxTicksCount = Int(frameHeight / minGridlineSpacing)
        XCTAssert(self.yAxis.scaler!.scaledValues().count <= maxTicksCount)
    }
    
    func testMaxTicks2() {
        let frameHeight: CGFloat = 200
        let minGridlineSpacing: CGFloat = 70
        
        self.yAxis.frameHeight = frameHeight
        self.yAxis.minGridlineSpacing = minGridlineSpacing
        self.yAxis.data = [1, 2, 3, 4]
        
        let maxTicksCount = Int(frameHeight / minGridlineSpacing)
        XCTAssert(self.yAxis.scaler!.scaledValues().count <= maxTicksCount)
    }
    
    // MARK: - Positive values
    
    func testPositiveLabels1() {
        self.yAxis.frameHeight = 400
        self.yAxis.data = TestData.Values.Positive.Small.values1
        let expectedLabels = ["0.00", "0.05", "0.10", "0.15", "0.20", "0.25"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels2() {
        self.yAxis.frameHeight = 400
        self.yAxis.data = TestData.Values.Positive.Small.values2
        let expectedLabels = ["0.00", "0.05", "0.10", "0.15", "0.20", "0.25", "0.30"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels3() {
        self.yAxis.frameHeight = 400
        self.yAxis.data = TestData.Values.Positive.Small.values3
        let expectedLabels = ["0.00", "0.05", "0.10", "0.15", "0.20", "0.25", "0.30"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels4() {
        self.yAxis.frameHeight = 400
        self.yAxis.data = TestData.Values.Positive.Small.values4
        let expectedLabels = ["0.00", "0.05", "0.10", "0.15", "0.20", "0.25", "0.30"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels5() {
        self.yAxis.frameHeight = 400
        self.yAxis.data = TestData.Values.Positive.Small.values5
        let expectedLabels = ["0.0", "0.1", "0.2", "0.3", "0.4", "0.5", "0.6", "0.7", "0.8", "0.9", "1.0"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels6() {
        self.yAxis.frameHeight = 400
        self.yAxis.data = TestData.Values.Positive.Mid.values1
        let expectedLabels = ["0", "10", "20", "30", "40", "50", "60", "70", "80", "90", "100"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels7() {
        self.yAxis.frameHeight = 400
        self.yAxis.data = TestData.Values.Positive.Mid.values2
        let expectedLabels = ["0", "10", "20", "30", "40", "50", "60", "70"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels8() {
        self.yAxis.frameHeight = 400
        self.yAxis.data = TestData.Values.Positive.Mid.values3
        let expectedLabels = ["0", "10", "20", "30", "40", "50", "60"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels9() {
        self.yAxis.frameHeight = 400
        self.yAxis.data = TestData.Values.Positive.Mid.values4
        let expectedLabels = ["0", "10", "20", "30", "40", "50", "60", "70", "80", "90", "100"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels10() {
        self.yAxis.frameHeight = 400
        self.yAxis.data = TestData.Values.Positive.Mid.values5
        let expectedLabels = ["0", "10", "20", "30", "40", "50", "60", "70", "80", "90", "100"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels11() {
        self.yAxis.frameHeight = 400
        self.yAxis.data = TestData.Values.Positive.Large.values1
        let expectedLabels = ["0", "100", "200", "300", "400", "500", "600", "700", "800", "900", "1000"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels12() {
        self.yAxis.frameHeight = 400
        self.yAxis.data = TestData.Values.Positive.Large.values2
        let expectedLabels = ["0", "50", "100", "150", "200", "250", "300", "350", "400", "450", "500"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels13() {
        self.yAxis.frameHeight = 400
        self.yAxis.data = TestData.Values.Positive.Large.values3
        let expectedLabels = ["0", "100", "200", "300", "400", "500", "600", "700", "800", "900"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels14() {
        self.yAxis.frameHeight = 400
        self.yAxis.data = TestData.Values.Positive.Large.values4
        let expectedLabels = ["0", "100", "200", "300", "400", "500", "600", "700", "800", "900", "1000"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveLabels15() {
        self.yAxis.frameHeight = 400
        self.yAxis.data = TestData.Values.Positive.Large.values5
        let expectedLabels = ["0", "100", "200", "300", "400", "500", "600", "700", "800", "900", "1000"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    // MARK: - Negative values
    
    func testNegativeLabels1() {
        self.yAxis.frameHeight = 400
        self.yAxis.data = TestData.Values.Negative.Small.values1
        let expectedLabels = ["-0.25", "-0.20", "-0.15", "-0.10", "-0.05", "0.00"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels2() {
        self.yAxis.frameHeight = 500
        self.yAxis.data = TestData.Values.Negative.Small.values2
        let expectedLabels = ["-0.20", "-0.18", "-0.16", "-0.14", "-0.12", "-0.10", "-0.08", "-0.06", "-0.04", "-0.02", "-0.00"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels3() {
        self.yAxis.frameHeight = 550
        self.yAxis.data = TestData.Values.Negative.Small.values3
        let expectedLabels = ["-0.30", "-0.25", "-0.20", "-0.15", "-0.10", "-0.05", "0.00"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels4() {
        self.yAxis.frameHeight = 600
        self.yAxis.data = TestData.Values.Negative.Small.values4
        let expectedLabels = ["-0.30", "-0.25", "-0.20", "-0.15", "-0.10", "-0.05", "0.00"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels5() {
        self.yAxis.frameHeight = 400
        self.yAxis.data = TestData.Values.Negative.Small.values5
        let expectedLabels = ["-0.30", "-0.25", "-0.20", "-0.15", "-0.10", "-0.05", "0.00"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels6() {
        self.yAxis.frameHeight = 300
        self.yAxis.data = TestData.Values.Negative.Mid.values1
        let expectedLabels = ["-15", "-10", "-5", "0"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels7() {
        self.yAxis.frameHeight = 250
        self.yAxis.data = TestData.Values.Negative.Mid.values2
        let expectedLabels = ["-50", "-40", "-30", "-20", "-10", "0"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels8() {
        self.yAxis.frameHeight = 280
        self.yAxis.data = TestData.Values.Negative.Mid.values3
        let expectedLabels = ["-80", "-60", "-40", "-20", "0"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels9() {
        self.yAxis.frameHeight = 780
        self.yAxis.data = TestData.Values.Negative.Mid.values4
        let expectedLabels = ["-100", "-95", "-90", "-85", "-80", "-75", "-70", "-65", "-60", "-55", "-50", "-45", "-40", "-35", "-30", "-25", "-20", "-15", "-10", "-5", "0"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels10() {
        self.yAxis.frameHeight = 450
        self.yAxis.data = TestData.Values.Negative.Mid.values5
        let expectedLabels = ["-100", "-90", "-80", "-70", "-60", "-50", "-40", "-30", "-20", "-10", "0"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels11() {
        self.yAxis.frameHeight = 454
        self.yAxis.data = TestData.Values.Negative.Large.values1
        let expectedLabels = ["-250", "-200", "-150", "-100", "-50", "0"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels12() {
        self.yAxis.frameHeight = 676
        self.yAxis.data = TestData.Values.Negative.Large.values2
        let expectedLabels = ["-400", "-350", "-300", "-250", "-200", "-150", "-100", "-50", "0"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels13() {
        self.yAxis.frameHeight = 673
        self.yAxis.data = TestData.Values.Negative.Large.values3
        let expectedLabels = ["-950", "-900", "-850", "-800", "-750", "-700", "-650", "-600", "-550", "-500", "-450", "-400", "-350", "-300", "-250", "-200", "-150", "-100", "-50", "0"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels14() {
        self.yAxis.frameHeight = 120
        self.yAxis.data = TestData.Values.Negative.Large.values4
        let expectedLabels = ["-1000", "-500", "0"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testNegativeLabels15() {
        self.yAxis.frameHeight = 300
        self.yAxis.data = TestData.Values.Negative.Large.values5
        let expectedLabels = ["-1000", "-800", "-600", "-400", "-200", "0"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    // MARK: - Positive and Negative values
    
    func testPositiveAndNegativeLabels1() {
        self.yAxis.frameHeight = 400
        self.yAxis.data = TestData.Values.PositiveAndNegative.Small.values1
        let expectedLabels = ["-0.15", "-0.10", "-0.05", "0.00", "0.05", "0.10", "0.15", "0.20"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveAndNegativeLabels2() {
        self.yAxis.frameHeight = 500
        self.yAxis.data = TestData.Values.PositiveAndNegative.Small.values2
        let expectedLabels = ["-0.20", "-0.15", "-0.10", "-0.05", "0.00", "0.05", "0.10", "0.15", "0.20"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveAndNegativeLabels3() {
        self.yAxis.frameHeight = 550
        self.yAxis.data = TestData.Values.PositiveAndNegative.Small.values3
        let expectedLabels = ["-0.20", "-0.15", "-0.10", "-0.05", "0.00", "0.05", "0.10", "0.15", "0.20"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveAndNegativeLabels4() {
        self.yAxis.frameHeight = 600
        self.yAxis.data = TestData.Values.PositiveAndNegative.Small.values4
        let expectedLabels = ["-0.15", "-0.10", "-0.05", "0.00", "0.05", "0.10", "0.15", "0.20"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveAndNegativeLabels5() {
        self.yAxis.frameHeight = 300
        self.yAxis.data = TestData.Values.PositiveAndNegative.Mid.values1
        let expectedLabels = ["-20", "-10", "0", "10", "20", "30"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveAndNegativeLabels6() {
        self.yAxis.frameHeight = 250
        self.yAxis.data = TestData.Values.PositiveAndNegative.Mid.values2
        let expectedLabels = ["-100", "-50", "0", "50", "100"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveAndNegativeLabels7() {
        self.yAxis.frameHeight = 280
        self.yAxis.data = TestData.Values.PositiveAndNegative.Mid.values3
        let expectedLabels = ["-100", "-50", "0", "50", "100"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveAndNegativeLabels8() {
        self.yAxis.frameHeight = 780
        self.yAxis.data = TestData.Values.PositiveAndNegative.Mid.values4
        let expectedLabels = ["-100", "-90", "-80", "-70", "-60", "-50", "-40", "-30", "-20", "-10", "0", "10", "20", "30", "40", "50", "60", "70", "80", "90"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveAndNegativeLabels9() {
        self.yAxis.frameHeight = 600
        self.yAxis.data = TestData.Values.PositiveAndNegative.Large.values1
        let expectedLabels = ["-500", "-400", "-300", "-200", "-100", "0", "100", "200", "300", "400", "500"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveAndNegativeLabels10() {
        self.yAxis.frameHeight = 673
        self.yAxis.data = TestData.Values.PositiveAndNegative.Large.values2
        let expectedLabels = ["-1000", "-900", "-800", "-700", "-600", "-500", "-400", "-300", "-200", "-100", "0", "100", "200", "300", "400", "500", "600", "700", "800"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveAndNegativeLabels11() {
        self.yAxis.frameHeight = 500
        self.yAxis.data = TestData.Values.PositiveAndNegative.Large.values3
        let expectedLabels = ["-1000", "-800", "-600", "-400", "-200", "0", "200", "400", "600", "800", "1000"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
    
    func testPositiveAndNegativeLabels12() {
        self.yAxis.frameHeight = 120
        self.yAxis.data = TestData.Values.PositiveAndNegative.Large.values4
        let expectedLabels = ["-1000", "0", "1000"]
        XCTAssert(self.yAxis.formattedLabels() == expectedLabels)
    }
}
