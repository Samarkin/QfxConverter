enum OfxValue {
    case empty
    case map(OfxMap)
    case value(String)
    case array([OfxValue])
}

extension OfxValue {
    subscript(key: String) -> OfxValue {
        guard case let .map(map) = self else {
            return .empty
        }
        return map[key]
    }
}

extension OfxValue: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self = .value(value)
    }
}

extension OfxValue: ExpressibleByDictionaryLiteral {
    init(dictionaryLiteral elements: (String, OfxValue)...) {
        let map = OfxMap()
        for (k,v) in elements {
            map[k] = v
        }
        self = .map(map)
    }
}

extension OfxValue: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: OfxValue...) {
        self = .array(elements)
    }
}

extension OfxValue: CustomStringConvertible {
    var description: String {
        switch self {
        case .empty:
            return "null"
        case let .value(v):
            return "\"\(v.description.replacingOccurrences(of: "\"", with: "\\\""))\""
        case let .map(m):
            return m.description
        case let .array(a):
            var result = "["
            for (i,v) in a.enumerated() {
                if i > 0 {
                    result += ","
                }
                result += v.description
            }
            result += "]"
            return result
        }
    }
}

extension OfxValue: Equatable {
    static func ==(left: OfxValue, right: OfxValue) -> Bool {
        if case let .value(leftValue) = left, case let .value(rightValue) = right {
            return leftValue == rightValue
        }
        if case let .map(leftMap) = left, case let .map(rightMap) = right {
            return leftMap == rightMap
        }
        if case .empty = left, case .empty = right {
            return true
        }
        if case let .array(leftArray) = left, case let .array(rightArray) = right {
            return leftArray == rightArray
        }
        return false
    }
}
