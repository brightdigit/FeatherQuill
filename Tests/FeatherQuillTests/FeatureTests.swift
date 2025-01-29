//
//  FeatureTests.swift
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

@testable import FeatherQuill
import XCTest

internal final class FeatureTests: XCTestCase {
  private static func fullKey(for featureKey: String) -> String {
    [FeatureFlags.rootKey, featureKey, FeatureFlags.valueKey].joined(separator: ".")
  }

  #if canImport(SwiftUI)
    private static func feature(key: String) -> Feature<Int, AudienceType> {
      Feature(
        key: key,
        defaultValue: 0,
        userType: AudienceType.default
      ) { _ in true }
    }

    private static func setExpectedValue<ValueType>(
      _ expectedValue: ValueType,
      to feature: Feature<ValueType, some Any>
    ) async {
      await MainActor.run {
        feature.bindingValue.wrappedValue = expectedValue
      }
    }
  #endif

  internal func testWrapped() async throws {
    #if canImport(SwiftUI)
      let key = UUID().uuidString
      let expectedValue = Int.random(in: 100 ... 1_000)
      let feature = Self.feature(key: key)
      let fullKey = Self.fullKey(for: key)
      await Self.setExpectedValue(expectedValue, to: feature)
      let actualValue = UserDefaults.standard.integer(forKey: fullKey)
      XCTAssertEqual(actualValue, expectedValue)
    #else
      throw XCTSkip("Not suported outside of SwiftUI.")
    #endif
  }
}
