extension String {
    // WTF, Swift 4??
    subscript(value: CountableClosedRange<Int>) -> Substring {
        return self[index(startIndex, offsetBy: value.lowerBound)...index(startIndex, offsetBy: value.upperBound)]
    }
}
