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
* **Metrics Collection:** FeatherQuill can collect metrics on how feature flags are being used, which can be helpful for evaluating the effectiveness of your A/B tests or other rollout strategies.

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

## Usage

```swift
import FeatherQuill

// Initialize the client with your bundle identifier as the domain
let plausible = Plausible(domain: "com.example.yourApp")

// Define an event
let event = Event(url: "app://localhost/login")

// Send the event
plausible.send(event: event)
```

### `Plausible` Client

`Plausible` is a client for interacting with the Plausible API. It is initialized with a domain, which is typically your app's bundle identifier. The `Plausible` client is used to send events to the Plausible API for tracking and analysis.

To construct a `Plausible` instance, you need to provide a domain. The domain is a string that identifies your application, typically the bundle identifier of your app.

```swift
let plausible = Plausible(domain: "com.example.yourApp")
```

By default `Plausible` uses a `URLSessionTransport`, however you can use alternatives such as AsyncClient.

### Sending an `Event`

`Event` represents an event in your system. An event has a name, and optionally, a domain, URL, referrer, custom properties (`props`), and revenue information. You can create an `Event` instance and send it using the `Plausible` client.

To construct an `Event`, you need to provide at least a name. The name is a string that identifies the event you want to track. Optionally, you can also provide:

- **`name`** string that represents the name of the event. _Default_ is **pageview**.
- **`url`** string that represents the URL where the event occurred. For an app you may wish to use a app url such as `app://localhost/login`.
- `domain` _optional_ string that identifies the domain in which the event occurred. Overrides whatever was set in the `Plausible` instance.
- `referrer` _optional_ string that represents the URL of the referrer
- `props` _optional_ dictionary of custom properties associated with the event.
- `revenue` _optional_ `Revenue` instance that represents the revenue data associated with the event

```swift
let event = Event
    name: "eventName", 
    domain: "domain",
    url: "url", 
    referrer: "referrer", 
    props: ["key": "value"], 
    revenue: Revenue(
        currencyCode: "USD", 
        amount: 100
    )
)
```

FeatherQuill provides two ways to send events to the Plausible API:

#### Asynchronous Throwing Method

This method sends an event to the Plausible API and throws an error if the operation fails. This is useful when you want to handle errors in your own way. Here's an example:

```swift
do {
    try await plausible.postEvent(event)
} catch {
    print("Failed to post event: \(error)")
}
```

#### Synchronous Method

This method sends an event to the Plausible API in the background and ignores any errors that occur. This is useful when you don't need to handle errors and want to fire-and-forget the event. Here's an example:

```swift
plausible.postEvent(event)
```

In both cases, `event` is an instance of `Event` that you want to send to the Plausible API.

## License

FeatherQuill is available under the MIT license. See the [LICENSE](LICENSE) file for more info.