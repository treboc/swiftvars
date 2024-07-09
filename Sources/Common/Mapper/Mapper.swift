//  Created by Marvin Lee Kobert on 15.06.24.
//  Copyright © 2024 Marvin Lee Kobert. All rights reserved.
//

import Foundation

enum Mapper {}

extension Mapper {
  static func toColorToken(_ variable: Variable, colorMode: ColorMode) throws -> ColorToken {
    var name = variable.name
    let rawColorName: String?

    if case let .stringValue(value) = variable.value {
      rawColorName = value
    } else if case let .objectValue(value) = variable.value {
      guard let collection = value.collection, value.collection == .primitives else {
        throw MappingError.invalidCollection(value.collection)
      }

      rawColorName = value.name
    } else {
      throw MappingError.invalidValue(variable.value)
    }

    guard var rawColorName, !rawColorName.isEmpty else {
      throw MappingError.noColorName
    }

    return ColorToken(
      varName: name.toColorTokenVarName(colorMode: colorMode),
      colorName: rawColorName.toColorTokenColorName()
    )
  }
}

// MARK: - Constants

extension Mapper {
  enum Constants {
    static let kColorTokenCollectionName = "Color Token"
    static let kColorValueCollectionName = "Primitives"
    static let kRadiusCollectionName = "Radius"
    static let kSpacingCollectionName = "Spacings"
  }
}
