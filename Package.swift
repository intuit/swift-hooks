// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftHooks",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftHooks",
            targets: ["SwiftHooks"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.45.1"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat.git", from: "0.49.1"),
        .package(url: "https://github.com/tuist/xcbeautify.git", from: "0.11.0"),
        .package(url: "https://github.com/apple/swift-docc.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "SwiftHooks", exclude: ["Documentation.docc"]),
        .target(name: "ExampleLibrary", dependencies: ["SwiftHooks"]),
        .testTarget(name: "HooksTests", dependencies: ["SwiftHooks"]),
        .testTarget(name: "ExampleLibraryTests", dependencies: ["ExampleLibrary"]),
    ]
)
