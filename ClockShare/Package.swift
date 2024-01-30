// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ClockShare",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .macCatalyst(.v15),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "ClockShare", targets: ["ClockShare"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftUIX/SwiftUIX", from: "0.1.9"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.1.5"),
        .package(url: "https://github.com/jdg/MBProgressHUD.git", .upToNextMajor(from: "1.2.0")),
        .package(name: "KeychainSwift", url: "https://github.com/evgenyneu/keychain-swift.git", from: "20.0.0"),
        .package(url: "https://github.com/malcommac/SwiftDate.git", from: "5.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "ClockShare", dependencies: [
            "SwiftUIX",
            "KeychainSwift",
            "SwiftDate",
            "MBProgressHUD",
            .product(name: "Dependencies", package: "swift-dependencies"),
        ]),
        .testTarget(name: "ClockShareTests", dependencies: ["ClockShare"]),
    ])
