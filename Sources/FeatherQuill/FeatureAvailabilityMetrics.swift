//
//  FeatureAvailabilityMetrics.swift
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

internal struct FeatureAvailabilityMetrics<UserTypeValue: UserType>: Equatable, Sendable {
  private let userType: UserTypeValue
  private let probability: Double

  fileprivate var value: Double {
    Double(userType.rawValue) + probability.truncatingRemainder(dividingBy: 1)
  }

  fileprivate init(value: Double) {
    let rawValueDouble = floor(value)
    let rawValue = UserTypeValue.RawValue(rawValueDouble)
    let probability = (value - rawValueDouble)
    self.init(userType: .init(rawValue: rawValue), probability: probability)
  }

  internal init(userType: UserTypeValue, probability: Double) {
    self.userType = userType
    self.probability = Self.roundProbability(probability)
  }

  internal static func roundProbability(_ value: Double) -> Double {
    assert(value <= 1.0)
    return (value * 1_000).rounded() / 1_000.0
  }

  internal func calculateAvailability(
    _ audienceCallback: @Sendable @escaping (UserTypeValue) async -> Bool
  ) async -> Bool {
    let value: Bool
    if await audienceCallback(userType) {
      value = true
    } else {
      let randomValue: Double = .random(in: 0.0 ..< 1.0)
      value = randomValue <= probability
    }
    return value
  }
}

extension UserDefaults {
  internal func set(_ value: FeatureAvailabilityMetrics<some Any>, forKey key: String) {
    set(value.value, forKey: key)
  }

  internal func metrics<UserTypeValue>(
    forKey key: String
  ) -> FeatureAvailabilityMetrics<UserTypeValue>? {
    guard object(forKey: key) != nil else {
      return nil
    }
    let value: Double = double(forKey: key)
    return .init(value: value)
  }
}
