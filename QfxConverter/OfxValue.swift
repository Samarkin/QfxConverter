enum OfxValue {
    case empty
    case map(OfxMap)
    case value(String)
}

extension OfxValue {
    subscript(key: String) -> OfxValue {
        if case let .map(map) = self {
            return map[key]
        }
        else {
            return .empty
        }
    }
    var value: String? {
        if case let .value(s) = self {
            return s
        }
        else {
            return nil
        }
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
        return false
    }
}
