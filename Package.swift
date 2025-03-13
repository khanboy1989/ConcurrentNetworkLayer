// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let settings: [SwiftSetting] = [
    .enableExperimentalFeature("StrictConcurrency")
]

let package = Package(
    name: "ConcurrentNetworkManager",
    platforms: [
        .iOS(.v17),
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ConcurrentNetworkManager",
            targets: ["ConcurrentNetworkManager"]),
    ], dependencies: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.58.2")
        
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ConcurrentNetworkManager",
            dependencies: [],
            swiftSettings: settings,
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
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
