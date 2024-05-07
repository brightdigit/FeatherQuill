//
//  FeatureAvailability.swift
//  FeatherQuill
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

internal struct FeatureAvailability<UserTypeValue: UserType> {
  private let userDefaults: UserDefaults
  private let metricsKey: String
  private let availabilityKey: String
  private let options: AvailabilityOptions
  private let metrics: FeatureAvailabilityMetrics<UserTypeValue>

  internal var value: Bool {
    assert((userDefaults.object(forKey: availabilityKey) as? Bool) != nil)
    return userDefaults.bool(forKey: availabilityKey)
  }

  private init(
    userDefaults: UserDefaults,
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
    probability: Double = 0.0,
    userDefaults: UserDefaults = .standard,
    options: AvailabilityOptions = []
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
    initialize()
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

  private func initializeAvailability(force: Bool = false) {
    let isAvailable = userDefaults.object(forKey: availabilityKey).map { _ in
      userDefaults.bool(forKey: availabilityKey)
    }
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

    let value = metrics.calculateAvailability()
    userDefaults.set(value, forKey: availabilityKey)
  }

  private func initialize() {
    let metricsHaveChanged = initializeMetrics()
    initializeAvailability(force: metricsHaveChanged)
  }
}
