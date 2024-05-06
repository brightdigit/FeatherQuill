import Foundation

struct FeatureAvailabilityMetrics : Equatable {
  internal init (value : Double) {
    let rawValueDouble = floor(value)
    let rawValue = Int(rawValueDouble)
    let probability = ((value - rawValueDouble) * 1000).rounded() / 1000.0
    self.init(userType: .init(rawValue: rawValue), probability: probability)
  }
  
  public init(userType: UserType, probability: Double) {
    self.userType = userType
    self.probability = probability
    assert((probability * 1000).rounded() / 1000.0 == probability)
    assert(probability <= 1.0)
  }
  
  let userType : UserType
  let probability : Double
  
  func calculateAvailability () -> Bool {
    let value : Bool
    if UserType.matches(userType) {
      value = true
    } else {
      let randomValue : Double =  .random(in: 0.0..<1.0)
      print("Random Value: \(randomValue)")
      value = randomValue <= self.probability
    }
    return value
  }
  
  var value : Double {
    Double(userType.rawValue) +    probability.remainder(dividingBy: 1)
  }
  
}
