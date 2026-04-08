// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "KeyBridgeConnect",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "KeyBridgeConnect",
            targets: ["KeyBridgeConnect"]
        )
    ],
    targets: [
        .target(
            name: "KeyBridgeConnect",
            path: "Sources/KeyBridgeConnect"
        ),
        .testTarget(
            name: "KeyBridgeConnectTests",
            dependencies: ["KeyBridgeConnect"],
            path: "Tests/KeyBridgeConnectTests"
        )
    ]
)
