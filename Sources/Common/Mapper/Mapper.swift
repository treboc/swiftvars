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

enum Mapper {}

// Kotlin

extension Mapper {
  static func toKotlinModel(_ model: VariablesModel) throws -> KotlinModel {
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
      .map(toKotlinColorValue)

    let radii = try model.collections
      .filter { $0.name == Constants.kRadiusCollectionName }
      .flatMap(\.modes)
      .flatMap(\.variables)
      .map(toKotlinRadius)

    // TODO: improve empty check
    let spacings = try model.collections
      .filter { $0.name == Constants.kSpacingCollectionName }
      .flatMap(\.modes)
      .first(where: { $0.name == "android" })?
      .variables
      .map(toKotlinSpacing) ?? []

    return KotlinModel(
      version: version,
      colorTokens: colorTokens,
      colorValues: colorValues,
      radii: radii,
      spacings: spacings
    )
  }
}

// Swift

extension Mapper {
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
      .map(toSwiftColorValue)

    let radii = try model.collections
      .filter { $0.name == Constants.kRadiusCollectionName }
      .flatMap(\.modes)
      .flatMap(\.variables)
      .map(toSwiftRadius)

    // TODO: improve empty check
    let spacings = try model.collections
      .filter { $0.name == Constants.kSpacingCollectionName }
      .flatMap(\.modes)
      .first(where: { $0.name == "ios" })?
      .variables
      .map(toSwiftSpacing) ?? []

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

  static func toKotlinColorValue(_ variable: Variable) throws -> ColorValue {
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
      hexValue: try toKotlinHex(rawColorValue)
    )
  }

  static func toKotlinHex(_ string: String) throws -> String {
    try Validator.validateHexColor(string)
    let string = string.replacingOccurrences(of: "#", with: "").uppercased()

    if string.count == 3 {
      return "0x" + string
        .map { String($0) + String($0) }
        .joined()
    }

    if string.count == 6 {
      return "0xFF" + string
    }

    // Has to be 8 digits, so return just prefixed.
    return "0x" + string
  }

  static func toSwiftColorValue(_ variable: Variable) throws -> ColorValue {
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

    return .init(
      varName: name.toColorTokenColorName(),
      hexValue: rawColorValue
    )
  }

  static func toSwiftRadius(_ variable: Variable) throws -> SwiftModel.Radius {
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

    return .init(
      varName: name.toRadiusVarName(),
      radius: Double(rawRadiusValue)
    )
  }

  static func toKotlinRadius(_ variable: Variable) throws -> KotlinModel.Radius {
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

    return .init(
      varName: name.toRadiusVarName(),
      radius: rawRadiusValue
    )
  }

  static func toKotlinSpacing(_ variable: Variable) throws -> KotlinModel.Spacing {
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

    return .init(
      varName: name.toSpacingVarName(),
      spacing: rawRadiusValue
    )
  }

  static func toSwiftSpacing(_ variable: Variable) throws -> SwiftModel.Spacing {
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

    return .init(
      varName: name.toSpacingVarName(),
      spacing: Double(rawRadiusValue)
    )
  }
}
