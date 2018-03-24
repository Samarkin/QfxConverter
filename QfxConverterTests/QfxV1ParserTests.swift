import XCTest

final class QfxV1ParserTests: XCTestCase {
    func testEmpty() {
        let parser = QfxV1Parser()
        let result = try! parser.parse("<OFX></OFX>")
        XCTAssertEqual(result.ofx, [:])
    }

    func testKeyValue() {
        let parser = QfxV1Parser()
        let result = try! parser.parse("<OFX><KEY>VALUE</OFX>")
        XCTAssertEqual(result.ofx, ["KEY": "VALUE"])
    }

    func testTwoKeys() {
        let parser = QfxV1Parser()
        let result = try! parser.parse("<OFX><KEY1>VALUE1<KEY2>VALUE2</OFX>")
        XCTAssertEqual(result.ofx, ["KEY1": "VALUE1", "KEY2": "VALUE2"])
    }

    func testSubKeyValue() {
        let parser = QfxV1Parser()
        let result = try! parser.parse("<OFX><KEY><SUBKEY>VALUE</KEY></OFX>")
        XCTAssertEqual(result.ofx, ["KEY": ["SUBKEY":"VALUE"]])
    }

    func testTwoSubKeys() {
        let parser = QfxV1Parser()
        let result = try! parser.parse("<OFX><KEY1><SUBKEY1>VALUE11<SUBKEY2>VALUE12</KEY1><KEY2>VALUE2</OFX>")
        XCTAssertEqual(result.ofx, ["KEY1": ["SUBKEY1":"VALUE11","SUBKEY2":"VALUE12"], "KEY2":"VALUE2"])
    }

    func testWhitespaces() {
        let parser = QfxV1Parser()
        let result = try! parser.parse("\n\n  <OFX>  \t\n<KEY1>\t  <SUBKEY1> \nVALUE11\n<SUBKEY2>\n \tVALUE12\n</KEY1>\n <KEY2>\n  VALUE2\t</OFX>\n  \n")
        XCTAssertEqual(result.ofx, ["KEY1": ["SUBKEY1":"VALUE11","SUBKEY2":"VALUE12"], "KEY2":"VALUE2"])
    }
}
