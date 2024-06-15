//  Created by Marvin Lee Kobert on 15.06.24.
//  Copyright © 2024 Marvin Lee Kobert. All rights reserved.
//

import Foundation

private enum Constants {
  static let kColorTokenCollectionName = "Color Token"
  static let kRadiusCollectionName = "Radius"
  static let kSpacingCollectionName = "Spacings"
}

enum Mapper {
  static func toSwiftModel(_ model: VariablesModel) throws -> SwiftModel {
    let version = model.version
    let colorTokens = try model.collections
      .filter { $0.name == Constants.kColorTokenCollectionName }
      .flatMap(\.modes)
      .flatMap(\.variables)
      .map(toColorToken)

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
      radii: radii,
      spacings: spacings
    )
  }
}

private extension Mapper {
  static func toColorToken(_ variable: Variable) throws -> ColorToken {
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
      varName: name.toColorTokenVarName(),
      colorName: rawColorName.toColorTokenColorName()
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
