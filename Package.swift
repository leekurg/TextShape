// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TextShape",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "TextShape",
            targets: ["TextShape"]
        )
    ],
    targets: [
        .target(
            name: "TextShape"),
        .testTarget(
            name: "TextShapeTests",
            dependencies: ["TextShape"]
        )
    ]
)
