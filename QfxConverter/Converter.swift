import Foundation

final class Converter {
    let folder: String

    init(folder: String) {
        self.folder = folder
    }

    func convert() throws {
        let parser = QfxParser()
        for filename in try FileManager.default.contentsOfDirectory(atPath: folder) {
            let file = (folder as NSString).appendingPathComponent(filename)
            do {
                let qfx = try String(contentsOfFile: file, encoding: .utf8)
                try parser.parse(qfx)
                print("Found QFX: \(file)")
            }
            catch let error as QfxFormatError {
                print("Error while reading QFX file \(filename): \(error.message)")
                //throw error
            }
        }
    }
}
