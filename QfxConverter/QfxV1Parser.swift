import Foundation

fileprivate enum State {
    case header
    case preTag
    case tag
    case openTag
    case closeTag
    case value
}

final class QfxV1Parser {
    func parse(_ qfx: String) throws -> QfxObject {
        var state = State.header
        var header = ""
        var tagname = ""
        var value = ""

        var mapStack: [(String, OfxMap)] = []
        for ch in qfx {
            switch state {
            case .header:
                if ch != "<" {
                    header.append(ch)
                }
                else {
                    let map = OfxMap()
                    mapStack.append(("_root",map))
                    state = .tag
                }
            case .preTag:
                if CharacterSet.whitespacesAndNewlines.contains(ch.unicodeScalars.first!) {
                    break
                }
                if ch != "<" {
                    throw QfxFormatError(message: "Tag is expected, but found \"\(ch)\"")
                }
                state = .tag
            case .tag:
                if ch == ">" {
                    throw QfxFormatError(message: "Empty tag name")
                }
                else if ch == "/" {
                    state = .closeTag
                }
                else {
                    tagname.append(ch)
                    state = .openTag
                }
            case .openTag:
                if ch != ">" {
                    tagname.append(ch)
                }
                else {
                    state = .value
                }
            case .closeTag:
                if ch != ">" {
                    tagname.append(ch)
                }
                else {
                    guard let (name,_) = mapStack.popLast() else {
                        throw QfxFormatError(message: "Extra closing tag \"</\(tagname)>\"")
                    }
                    guard name == tagname else {
                        throw QfxFormatError(message: "Closing tag \"</\(tagname)>\" does not match opening tag \"<\(name)>\"")
                    }
                    tagname = ""
                    state = .preTag
                }
            case .value:
                if ch != "<" {
                    value.append(ch)
                }
                else {
                    value = value.trimmingCharacters(in: .whitespacesAndNewlines)
                    if value != "" {
                        guard let (_, map) = mapStack.last else {
                            throw QfxFormatError(message: "Orphaned value \"\(value)\"")
                        }
                        map[tagname] = .value(value)
                        tagname = ""
                        value = ""
                        state = .tag
                    }
                    else {
                        guard let (_, map) = mapStack.last else {
                            throw QfxFormatError(message: "Orphaned object")
                        }
                        let newMap = OfxMap()
                        // TODO: Duplicate tagnames = arrays
                        map[tagname] = .map(newMap)
                        mapStack.append((tagname,newMap))
                        tagname = ""
                        state = .tag
                    }
                }
            }
        }
        if mapStack.count > 1 {
            throw QfxFormatError(message: "Missing closing tag for \"<\(mapStack.last!.0)>\"")
        }
        else if mapStack.count < 1 {
            throw QfxFormatError(message: "Orphaned root")
        }

        guard mapStack[0].0 == "_root" else {
            throw QfxFormatError(message: "More than one root")
        }
        let root = mapStack[0].1["OFX"]
        guard root != .empty else {
            throw QfxFormatError(message: "Root tag is not \"OFX\"")
        }
        let result = QfxObject()
        result.ofx = root
        return result
    }
}
