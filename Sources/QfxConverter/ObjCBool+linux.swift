#if !os(macOS)
import Foundation

extension ObjCBool {
    var boolValue: Bool {
        return self
    }
}
#endif
