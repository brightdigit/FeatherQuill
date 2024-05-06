import Foundation

extension UserDefaults {
  func setValue(_ value: FeatureAvailabilityMetrics, forKey key: String) {
    self.setValue(value.value, forKey: key)
  }
  
  func metrics(forKey key: String) -> FeatureAvailabilityMetrics? {
    guard self.object(forKey: key) != nil else {
      return nil
    }
    let value : Double = self.double(forKey: key)
    return .init(value: value)
  }
}
