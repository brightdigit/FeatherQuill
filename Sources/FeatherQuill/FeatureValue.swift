import Foundation
import SwiftUI
import Observation

@Observable
class FeatureValue<ValueType> {
  
  internal init(userDefaults: UserDefaults = .standard, key: String, defaultValue : ValueType) {
    self.userDefaults = userDefaults
    self.key = key
    self.defaultValue = defaultValue
    let initialValue : ValueType
    let fullKey = [FeatureFlags.rootKey, self.key, FeatureFlags.valueKey].joined(separator: ".")
    self.fullKey = fullKey
    if let currentValue = userDefaults.value(forKey: fullKey) as? ValueType  {
      initialValue = currentValue
    } else {
      print("Setting Default Value")
      userDefaults.setValue(defaultValue, forKey: fullKey)
      initialValue = defaultValue
    }
    self._isEnabled = initialValue
  }
  private var _isEnabled : ValueType {
    didSet {
      self.userDefaults.setValue(self._isEnabled, forKey: self.fullKey)
    }
  }
  let userDefaults : UserDefaults
  let key : String
  let defaultValue : ValueType
  let fullKey : String
  var isEnabled : Binding<ValueType> {
    .init {
      return self._isEnabled
    } set: { value in
      self._isEnabled = value
    }
  }
  
}
