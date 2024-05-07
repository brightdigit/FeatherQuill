//
//  FeatureTests.swift
//  SimulatorServices
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

@testable import FeatherQuill
import XCTest

final class FeatureTests: XCTestCase {
  func testWrapped() throws {
    #if canImport(SwiftUI)
      let key = UUID().uuidString
      let expectedValue = Int.random(in: 100 ... 1_000)
      let feature = Feature(
        key: key,
        defaultValue: 0,
        userType: AudienceType.default
      )
      let fullKey = [
        FeatureFlags.rootKey, key, FeatureFlags.valueKey
      ].joined(separator: ".")
      feature.value.wrappedValue = expectedValue
      let actualValue = UserDefaults.standard.integer(forKey: fullKey)
      XCTAssertEqual(actualValue, expectedValue)
    #else
      throw XCTSkip("Not suported outside of SwiftUI.")

    #endif
  }
}
