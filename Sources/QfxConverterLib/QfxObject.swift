public class QfxObject {
    public var version: String?
    public var security: QfxSecurity?
    public var ofx: OfxValue?
}

public enum QfxSecurity {
    case none
    case other(String)
}
