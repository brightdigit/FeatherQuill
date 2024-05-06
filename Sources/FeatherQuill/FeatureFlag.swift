import SwiftUI


protocol FeatureFlag : EnvironmentKey where Value == Feature<ValueType> {
  associatedtype ValueType = Bool
  
  static var key : String { get }
  static var audience : UserType { get }
  static var probability: Double { get }
  static var initialValue : ValueType { get }
  static var shouldUpdateAvailability : Bool { get }
  static var neverRemove : Bool { get }
}

extension FeatureFlag {
  static var shouldUpdateAvailability : Bool { return true }
  static var neverRemove : Bool { return true }
  static var key : String {
    let typeName = "\(Self.self)"
    let dropCount : Int
    if typeName.hasSuffix("FeatureFlag") {
      dropCount = 10
    } else if typeName.hasSuffix("Feature") {
      dropCount = 7
    } else {
      dropCount = 0
    }
    return .init(typeName.dropLast(dropCount))
  }
  static var defaultValue: Feature<ValueType> {
    .init(
      key: self.key,
      userType: self.audience,
      probability: self.probability,
      defaultValue: self.initialValue,
      shouldUpdateAvailability: self.shouldUpdateAvailability,
      neverRemove: self.neverRemove
    )
  }
}
