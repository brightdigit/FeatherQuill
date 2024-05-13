// swift-tools-version: 5.9

import PackageDescription

// swiftlint:disable:next explicit_top_level_acl explicit_acl
let package = Package(
  name: "FeatherQuill",
  platforms: [
    .iOS(.v17),
    .macCatalyst(.v17),
    .macOS(.v14),
    .tvOS(.v17),
    .visionOS(.v1),
    .watchOS(.v10)
  ],
  products: [
    .library(
      name: "FeatherQuill",
      targets: ["FeatherQuill"]
    )
  ],
  targets: [
    .target(
      name: "FeatherQuill",
      swiftSettings: [
//        SwiftSetting.enableUpcomingFeature("BareSlashRegexLiterals"),
//        SwiftSetting.enableUpcomingFeature("ConciseMagicFile"),
//        SwiftSetting.enableUpcomingFeature("ExistentialAny"),
//        SwiftSetting.enableUpcomingFeature("ForwardTrailingClosures"),
//        SwiftSetting.enableUpcomingFeature("ImplicitOpenExistentials"),
//        SwiftSetting.enableUpcomingFeature("DisableOutwardActorInference"),
//        SwiftSetting.enableExperimentalFeature("StrictConcurrency"),
//        SwiftSetting.unsafeFlags(["-warn-concurrency", "-enable-actor-data-race-checks"])
      ]
    ),
    .testTarget(
      name: "FeatherQuillTests",
      dependencies: ["FeatherQuill"]
    )
  ]
)
