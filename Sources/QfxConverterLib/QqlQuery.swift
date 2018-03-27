public typealias QqlQueryResult = [String]

public protocol QqlQuery {
    func perform(on: QfxObject) -> [QqlQueryResult]
}

// QQL stands for "QFX query language"
public final class Qql {
    public static let query = Qql()
    private init() {
    }
    public func select(_ fields: QqlArgument...) -> QqlPartialSelectQuery {
        return QqlPartialSelectQuery(fields: fields)
    }
}

extension Array where Array.Element == String {
    public func asCsv() -> String {
        return self.joined(separator: ",") + "\n"
    }
}
