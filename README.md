# FeatherQuill

Easily rollout your new features to segments of your audience.

[![SwiftPM](https://img.shields.io/badge/SPM-Linux%20%7C%20iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS-success?logo=swift)](https://swift.org)
[![Twitter](https://img.shields.io/badge/twitter-@brightdigit-blue.svg?style=flat)](http://twitter.com/brightdigit)
![GitHub](https://img.shields.io/github/license/brightdigit/FeatherQuill)
![GitHub issues](https://img.shields.io/github/issues/brightdigit/FeatherQuill)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/brightdigit/FeatherQuill/FeatherQuill.yml?label=actions&logo=github&?branch=main)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbrightdigit%2FFeatherQuill%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/brightdigit/FeatherQuill)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbrightdigit%2FFeatherQuill%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/brightdigit/FeatherQuill)

[![Codecov](https://img.shields.io/codecov/c/github/brightdigit/FeatherQuill)](https://codecov.io/gh/brightdigit/FeatherQuill)
[![CodeFactor Grade](https://img.shields.io/codefactor/grade/github/brightdigit/FeatherQuill)](https://www.codefactor.io/repository/github/brightdigit/FeatherQuill)
[![codebeat badge](https://codebeat.co/badges/94a8313d-2215-4ef6-8690-ab7b3e06369c)](https://codebeat.co/projects/github-com-brightdigit-mistkit-main)
[![Code Climate maintainability](https://img.shields.io/codeclimate/maintainability/brightdigit/FeatherQuill)](https://codeclimate.com/github/brightdigit/FeatherQuill)
[![Code Climate technical debt](https://img.shields.io/codeclimate/tech-debt/brightdigit/FeatherQuill?label=debt)](https://codeclimate.com/github/brightdigit/FeatherQuill)
[![Code Climate issues](https://img.shields.io/codeclimate/issues/brightdigit/FeatherQuill)](https://codeclimate.com/github/brightdigit/FeatherQuill)
[![Reviewed by Hound](https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg)](https://houndci.com)

## Features

FeatherQuill is a Swift package that provides a mechanism for implementing offline feature flags in your application. Feature flags allow you to enable or disable features for different users or segments of your user base without requiring a server-side update. This can be useful for A/B testing, rollout strategies, and more.

* **Offline Support:** Feature flags are stored locally on the device, so they can be used even when the device is not connected to the internet.
* **Audience Targeting:** You can target feature flags to specific users or segments of users based on criteria such as user ID or device type.
* **SwiftUI Integration:** Provides a `Feature` struct that integrates seamlessly with SwiftUI for easy feature access in your views.

## Requirements 

**Apple Platforms**

- Xcode 15.3 or later
- Swift 5.10 or later
- iOS 17 / watchOS 10 / tvOS 17 / visionOS 1 / macCatalyst 17 / macOS 14 or later deployment targets

**Linux**

- Ubuntu 20.04 or later
- Swift 5.10 or later

## Installation

To add the FeatherQuill package to your Xcode project, select File > Swift Packages > Add Package Dependency and enter the repository URL.

Using Swift Package Manager add the repository url:

```swift
dependencies: [
  .package(url: "https://github.com/brightdigit/FeatherQuill", from: "1.0.0-alpha.1")
]
```

### Usage

FeatherQuill leverages protocols and generics for a flexible and type-safe experience. Here's a simplified example of how to define and use a feature:

```swift
// Define a user type (e.g., user roles)
public enum UserRole: UserType {
  case free
  case pro
  case admin

  public static var `default`: UserRole {
    return .free
  }
}

// Define a feature with a default value and targeting
struct MyFeature: FeatureFlag {
  static var audience: UserRole { .pro }
  static var probability: Double { 0.2 } // 20% chance of being enabled
  static var initialValue: Bool { false }
  static var options: AvailabilityOptions { .default }

  @Sendable
  static func evaluateUser(_ userType: UserRole) async -> Bool {
    // Optional: Implement custom user evaluation logic here
    return true
  }
}

extension EnvironmentValues {
  public var newDesignFeature: MyFeature.Feature { self[MyFeature.self] }
}

// Accessing the feature in a SwiftUI view
struct MyView: View {
  @Environment(\.myFeature) var myFeature

  var body: some View {
    if myFeature.isAvailable {
      Toggle("Is Enabled", isOn: myFeature.bindingValue)
    } else {
      Text("This feature is disabled.")
    }
  }
}
```

## License

FeatherQuill is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
