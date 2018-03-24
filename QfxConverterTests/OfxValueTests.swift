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

    func testArrayComparer() {
        let array = OfxValue.array([OfxValue.value("test1"), OfxValue.value("test2")])
        let sameArray = OfxValue.array([OfxValue.value("test1"), OfxValue.value("test2")])
        let differentArray = OfxValue.array([OfxValue.value("test2"), OfxValue.value("test1")])

        XCTAssertEqual(array, sameArray)
        XCTAssertNotEqual(array, differentArray)
    }

    func testMixedComparer() {
        let empty = OfxValue.empty
        let value = OfxValue.value("test")
        let map = OfxValue.map(OfxMap())
        let array = OfxValue.array([OfxValue.value("test1"), OfxValue.value("test2")])

        XCTAssertNotEqual(empty, value)
        XCTAssertNotEqual(empty, map)
        XCTAssertNotEqual(empty, array)
        XCTAssertNotEqual(value, map)
        XCTAssertNotEqual(value, array)
        XCTAssertNotEqual(map, array)
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

    func testArrayLiteralInit() {
        let value1 = OfxValue.array([OfxValue.value("test1"), OfxValue.value("test2")])
        let value2: OfxValue = ["test1", "test2"]

        XCTAssertEqual(value1, value2)
    }

    func testDescription() {
        let v: OfxValue = [
            "key1": "value1",
            "key2": [
                "key20": .empty,
                "key21": ["value21", "value22"]
            ]
        ]

        XCTAssertEqual(v.description, "{\"key2\":{\"key21\":[\"value21\",\"value22\"],\"key20\":null},\"key1\":\"value1\"}")
    }

    func testDescriptionEscaping() {
        let v: OfxValue = [
            "key \"1": "value \"1",
            "key \"2": [
                "key \"20": .empty,
                "key \"21": ["value \"21", "value \"22"]
            ]
        ]

        XCTAssertEqual(v.description, "{\"key \\\"1\":\"value \\\"1\",\"key \\\"2\":{\"key \\\"21\":[\"value \\\"21\",\"value \\\"22\"],\"key \\\"20\":null}}")
    }

    func testSubscript() {
        let innerMap = OfxMap()
        innerMap["key1"] = "value1"
        let map = OfxValue.map(innerMap)

        XCTAssertEqual(map["key1"], "value1")
        XCTAssertEqual(map["key2"], .empty)

        let empty = OfxValue.empty
        let value = OfxValue.value("test")
        let array = OfxValue.array([OfxValue.value("test1"), OfxValue.value("test2")])

        XCTAssertEqual(empty["key1"], .empty)
        XCTAssertEqual(value["test"], .empty)
        XCTAssertEqual(array["0"], .empty)
        XCTAssertEqual(array["test1"], .empty)
    }
}
