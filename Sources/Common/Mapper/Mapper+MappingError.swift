//  Created by Marvin Lee Kobert on 15.06.24.
//  Copyright © 2024 Marvin Lee Kobert. All rights reserved.
//

import Foundation

enum MappingError: Error {
  case invalidValue(Codable)
  case invalidCollection(Codable)
  case noColorName
  case noColorModeName(String)
  case noRadiusValue

  var description: String {
    switch self {
    case let .invalidValue(valueUnion):
      "Invalid value: \(valueUnion)"

    case let .invalidCollection(collection):
      "Invalid collection: \(collection)"

    case .noColorName:
      "Unable to get colorName from value"

    case let .noColorModeName(found):
      "Unable to get colorModeName from value, found: \(found), expected: light/dark"

    case .noRadiusValue:
      "Unable to get radiusValue from value"
    }
  }
}
