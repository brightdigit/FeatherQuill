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

public struct AudienceType: UserType {
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }

  public static func includes(_ value: AudienceType) -> Bool {
    guard value.rawValue > 0 else {
      return false
    }
    let value: Bool = .random()
    print("User Matches: \(value)")
    return value
  }

  public var rawValue: Int

  public typealias RawValue = Int

  public static let proSubscriber: AudienceType = .init(rawValue: 1)
  public static let testFlightBeta: AudienceType = .init(rawValue: 2)
  public static let any: AudienceType = .init(rawValue: .max)
  public static let `default`: AudienceType = [.testFlightBeta, proSubscriber]
  public static let none: AudienceType = []
}

struct MockFeatureFlag: FeatureFlag {
  static let initialValue: Int = .random(in: 1_000 ... 9_999)

  typealias UserTypeValue = AudienceType

  static let probability: Double = .random(in: 0 ..< 1)
}

final class FeatureTests: XCTestCase {
  func testExample() throws {
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
  }

  func testMockFlag() {
    XCTAssertEqual(MockFeatureFlag.key, "Mock")
    let defaultMock = MockFeatureFlag.defaultValue
//    XCTAssertEqual(
//      defaultMock.value.wrappedValue, MockFeatureFlag.initialValue
//    )
  }
}
