final class QqlPartialSelectQuery {
    private let fields: [QqlArgument]

    init(fields: [QqlArgument]) {
        self.fields = fields
    }

    func from(_ path: String) -> QqlSelectQuery {
        return QqlSelectQuery(fields: fields, path: path)
    }
}

final class QqlSelectQuery: QqlQuery {
    private let fields: [QqlArgument]
    private let path: String
    init(fields: [QqlArgument], path: String) {
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
        return o.map { v in fields.map { f in QqlResultsConverter.default.extract(argument: f, from: v) } }
    }

    func headerAsCsv() -> String {
        return fields.map {
            switch $0 {
            case let .string(_,s): return s
            case let .date(_,s): return s
            }}.joined(separator: ",") + "\n"
    }
}
