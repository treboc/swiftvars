//  Created by Marvin Lee Kobert on 15.06.24.
//  Copyright © 2024 Marvin Lee Kobert. All rights reserved.
//

import Foundation

private enum Constants {
  static let kColorTokenCollectionName = "Color Token"
  static let kColorValueCollectionName = "Primitives"
  static let kRadiusCollectionName = "Radius"
  static let kSpacingCollectionName = "Spacings"
}

enum Mapper {
  static func toSwiftModel(_ model: VariablesModel) throws -> SwiftModel {
    let version = model.version
    let colorTokens = try model.collections
      .filter { $0.name == Constants.kColorTokenCollectionName }
      .flatMap(\.modes)
    // TODO: Improve!
      .map { mode in
        try mode.variables
          .map { variable in
            guard let colorMode = ColorMode(rawValue: mode.name) else {
              throw MappingError.noColorModeName(mode.name)
            }
            return try Mapper.toColorToken(variable, colorMode: colorMode)
          }
      }
      .flatMap { $0 }

    let colorValues = try model.collections
      .filter { $0.name == Constants.kColorValueCollectionName }
      .flatMap(\.modes)
      .flatMap(\.variables)
      .map(toColorValue)

    let radii = try model.collections
      .filter { $0.name == Constants.kRadiusCollectionName }
      .flatMap(\.modes)
      .flatMap(\.variables)
      .map(toRadius)

    // TODO: improve empty check
    let spacings = try model.collections
      .filter { $0.name == Constants.kSpacingCollectionName }
      .flatMap(\.modes)
      .first(where: { $0.name == "ios" })?
      .variables
      .map(toSpacing) ?? []

    return SwiftModel(
      version: version,
      colorTokens: colorTokens,
      colorValues: colorValues,
      radii: radii,
      spacings: spacings
    )
  }
}

private extension Mapper {
  static func toColorToken(_ variable: Variable, colorMode: ColorMode) throws -> ColorToken {
    var name = variable.name
    let rawColorName: String?

    switch variable.value {
    case let .integer(int):
      throw MappingError.invalidValue(int)
    case let .string(string):
      rawColorName = string
    case let .value(value):
      guard case value.collection = .primitives else {
        throw MappingError.invalidCollection(value.collection)
      }

      rawColorName = value.name
    }

    guard var rawColorName else {
      throw MappingError.noColorName
    }

    return ColorToken(
      varName: name.toColorTokenVarName(colorMode: colorMode),
      colorName: rawColorName.toColorTokenColorName()
    )
  }

  static func toColorValue(_ variable: Variable) throws -> ColorValue {
    var name = variable.name
    let rawColorValue: String?

    switch variable.value {
    case let .integer(int):
      throw MappingError.invalidValue(int)
    case let .string(string):
      rawColorValue = string
    case let .value(value):
      throw MappingError.invalidValue(value.collection)
    }

    guard let rawColorValue else {
      throw MappingError.noColorName
    }

    return ColorValue(
      varName: name.toColorTokenColorName(),
      hexValue: rawColorValue
    )
  }

  static func toRadius(_ variable: Variable) throws -> Radius {
    var name = variable.name
    let rawRadiusValue: Int?

    switch variable.value {
    case let .integer(int):
      rawRadiusValue = int
    case let .string(string):
      throw MappingError.invalidValue(string)
    case let .value(value):
      throw MappingError.invalidValue(value.collection)
    }

    guard let rawRadiusValue else {
      throw MappingError.noRadiusValue
    }

    return Radius(
      varName: name.toRadiusVarName(),
      radius: Double(rawRadiusValue)
    )
  }

  static func toSpacing(_ variable: Variable) throws -> Spacing {
    var name = variable.name
    let rawRadiusValue: Int?

    switch variable.value {
    case let .integer(int):
      rawRadiusValue = int
    case let .string(string):
      throw MappingError.invalidValue(string)
    case let .value(value):
      throw MappingError.invalidValue(value.collection)
    }

    guard let rawRadiusValue else {
      throw MappingError.noRadiusValue
    }

    return Spacing(
      varName: name.toSpacingVarName(),
      spacing: Double(rawRadiusValue)
    )
  }
}
