final class QqlPartialSelectQuery {
    private let fields: [String]

    init(fields: [String]) {
        self.fields = fields
    }

    func from(_ path: String) -> QqlSelectQuery {
        return QqlSelectQuery(fields: fields, path: path)
    }
}

final class QqlSelectQuery: QqlQuery {
    private let fields: [String]
    private let path: String
    init(fields: [String], path: String) {
        self.fields = fields
        self.path = path
    }

    func perform(on object: QfxObject) -> [QqlQueryResult] {
        // TODO
        return []
    }

    func headerAsCsv() -> String {
        return fields.joined(separator: ",") + "\n"
    }
}
