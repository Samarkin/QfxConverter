class QfxObject {
    var version: String?
    var security: QfxSecurity?
    var ofx: OfxValue?
}

enum QfxSecurity {
    case none
    case other(String)
}
