//
//  FeatureAvailability.swift
//  FeatherQuill
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation

internal struct FeatureAvailability<UserTypeValue: UserType>: Sendable {
  private let userDefaults: any UserDefaultable
  private let metricsKey: String
  private let availabilityKey: String
  private let options: AvailabilityOptions
  private let metrics: FeatureAvailabilityMetrics<UserTypeValue>

  internal var value: Bool {
    userDefaults.bool(forKey: availabilityKey)
  }

  private init(
    userDefaults: any UserDefaultable,
    metricsKey: String,
    availabilityKey: String,
    options: AvailabilityOptions,
    metrics: FeatureAvailabilityMetrics<UserTypeValue>
  ) {
    self.userDefaults = userDefaults
    self.metricsKey = metricsKey
    self.availabilityKey = availabilityKey
    self.options = options
    self.metrics = metrics
  }

  internal init(
    key: String,
    userType: UserTypeValue,
    suiteName: String,
    probability: Double = 0.0,
    options: AvailabilityOptions = [],
    _ availability: @Sendable @escaping (UserTypeValue) async -> Bool
  ) {
    self.init(
      key: key,
      userType: userType,
      probability: probability,
      userDefaults: UserDefaults.wrappedSuite(named: suiteName),
      options: options,
      availability
    )
  }

  internal init(
    key: String,
    userType: UserTypeValue,
    probability: Double = 0.0,
    userDefaults: any UserDefaultable = UserDefaults.wrappedStandard(),
    options: AvailabilityOptions = [],
    _ availability: @Sendable @escaping (UserTypeValue) async -> Bool
  ) {
    let metricsKey = [
      FeatureFlags.rootKey, key, FeatureFlags.metricsKey
    ].joined(separator: ".")
    let availabilityKey = [
      FeatureFlags.rootKey, key, FeatureFlags.isAvailableKey
    ].joined(separator: ".")
    self.init(
      userDefaults: userDefaults,
      metricsKey: metricsKey,
      availabilityKey: availabilityKey,
      options: options,
      metrics: .init(userType: userType, probability: probability)
    )
    initialize(with: availability)
  }

  private func initializeMetrics() -> Bool {
    guard !options.contains(.disableUpdateAvailability) else {
      return false
    }

    if let oldMetrics: FeatureAvailabilityMetrics<UserTypeValue> =
      self.userDefaults.metrics(forKey: self.metricsKey) {
      guard metrics != oldMetrics else {
        return false
      }
    }

    userDefaults.set(metrics, forKey: metricsKey)
    return true
  }

  private func initializeAvailability(
    with audienceCallback: @Sendable @escaping (UserTypeValue) async -> Bool,
    force: Bool = false
  ) {
    // swiftlint:disable:next discouraged_optional_boolean
    let isAvailable: Bool? = userDefaults.bool(forKey: availabilityKey)
    switch (isAvailable, force, options.contains(.allowOverwriteAvailable)) {
    case (true, _, false):
      return
    case (.some, false, _):
      return

    case (.none, _, _):
      break
    case (_, true, _):
      break
    }

    Task {
      let value = await metrics.calculateAvailability(audienceCallback)
      userDefaults.set(value, forKey: availabilityKey)
    }
  }

  private func initialize(with audienceCallback: @Sendable @escaping (UserTypeValue) async -> Bool) {
    let metricsHaveChanged = initializeMetrics()
    initializeAvailability(with: audienceCallback, force: metricsHaveChanged)
  }
}
