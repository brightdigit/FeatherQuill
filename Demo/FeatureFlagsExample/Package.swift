// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeatureFlagsExample",
    platforms: [
      .iOS(.v17),
      .macCatalyst(.v17),
      .macOS(.v14),
      .tvOS(.v17),
      .visionOS(.v1),
      .watchOS(.v10)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FeatureFlagsExample",
            targets: ["FeatureFlagsExample"]),
    ],
    dependencies: [
      .package(name: "FeatherQuill", path: "../..")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FeatureFlagsExample",
            dependencies: [.product(name: "FeatherQuill", package: "FeatherQuill")]
        ),
        .testTarget(
            name: "FeatureFlagsExampleTests",
            dependencies: ["FeatureFlagsExample"]),
    ]
)
