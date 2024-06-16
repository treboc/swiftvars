//  Created by Marvin Lee Kobert on 16.06.24.
//
//

import Foundation

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
      .map(toColorValue)

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
      .map(toSpacing) ?? []

    return KotlinModel(
      version: version,
      colorTokens: colorTokens,
      colorValues: colorValues,
      radii: radii,
      spacings: spacings
    )
  }
}

// MARK: - Private

private extension Mapper {
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

  static func toSpacing(_ variable: Variable) throws -> KotlinModel.Spacing {
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
}
