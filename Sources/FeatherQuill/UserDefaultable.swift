//
//  UserDefaultable.swift
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

private struct UserDefaultsWrapper: UserDefaultable {
  private let userDefaults: @Sendable () -> UserDefaults?

  fileprivate init(
    userDefaults: @autoclosure @escaping @Sendable () -> UserDefaults?
  ) {
    self.userDefaults = userDefaults
  }

  fileprivate func bool(forKey key: String) -> Bool {
    userDefaults()?.bool(forKey: key) ?? false
  }

  fileprivate func double(forKey key: String) -> Double {
    userDefaults()?.double(forKey: key) ?? .zero
  }

  fileprivate func set(_ value: Double, forKey key: String) {
    userDefaults()?.set(value, forKey: key)
  }

  fileprivate func object(forKey key: String) -> Any? {
    userDefaults()?.object(forKey: key)
  }

  fileprivate func set(_ value: Bool, forKey key: String) {
    self.userDefaults()?.set(value, forKey: key)
  }
}

/// Sendable safe way to access UserDefaults.
public protocol UserDefaultable: Sendable {
  /// Retrieves a boolean value from user defaults for the specified key.
  /// - Parameter key: The key to look up in user defaults.
  /// - Returns: The boolean value associated with the key.
  func bool(forKey key: String) -> Bool

  /// Retrieves a double value from user defaults for the specified key.
  /// - Parameter key: The key to look up in user defaults.
  /// - Returns: The double value associated with the key.
  func double(forKey key: String) -> Double

  /// Retrieves an arbitrary object from user defaults for the specified key.
  /// - Parameter key: The key to look up in user defaults.
  /// - Returns: The object associated with the key, if it exists.
  func object(forKey key: String) -> Any?

  /// Stores a boolean value in user defaults for the specified key.
  /// - Parameters:
  ///   - value: The boolean value to store.
  ///   - key: The key under which to store the value.
  func set(_ value: Bool, forKey key: String)

  /// Stores a double value in user defaults for the specified key.
  /// - Parameters:
  ///   - value: The double value to store.
  ///   - key: The key under which to store the value.
  func set(_ value: Double, forKey key: String)
}

extension UserDefaultable {
  // swiftlint:disable discouraged_optional_boolean

  /// Retrieves an optional boolean value from user defaults for the specified key.
  /// This implementation first checks if an object exists for the key
  /// before attempting to read it as a boolean.
  /// - Parameter key: The key to look up in user defaults.
  /// - Returns: The boolean value if it exists and can be read as a boolean, otherwise nil.
  public func bool(forKey key: String) -> Bool? {
    self.object(forKey: key).map { _ in
      self.bool(forKey: key)
    }
  }

  // swiftlint:enable discouraged_optional_boolean
}

extension UserDefaults {
  /// Creates a wrapped instance of the standard UserDefaults that conforms to UserDefaultable.
  /// - Returns: A UserDefaultable instance that wraps the standard UserDefaults.
  public static func wrappedStandard() -> any UserDefaultable {
    UserDefaultsWrapper(userDefaults: .standard)
  }

  /// Creates a wrapped instance of UserDefaults for the specified suite that conforms to UserDefaultable.
  /// - Parameter suiteName: The name of the suite to create UserDefaults for.
  /// - Returns: A UserDefaultable instance that wraps the suite-specific UserDefaults.
  public static func wrappedSuite(named suiteName: String) -> any UserDefaultable {
    UserDefaultsWrapper(userDefaults: UserDefaults(suiteName: suiteName))
  }
}
