enum QqlArgument {
    case string(String)
    case date(String)
}

extension QqlArgument: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self = .string(value)
    }
}

extension String {
    var asDate: QqlArgument {
        return .date(self)
    }
}
