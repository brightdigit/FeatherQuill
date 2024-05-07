//
//  FeatureValue.swift
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
  import Foundation
  import Observation
  import SwiftUI

  @Observable
  public class FeatureValue<ValueType> {
    private let userDefaults: UserDefaults
    private let key: String
    private let defaultValue: ValueType
    private let fullKey: String
    public var value: Binding<ValueType> {
      .init {
        self._value
      } set: { value in
        self._value = value
      }
    }

    private var _value: ValueType {
      didSet {
        userDefaults.setValue(_value, forKey: fullKey)
      }
    }

    internal init(
      key: String,
      defaultValue: ValueType,
      userDefaults: UserDefaults = .standard
    ) {
      self.userDefaults = userDefaults
      self.key = key
      self.defaultValue = defaultValue
      let initialValue: ValueType
      let fullKey = [
        FeatureFlags.rootKey, self.key, FeatureFlags.valueKey
      ].joined(separator: ".")
      self.fullKey = fullKey
      if let currentValue = userDefaults.value(forKey: fullKey) as? ValueType {
        initialValue = currentValue
      } else {
        userDefaults.setValue(defaultValue, forKey: fullKey)
        initialValue = defaultValue
      }
      _value = initialValue
    }
  }
#endif
