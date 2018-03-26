typealias QqlQueryResult = [String]

protocol QqlQuery {
    func perform(on: QfxObject) -> [QqlQueryResult]
}

// QQL stands for "QFX query language"
final class Qql {
    static let query = Qql()
    private init() {
    }
    func select(_ fields: QqlArgument...) -> QqlPartialSelectQuery {
        return QqlPartialSelectQuery(fields: fields)
    }
}

extension Array where Array.Element == String {
    func asCsv() -> String {
        return self.joined(separator: ",") + "\n"
    }
}
