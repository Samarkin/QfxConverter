typealias QqlQueryResult = [String]

protocol QqlQuery {
    func perform(on: QfxObject) -> [QqlQueryResult]
}

final class Qql {
    static let query = Qql()
    private init() {
    }
    func select(_ fields: String...) -> QqlPartialSelectQuery {
        return QqlPartialSelectQuery(fields: fields)
    }
}

extension Array where Array.Element == String {
    func asCsv() -> String {
        return self.joined(separator: ",") + "\n"
    }
}
