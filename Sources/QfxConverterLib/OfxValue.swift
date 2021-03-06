public enum OfxValue {
    case empty
    case map(OfxMap)
    case value(String)
    case array([OfxValue])
}

public extension OfxValue {
    public subscript(key: String) -> OfxValue {
        guard case let .map(map) = self else {
            return .empty
        }
        return map[key]
    }
    public subscript(index: Int) -> OfxValue {
        guard case let .array(array) = self, 0..<array.count ~= index else {
            return .empty
        }
        return array[index]
    }
    public var value: String? {
        guard case let .value(s) = self else {
            return nil
        }
        return s
    }
}

extension OfxValue: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .value(value)
    }
}

extension OfxValue: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, OfxValue)...) {
        let map = OfxMap()
        for (k,v) in elements {
            map[k] = v
        }
        self = .map(map)
    }
}

extension OfxValue: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: OfxValue...) {
        self = .array(elements)
    }
}

extension OfxValue: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty:
            return "null"
        case let .value(v):
            return "\"\(v.description.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\""))\""
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
    public static func ==(left: OfxValue, right: OfxValue) -> Bool {
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
