enum QqlArgument {
    case string(String, String)
    case date(String, String)
}

extension QqlArgument: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self = .string(value, value)
    }
}

extension String {
    var asDate: QqlArgument {
        return .date(self, self)
    }
    func called(_ name: String) -> QqlArgument {
        return .string(self, name)
    }
}
