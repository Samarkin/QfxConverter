import Foundation

public final class QfxParser {
    public init() {
    }
    public func parse(_ qfx: String) throws -> QfxObject {
        for ch in qfx {
            if CharacterSet.whitespacesAndNewlines.contains(ch.unicodeScalars.first!) {
                continue
            }
            switch ch {
            case "A"..."Z":
                return try QfxV1Parser().parse(qfx)
            case "<":
                return try QfxV2Parser().parse(qfx)
            default:
                throw QfxFormatError(message: "Unsupported format")
            }
        }
        throw QfxFormatError(message: "Empty input")
    }
}
