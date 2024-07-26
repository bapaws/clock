// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IceCream",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "IceCream",
            targets: ["IceCream"]),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/realm-swift.git", from: "10.47.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "IceCream",
            dependencies: [
                .product(name: "RealmSwift", package: "realm-swift"),
            ]),
        .testTarget(
            name: "IceCreamTests",
            dependencies: ["IceCream"]),
    ])
