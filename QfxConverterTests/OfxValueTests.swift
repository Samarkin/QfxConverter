import XCTest

final class OfxValueTests: XCTestCase {
    func testEmptyComparer() {
        XCTAssertEqual(OfxValue.empty, OfxValue.empty)
    }

    func testValueComparer() {
        let dog = OfxValue.value("Dog")
        let cat = OfxValue.value("Cat")
        XCTAssertEqual(dog, dog)
        XCTAssertNotEqual(dog, cat)
    }

    func testMapComparer() {
        let dog = OfxValue.map(OfxMap([
            "type": .value("Dog")
            ]))
        let anotherDog = OfxValue.map(OfxMap([
            "type": .value("Dog")
            ]))
        let cat = OfxValue.map(OfxMap([
            "type": .value("Cat")
            ]))

        XCTAssertEqual(dog, dog)
        XCTAssertEqual(dog, anotherDog)
        XCTAssertNotEqual(dog, cat)
    }

    func testMixedComparer() {
        let empty = OfxValue.empty
        let value = OfxValue.value("test")
        let map = OfxValue.map(OfxMap())

        XCTAssertNotEqual(empty, value)
        XCTAssertNotEqual(empty, map)
        XCTAssertNotEqual(value, map)
    }

    func testStringLiteralInit() {
        let value1 = OfxValue.value("test")
        let value2: OfxValue = "test"

        XCTAssertEqual(value1, value2)
    }

    func testDictLiteralInit() {
        let ofxsubmap = OfxMap()
        ofxsubmap["key20"] = .empty
        ofxsubmap["key21"] = .value("value21")
        let ofxmap = OfxMap()
        ofxmap["key1"] = .value("value1")
        ofxmap["key2"] = .map(ofxsubmap)
        let map1 = OfxValue.map(ofxmap)

        let map2: OfxValue = [
            "key1": "value1",
            "key2": [
                "key20": .empty,
                "key21": "value21"
            ]
        ]

        XCTAssertEqual(map1, map2)
    }
}
