//
//  AudienceType.swift
//  FeatureFlagsApp
//
//  Created by Leo Dion on 5/6/24.
//

import Foundation
import FeatherQuill

public struct AudienceType : UserType {
  
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }

  public static func includes (_ value: AudienceType) -> Bool {
    guard value.rawValue > 0 else {
      return false
    }
    let value : Bool = .random()
    print("User Matches: \(value)")
    return value
  }

  public var rawValue: Int

  public typealias RawValue = Int

  public static let proSubscriber : AudienceType = AudienceType(rawValue: 1)
  public static let testFlightBeta : AudienceType = .init(rawValue: 2)
  public static let any : AudienceType = .init(rawValue: .max)
  public static let `default` : AudienceType = [.testFlightBeta , proSubscriber]
  public static let none : AudienceType = []
}




