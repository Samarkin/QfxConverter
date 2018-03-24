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
    func add(key: String, value: OfxValue) {
        guard let x = dict[key] else {
            dict[key] = value
            return
        }
        guard case var .array(xs) = x else {
            dict[key] = [x, value]
            return
        }
        xs.append(value)
        dict[key] = .array(xs)
    }
}

extension OfxMap: CustomStringConvertible {
    var description: String {
        var result = "{"
        for (k,v) in dict {
            if result.count > 1 {
                result += ","
            }
            result += "\"\(k.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\""))\":\(v)"
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
