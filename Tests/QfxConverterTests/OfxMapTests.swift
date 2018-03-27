import XCTest
@testable import QfxConverterLib

final class OfxMapTests: XCTestCase {
    func testComparer() {
        let map1 = OfxMap([
            "key0": .empty,
            "key1": "value1",
            ])
        let map2 = OfxMap([
            "key0": .empty,
            "key1": "value1",
            ])
        XCTAssertEqual(map1, map2)
        XCTAssertEqual(map2, map1)
    }

    func testCompDifferentValues() {
        let map1 = OfxMap([
            "key1": "value1",
            ])
        let map2 = OfxMap([
            "key1": "value2",
            ])
        XCTAssertNotEqual(map1, map2)
        XCTAssertNotEqual(map2, map1)
    }

    func testCompDifferentKeys() {
        let map1 = OfxMap()
        map1["key1"] = "value1"

        let map2 = OfxMap()
        map2["key2"] = "value1"

        XCTAssertNotEqual(map1, map2)
        XCTAssertNotEqual(map2, map1)
    }

    func testCompMoreKeys() {
        let map1 = OfxMap([
            "key1": "value1",
            "key2": "value1",
            ])
        let map2 = OfxMap([
            "key1": "value1",
            ])

        XCTAssertNotEqual(map1, map2)
        XCTAssertNotEqual(map2, map1)
    }

    func testCompRecursive() {
        let map1 = OfxMap([
            "key1": "value1",
            "key2": [
                "key21": "value21",
                ],
            ])
        let map2 = OfxMap([
            "key1": "value1",
            "key2": [
                "key21": "value21",
                ],
            ])

        XCTAssertEqual(map1, map2)
        XCTAssertEqual(map2, map1)
    }

    func testCompRecursiveNegative() {
        let map1 = OfxMap([
            "key1": "value1",
            "key2": [
                "key21": "value21",
                ],
            ])
        let map2 = OfxMap([
            "key1": "value1",
            "key2": "value21",
            ])

        XCTAssertNotEqual(map1, map2)
        XCTAssertNotEqual(map2, map1)
    }
    
    func testSubscript() {
        let map = OfxMap()
        map["key1"] = "value1"

        XCTAssertEqual(map["key1"], "value1")
        XCTAssertEqual(map["key2"], .empty)
    }

    func testAdd() {
        let map = OfxMap()

        map.add(key: "key", value: "value1")
        XCTAssertEqual(map["key"], "value1")

        map.add(key: "key", value: "value2")
        XCTAssertEqual(map["key"], ["value1", "value2"])

        map.add(key: "key", value: "value3")
        XCTAssertEqual(map["key"], ["value1", "value2", "value3"])
    }
}
