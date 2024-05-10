//
//  FeatureFlag.swift
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

#if canImport(SwiftUI)
  import SwiftUI

  private enum FeatureFlagSuffixes {
    static let values: [String] = [
      "FeatureFlag",
      "Feature"
    ]
    private static func dropCount(from typeName: String) -> Int? {
      values.first(where: typeName.hasSuffix(_:)).map(\.count)
    }

    static func key(from typeName: String) -> String {
      guard let dropCount = dropCount(from: typeName) else {
        return typeName
      }
      return .init(typeName.dropLast(dropCount))
    }
  }

  public protocol FeatureFlag: EnvironmentKey
    where Value == FeatherQuill.Feature<ValueType, UserTypeValue> {
    associatedtype ValueType = Bool
    associatedtype UserTypeValue: UserType

    typealias Feature = FeatherQuill.Feature<ValueType, UserTypeValue>

    static var key: String { get }
    static var audience: UserTypeValue { get }
    static var probability: Double { get }
    static var initialValue: ValueType { get }
    static var options: AvailabilityOptions { get }

    @Sendable
    static func audienceCallback(_ userType: UserTypeValue) async -> Bool
  }

  extension FeatureFlag {
    private static var typeName: String {
      "\(Self.self)"
    }

    /// Matching user for ``FeatureFlag
    public static var audience: UserTypeValue {
      .default
    }

    /// Behavior options on how to handle changes.
    public static var options: AvailabilityOptions {
      .default
    }

    /// The key the ``FeatureFlag``.
    public static var key: String {
      FeatureFlagSuffixes.key(from: typeName)
    }

    /// The default value for the environment key.
    public static var defaultValue: FeatherQuill.Feature<ValueType, UserTypeValue> {
      .init(
        key: key,
        defaultValue: initialValue,
        userType: audience,
        probability: probability,
        audienceCallback
      )
    }
  }
#endif
