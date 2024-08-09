//  Created by Marvin Lee Kobert on 16.06.24.
//  
//

import Foundation

extension Mapper {
  func toSwiftModel(_ model: VariablesModel) throws -> SwiftModel {
    let version = model.version
    let colorTokens = try model.collections
      .filter { $0.name == Constants.kColorTokenCollectionName }
      .flatMap(\.modes)
      .flatMap { mode in
        try mode.variables
          .map { variable in
            guard let colorMode = ColorMode(rawValue: mode.name) else {
              throw MappingError.noColorModeName(mode.name)
            }
            return try toColorToken(variable, colorMode: colorMode)
          }
      }

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

    let spacings = try toSpacings(model.collections)

    return SwiftModel(
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
  func toColorValue(_ variable: Variable) throws -> ColorValue {
    let rawColorValue: String?

    if case let .stringValue(value) = variable.value {
      rawColorValue = value
    } else {
      throw MappingError.invalidValue(variable.value)
    }

    guard rawColorValue != nil else {
      throw MappingError.noColorName
    }

    #warning("TODO: implement colorValue")
    return .init(
      varName: colorTokenColorName(from: variable.name),
      hexValue: ""
    )
  }

  func toRadius(_ variable: Variable) throws -> SwiftModel.Radius {
    let rawRadiusValue: Int?

    if case let .numberValue(value) = variable.value {
      rawRadiusValue = Int(value)
    } else {
      throw MappingError.invalidValue(variable.value)
    }

    guard let rawRadiusValue else {
      throw MappingError.noRadiusValue
    }

    return .init(
      varName: radiusVariableName(from: variable.name),
      radius: Double(rawRadiusValue)
    )
  }

  func toSpacings(_ collections: [Collection]) throws -> [SwiftModel.Spacing] {
    let collections = collections.filter({ $0.name == Constants.kSpacingCollectionName })

    guard !collections.isEmpty else {
      throw MappingError.missingCollection(Constants.kSpacingCollectionName)
    }

    let mode = collections
      .flatMap(\.modes)
      .first(where: { $0.name == "ios" })

    guard let mode else {
      throw MappingError.noMode("ios")
    }

    let spacings = try mode
      .variables
      .map(toSpacing)

    guard !spacings.isEmpty else {
      throw MappingError.noSpacings
    }

    return spacings
  }

  func toSpacing(_ variable: Variable) throws -> SwiftModel.Spacing {
    let rawRadiusValue: Int?

    if case let .numberValue(value) = variable.value {
      rawRadiusValue = Int(value)
    } else {
      throw MappingError.invalidValue(variable.value)
    }

    guard let rawRadiusValue else {
      throw MappingError.noRadiusValue
    }

    return .init(
      varName: spacingVariableName(from: variable.name),
      spacing: Double(rawRadiusValue)
    )
  }
}
