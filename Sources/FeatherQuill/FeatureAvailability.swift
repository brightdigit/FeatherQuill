import Foundation

struct FeatureAvailability {
  private init(userDefaults: UserDefaults, metricsKey: String, availabilityKey: String, shouldUpdateAvailability: Bool, metrics: FeatureAvailabilityMetrics, neverRemove: Bool) {
    self.userDefaults = userDefaults
    self.metricsKey = metricsKey
    self.availabilityKey = availabilityKey
    self.shouldUpdateAvailability = shouldUpdateAvailability
    self.metrics = metrics
    self.neverRemove = neverRemove
  }
  
  
  static let metricsKey = "AvailbilityMetrics"
  static let isAvailableKey = "IsAvailable"
  
  
  init (
    userDefaults: UserDefaults = .standard,
    key: String,
    userType: UserType,
    probability: Double = 0.0,
    shouldUpdateAvailability: Bool = true,
    neverRemove : Bool = true
  ) {
    let metricsKey = [FeatureFlags.rootKey, key, Self.metricsKey].joined(separator: ".")
    let availabilityKey = [FeatureFlags.rootKey, key, Self.isAvailableKey].joined(separator: ".")
    //    self.init(userDefaults: userDefaults, fullKey: fullKey, userType: userType, probability: probability)
    self.init(userDefaults: userDefaults, metricsKey: metricsKey, availabilityKey: availabilityKey, shouldUpdateAvailability: shouldUpdateAvailability, metrics: .init(userType: userType, probability: probability), neverRemove: neverRemove)
    self.initialize()
  }
  let userDefaults : UserDefaults
  let metricsKey : String
  let availabilityKey : String
  let shouldUpdateAvailability: Bool
  let neverRemove : Bool
  let metrics : FeatureAvailabilityMetrics
  
  private func initializeMetrics () -> Bool {
    guard shouldUpdateAvailability else {
      return false
    }
    
    if let oldMetrics : FeatureAvailabilityMetrics = self.userDefaults.metrics(forKey: self.metricsKey) {
      guard metrics != oldMetrics else {
        return false
      }
    }
    
    self.userDefaults.setValue(metrics, forKey: self.metricsKey)
    return true
  }
  
  private func initializeAvailability(force: Bool = false) {
    let isAvailable = self.userDefaults.value(forKey: self.availabilityKey).map { _ in
      self.userDefaults.bool(forKey: self.availabilityKey)
    }
    switch (isAvailable, force, neverRemove) {
    case (true, _, true):
      return
    case (.some(_), false, _):
      return
      
    case (.none, _, _):
    break
    case (_, true, _):
      break
    }
    
    
    let value = self.metrics.calculateAvailability()
    print("Updating Availability: \(value)")
    self.userDefaults.setValue(value, forKey: availabilityKey)
    
  }
  private func initialize () {
    // check for availablity
    let metricsHaveChanged = initializeMetrics()
    initializeAvailability(force: metricsHaveChanged)
  }
  
  var value : Bool {
    assert((self.userDefaults.value(forKey: self.availabilityKey) as? Bool) != nil)
    return self.userDefaults.bool(forKey: self.availabilityKey)
  }
}
