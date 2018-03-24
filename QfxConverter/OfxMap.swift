class OfxMap {
    fileprivate var dict: Dictionary<String, OfxValue>
    init() {
        dict = [:]
    }
    init(_ dict: Dictionary<String, OfxValue> = [:]) {
        self.dict = dict
    }
    subscript(key: String) -> OfxValue {
        get {
            return dict[key] ?? .empty
        }
        set {
            dict[key] = newValue
        }
    }
}

extension OfxMap: CustomStringConvertible {
    var description: String {
        var result = "{"
        for (k,v) in dict {
            if result.count > 1 {
                result += ","
            }
            result += "\"\(k)\": "
            switch v {
            case .empty:
                result += "null"
            case let .value(v):
                result += "\"\(v)\""
            case let .map(m):
                result += "\"\(m)\""
            }
        }
        result += "}"
        return result
    }
}

extension OfxMap: Equatable {
    static func ==(left: OfxMap, right: OfxMap) -> Bool {
        return left.description == right.description
    }
}