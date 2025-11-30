// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ConcurrentNetworkManager",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ConcurrentNetworkManager",
            targets: ["ConcurrentNetworkManager"]),
    ], dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.2.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ConcurrentNetworkManager",
            dependencies: [ .product(name: "Logging", package: "swift-log")],
        ),
        .testTarget(
            name: "ConcurrentNetworkManagerTests",
            dependencies: ["ConcurrentNetworkManager"],
            swiftSettings: [
                .define("PLATFORM_IOS", .when(platforms: [.iOS])) // Force iOS-only behavior in tests
            ]
        ),
    ]
)
