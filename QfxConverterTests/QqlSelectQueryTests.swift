import XCTest

final class QqlSelectQueryTests: XCTestCase {
    private let testObj = QfxObject()

    override func setUp() {
        super.setUp()
        testObj.ofx = [
            "source": "test1",
            "items": [
                [
                    "name": "item1",
                    "amt": "10",
                    "additionalInfo": [
                        "key": "value"
                    ]
                ],
                [
                    "name": "item2",
                    "amt": "20",
                    "additionalInfo": "something"
                ],
                [
                    "name": "item3",
                    "amt": "30"
                ]
            ]
        ]
    }

    func testSimpleQuery() {
        let query = Qql.query.select("name", "amt").from("items")
        let result = query.perform(on: testObj)
        assertResults(result, [["item1", "10"],["item2", "20"],["item3", "30"]])
    }

    func testNotValue() {
        let query = Qql.query.select("name", "additionalInfo").from("items")
        let result = query.perform(on: testObj)
        assertResults(result, [["item1", ""], ["item2", "something"], ["item3", ""]])
    }

    func testDeepError() {
        let query = Qql.query.select("key").from("items/additionalInfo")
        let result = query.perform(on: testObj)
        assertResults(result, [["value"], [""]])
    }

    func testNil() {
        let nilObj = QfxObject()

        let query = Qql.query.select("name", "amt").from("items")
        let result = query.perform(on: nilObj)
        assertResults(result, [])
    }

    func assertResults(_ left: [[String]], _ right: [[String]]) {
        if left.count != right.count {
            XCTFail("Results are of different size: \(left.count) and \(right.count)")
        }
        else {
            for (i,l) in left.enumerated() {
                XCTAssertEqual(l, right[i], "Results are different at index \(i): \(l) and \(right[i])")
            }
        }
    }
}
