import XCTest
@testable import QfxConverterTests

XCTMain([
    testCase(OfxMapTests.allTests),
    testCase(OfxValueTests.allTests),
    testCase(QfxV1ParserTests.allTests),
    testCase(QqlResultsConverterTests.allTests),
    testCase(QqlSelectQueryTests.allTests),
])
