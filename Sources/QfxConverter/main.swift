import Foundation

let exePath = NSString(string: ProcessInfo.processInfo.arguments[0])

guard ProcessInfo.processInfo.arguments.count > 1 else {
    let exeName = exePath.lastPathComponent
    print("Usage: \(exeName) <folder>")
    exit(1)
}

let folder = ProcessInfo.processInfo.arguments[1]

var isDirectory: ObjCBool = false
guard FileManager.default.fileExists(atPath: folder, isDirectory: &isDirectory), isDirectory.boolValue else {
    let exeName = exePath.lastPathComponent
    print("Folder \(folder) not found")
    print()
    print("Usage: \(exeName) <folder>")
    exit(2)
}

print("Converting folder \(folder)")
let converter = Converter(folder: folder)
do {
    try converter.convert(to: NSString(string: folder).appendingPathComponent("results.csv"))
}
catch {
    print("Unexpected error: \(error)")
    exit(255)
}
