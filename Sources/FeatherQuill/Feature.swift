//
//  Feature.swift
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
  import Observation
  import SwiftUI

  @Observable
  /// Set of values for the Feature.
  public class Feature<ValueType, UserTypeValue: UserType> {
    private let featureValue: FeatureValue<ValueType>
    private let availability: FeatureAvailability<UserTypeValue>

    /// Binding value to use for SwiftUI Views.
    public var bindingValue: Binding<ValueType> {
      featureValue.bindingValue
    }

    /// Value of the Feature.
    public var value: ValueType {
      featureValue.value
    }

    fileprivate init(
      value: FeatureValue<ValueType>,
      availability: FeatureAvailability<UserTypeValue>
    ) {
      featureValue = value
      self.availability = availability
    }
  }

  extension Feature {
    internal convenience init(
      key: String,
      defaultValue: ValueType,
      userType: UserTypeValue,
      probability: Double = 0.0,
      options: AvailabilityOptions = [],
      _ audienceCallback: @Sendable @escaping (UserTypeValue) async -> Bool
    ) {
      let value: FeatureValue<ValueType> = .init(key: key, defaultValue: defaultValue)
      let availablity: FeatureAvailability = .init(
        key: key,
        userType: userType,
        probability: probability,
        options: options,
        audienceCallback
      )
      self.init(value: value, availability: availablity)
    }
  }
#endif
