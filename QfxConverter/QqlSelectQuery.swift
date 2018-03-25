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
        guard let ofx = object.ofx else {
            return []
        }
        let pathComponents = path.components(separatedBy: "/")
        var o: [OfxValue] = [ofx]
        for pathComponent in pathComponents {
            o = o.flatMap { v -> [OfxValue] in
                let v = v[pathComponent]
                switch v {
                case .empty:
                    return []
                case let .array(a):
                    return a
                default:
                    return [v]
                }
            }
        }
        return o.map { v in fields.map { f in v[f].value ?? "" } }
    }

    func headerAsCsv() -> String {
        return fields.joined(separator: ",") + "\n"
    }
}
