public enum QqlArgument {
    case string(String, String)
    case date(String, String)
}

extension QqlArgument: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value, value)
    }
}

extension String {
    public var asDate: QqlArgument {
        return .date(self, self)
    }
    public func called(_ name: String) -> QqlArgument {
        return .string(self, name)
    }
}
