// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TextShape",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "TextShape",
            targets: ["TextShape"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/leekurg/EPath", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "TextShape",
            dependencies: ["EPath"]
        )
    ]
)
