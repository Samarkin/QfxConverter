import Foundation
import QfxConverterLib

final class Converter {
    let folder: String

    init(folder: String) {
        self.folder = folder
    }

    func convert(to outputFile: String) throws {
        let query = Qql.query
            .select("DTPOSTED".asDate, "NAME", "TRNAMT".called("SPEND,DEPOSIT"))
            .from("CREDITCARDMSGSRSV1/CCSTMTTRNRS/CCSTMTRS/BANKTRANLIST/STMTTRN")
        let parser = QfxParser()
        var results: [QqlQueryResult] = []
        for filename in try FileManager.default.contentsOfDirectory(atPath: folder) {
            guard filename.hasSuffix(".qfx") || filename.hasSuffix(".ofx") else {
                continue
            }
            let file = NSString(string: folder).appendingPathComponent(filename)
            do {
                let qfx = try String(contentsOfFile: file, encoding: .utf8)
                let obj = try parser.parse(qfx)
                results.append(contentsOf: query.perform(on: obj))
                print("Found QFX: \(file)")
            }
            catch let error as QfxFormatError {
                print("Error while reading QFX file \(filename): \(error.message)")
                //throw error
            }
        }

        let outputUrl = URL(fileURLWithPath: outputFile)
        try query.headerAsCsv().data(using: .utf8)!.write(to: outputUrl)
        let file = try FileHandle(forWritingTo: outputUrl)
        file.seekToEndOfFile()
        for result in results {
            file.write(splitAmt(result).asCsv().data(using: .utf8)!)
        }
        file.closeFile()
    }

    private func splitAmt(_ s: [String]) -> [String] {
        guard let amt = Double(s[2]) else {
            return s
        }
        var s = s
        s[2] = amt > 0 ? ","+s[2] : s[2]+","
        return s
    }
}
