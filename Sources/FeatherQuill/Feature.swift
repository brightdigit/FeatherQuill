import Observation
import SwiftUI

@Observable
class Feature<ValueType> {
  internal init(value: FeatureValue<ValueType>, availability: FeatureAvailability) {
    self.value = value
    self.availability = availability
  }
  
  let value : FeatureValue<ValueType>
  let availability : FeatureAvailability
  
  var isEnabled : Binding<ValueType> {
    return value.isEnabled
  }
  
  var isAvailable : Bool {
    return availability.value
  }
}

extension Feature {
  convenience init (key : String, userType: UserType, probability: Double = 0.0, defaultValue: ValueType, shouldUpdateAvailability: Bool = true, neverRemove: Bool = true) {
    let value : FeatureValue<ValueType> = .init(key: key, defaultValue: defaultValue)
    let availablity : FeatureAvailability = .init(key: key, userType: userType, probability: probability, shouldUpdateAvailability: shouldUpdateAvailability, neverRemove: neverRemove)
    self.init(value: value, availability: availablity)
  }
}
