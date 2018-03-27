// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "QfxConverter",
    targets: [
        .target(name: "QfxConverterLib"),
        .target(name: "QfxConverter", dependencies: ["QfxConverterLib"]),
        .testTarget(name: "QfxConverterTests", dependencies: ["QfxConverterLib"]),
    ]
)
