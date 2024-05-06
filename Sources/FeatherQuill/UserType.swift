
struct UserType : OptionSet {
  init(rawValue: Int) {
    self.rawValue = rawValue
  }
  
  static func matches (_ value: UserType) -> Bool {
    guard value.rawValue > 0 else {
      return false
    }
    let value : Bool = .random()
    print("User Matches: \(value)")
    return value
  }
  
  var rawValue: Int
  
  typealias RawValue = Int
  
  static let proSubscriber : UserType = UserType(rawValue: 1)
  static let testFlightBeta : UserType = .init(rawValue: 2)
  static let any : UserType = .init(rawValue: .max)
  static let `default` : UserType = [.testFlightBeta , proSubscriber]
  static let none : UserType = []
}
