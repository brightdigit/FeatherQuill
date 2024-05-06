//
//  NewDesignFeature.swift
//  FeatureFlagsApp
//
//  Created by Leo Dion on 5/6/24.
//

import Foundation
import FeatherQuill
import SwiftUI

struct NewDesignFeature : FeatureFlag {
  typealias UserTypeValue = AudienceType
  
  static let probability: Double = 0.5
  static let initialValue: Bool = false
}

extension EnvironmentValues {
  public var newDesign: Feature<Bool, AudienceType>  {
    get { self[NewDesignFeature.self] }
  }
}
