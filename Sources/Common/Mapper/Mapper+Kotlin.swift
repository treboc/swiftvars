//  Created by Marvin Lee Kobert on 16.06.24.
//
//

import Foundation

extension Mapper {
  func toKotlinModel(_ model: VariablesModel) throws -> KotlinModel {
    let version = model.version

    let colorTokens = try colorTokens(from: model)
    let colorValues = try colorValues(from: model)
    let radii = try radii(from: model)
    let spacings = try spacings(from: model)

    return KotlinModel(
      version: version,
      colorTokens: colorTokens,
      rawColors: colorValues,
      radii: radii,
      spacings: spacings
    )
  }
}

// MARK: - Private

private extension Mapper {
  func colorTokens(from model: VariablesModel) throws -> [ColorToken] {
    guard let collection = model.collections.first(where: { $0.name == Constants.kColorTokenCollectionName }) else {
      throw MappingError.missingCollection(Constants.kColorTokenCollectionName)
    }

    return try collection
      .modes
      .flatMap { mode in
        try mode.variables
          .map { variable in
            guard let colorMode = ColorMode(rawValue: mode.name) else {
              throw MappingError.noColorModeName(mode.name)
            }
            return try toColorToken(variable, colorMode: colorMode)
          }
      }
  }

  func colorValues(from model: VariablesModel) throws -> [ColorValue] {
    guard let collection = model.collections.first(where: { $0.name == Constants.kColorValueCollectionName }) else {
      throw MappingError.missingCollection(Constants.kColorValueCollectionName)
    }

    return try collection
      .modes
      .flatMap(\.variables)
      .map(toColorValue)
  }

  func radii(from model: VariablesModel) throws -> [KotlinModel.Radius] {
    guard let collection = model.collections.first(where: { $0.name == Constants.kRadiusCollectionName }) else {
      throw MappingError.missingCollection(Constants.kRadiusCollectionName)
    }

    return try collection
      .modes
      .flatMap(\.variables)
      .map(toRadius)
  }

  func spacings(from model: VariablesModel) throws -> [KotlinModel.Spacing] {
    guard let collection = model.collections.first(where: { $0.name == Constants.kSpacingCollectionName }) else {
      throw MappingError.missingCollection(Constants.kSpacingCollectionName)
    }

    guard let mode = collection.modes.first(where: { $0.name == "Android" }) else {
      throw MappingError.noMode("Android")
    }

    let spacings = try mode
      .variables
      .map(toSpacing)

    guard !spacings.isEmpty else {
      throw MappingError.noSpacings
    }

    return spacings
  }

  func toColorValue(_ variable: Variable) throws -> ColorValue {
    let rawColorValue: String?

    if case let .stringValue(value) = variable.value {
      rawColorValue = value
    } else {
      throw MappingError.invalidValue(variable.value)
    }

    #warning("TODO: implement correct error message here")
    guard let rawColorValue else {
      throw MappingError.noColorName
    }

    return ColorValue(
      varName: colorTokenVariableName(from: variable.name),
      hexValue: rawColorValue
    )
  }

  func toHex(_ string: String) throws -> String {
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

  func toRadius(_ variable: Variable) throws -> KotlinModel.Radius {
    let rawRadiusValue: Int?

    if case let .numberValue(value) = variable.value {
      rawRadiusValue = Int(value)
    } else {
      throw MappingError.invalidValue(variable.value)
    }

    guard let rawRadiusValue else {
      throw MappingError.noRadiusValue
    }

    return KotlinModel.Radius(
      varName: radiusVariableName(from: variable.name),
      radius: rawRadiusValue
    )
  }

  func toSpacing(_ variable: Variable) throws -> KotlinModel.Spacing {
    let rawRadiusValue: Int?

    if case let .numberValue(value) = variable.value {
      rawRadiusValue = Int(value)
    } else {
      throw MappingError.invalidValue(variable.value)
    }

    guard let rawRadiusValue else {
      throw MappingError.noRadiusValue
    }

    return KotlinModel.Spacing(
      varName: spacingVariableName(from: variable.name),
      spacing: rawRadiusValue
    )
  }
}
