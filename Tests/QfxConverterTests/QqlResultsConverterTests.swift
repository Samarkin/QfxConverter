import XCTest
@testable import QfxConverterLib

final class QqlResultsConverterTests: XCTestCase {
    func testExtractStrings() {
        let obj: OfxValue = [
            "key1": "value1"
        ]
        XCTAssertEqual(QqlResultsConverter.default.extract(argument: "key1", from: obj), "value1")
        XCTAssertEqual(QqlResultsConverter.default.extract(argument: "key2", from: obj), "")

        let arr: OfxValue = ["key1", "value1"]
        XCTAssertEqual(QqlResultsConverter.default.extract(argument: "key1", from: arr), "")
        XCTAssertEqual(QqlResultsConverter.default.extract(argument: "key2", from: arr), "")
    }

    func testExtractDates() {
        let obj: OfxValue = [
            "key1": "value1",
            "key2": "20180305120000[0:GMT]",
            "key3": "20180308000000.000[-7:MST]",
            "key4": "20171226000000.000",
            "nan": "201A0305120000",
        ]
        XCTAssertEqual(QqlResultsConverter.default.extract(argument: "key0".asDate, from: obj), "")
        XCTAssertEqual(QqlResultsConverter.default.extract(argument: "key1".asDate, from: obj), "value1")
        XCTAssertEqual(QqlResultsConverter.default.extract(argument: "key2".asDate, from: obj), "2018-03-05 12:00:00")
        XCTAssertEqual(QqlResultsConverter.default.extract(argument: "key3".asDate, from: obj), "2018-03-08 07:00:00")
        XCTAssertEqual(QqlResultsConverter.default.extract(argument: "key4".asDate, from: obj), "2017-12-26 00:00:00")
        XCTAssertEqual(QqlResultsConverter.default.extract(argument: "nan".asDate, from: obj), "201A0305120000")

        let arr: OfxValue = ["key1", "value1"]
        XCTAssertEqual(QqlResultsConverter.default.extract(argument: "key1".asDate, from: arr), "")
        XCTAssertEqual(QqlResultsConverter.default.extract(argument: "key2".asDate, from: arr), "")
    }

    static var allTests: [(String, (QqlResultsConverterTests) -> () throws -> Void)] {
        return [
            ("testExtractStrings", testExtractStrings),
            ("testExtractDates", testExtractDates),
            ("testLinuxTestSuite", testLinuxTestSuite),
        ]
    }

    func testLinuxTestSuite() {
        #if os(macOS)
            XCTAssertEqual(type(of: self).allTests.count, type(of: self).defaultTestSuite.testCaseCount)
        #endif
    }
}
