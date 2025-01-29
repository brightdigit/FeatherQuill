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

public protocol UserDefaultable: Sendable {
  func bool(forKey key: String) -> Bool
  func double(forKey key: String) -> Double
  func object(forKey key: String) -> Any?
  func set(_ value: Bool, forKey key: String)
  func set(_ value: Double, forKey key: String)
}

extension UserDefaultable {
  // swiftlint:disable:next discouraged_optional_boolean
  public func bool(forKey key: String) -> Bool? {
    self.object(forKey: key).map { _ in
      self.bool(forKey: key)
    }
  }
}

extension UserDefaults {
  public static func wrappedStandard() -> any UserDefaultable {
    UserDefaultsWrapper(userDefaults: .standard)
  }

  public static func wrappedSuite(named suiteName: String) -> any UserDefaultable {
    UserDefaultsWrapper(userDefaults: UserDefaults(suiteName: suiteName))
  }
}
