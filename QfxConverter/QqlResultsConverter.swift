import Foundation

fileprivate let dateFormatter = { () -> DateFormatter in
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(secondsFromGMT: 0)!
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter
}()

final class QqlResultsConverter {
    static let `default` = QqlResultsConverter()

    private init() {
    }

    private func parseDateTime(_ s: String) -> String {
        guard s.count >= 14 else {
            return s
        }
        var calendar = Calendar(identifier: .gregorian)
        if let i1 = s.index(of: "["),let i2 = s.index(of: ":"), i1 < i2,
            let tzOffset = Int(s[s.index(after: i1)..<i2]),
            let tz = TimeZone(secondsFromGMT: tzOffset * 3600) {
            calendar.timeZone = tz
        }
        else {
            calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        }
        guard let year = Int(s[0...3]),
            let month = Int(s[4...5]),
            let day = Int(s[6...7]),
            let hour = Int(s[8...9]),
            let minute = Int(s[10...11]),
            let second = Int(s[12...13])
        else {
            return s
        }
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        let date = calendar.date(from: components)!
        return dateFormatter.string(from: date)
    }

    func extract(argument arg: QqlArgument, from object: OfxValue) -> String {
        switch arg {
        case let .string(s,_):
            return object[s].value ?? ""
        case let .date(s,_):
            return parseDateTime(object[s].value ?? "")
        }
    }
}
