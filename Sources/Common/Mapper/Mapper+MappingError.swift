//  Created by Marvin Lee Kobert on 15.06.24.
//  Copyright © 2024 Marvin Lee Kobert. All rights reserved.
//

import Foundation

enum MappingError: Error {
  case invalidValue(String)
  case invalidCollection(String?)
  case missingCollection(String)
  case noMode(String)
  case noColorName
  case noColorModeName(String)
  case noRadiusValue
  case noSpacings

  var description: String {
    switch self {
    case let .invalidValue(valueUnion):
      "Invalid value: \(valueUnion)"

    case let .invalidCollection(collection):
      "Invalid collection: \(collection ?? "")"

    case let .missingCollection(name):
      "No collection found with name: \(name)"

    case let .noMode(name):
      "No mode found with name: \(name)"

    case .noColorName:
      "Unable to get colorName from value"

    case let .noColorModeName(found):
      "Unable to get colorModeName from value, found: \(found), expected: light/dark"

    case .noRadiusValue:
      "Unable to get radiusValue from value"

    case .noSpacings:
      "No spacings found"
    }
  }
}

extension MappingError: Equatable {
  static func == (lhs: MappingError, rhs: MappingError) -> Bool {
    switch (lhs, rhs) {
    case let (.invalidValue(lhsValue), .invalidValue(rhsValue)):
      "\(lhsValue)" == "\(rhsValue)"

    case let (.invalidCollection(lhsCollection), .invalidCollection(rhsCollection)):
      "\(lhsCollection)" == "\(rhsCollection)"

    case (.noColorName, .noColorName):
      true

    case let (.noColorModeName(lhsFound), .noColorModeName(rhsFound)):
      lhsFound == rhsFound

    case (.noRadiusValue, .noRadiusValue):
      true

    case (.noSpacings, .noSpacings):
      true

    default:
      false
    }
  }
}
