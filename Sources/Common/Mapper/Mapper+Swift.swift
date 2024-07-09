//  Created by Marvin Lee Kobert on 16.06.24.
//  
//

import Foundation

extension Mapper {
  static func toSwiftModel(_ model: VariablesModel) throws -> SwiftModel {
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
            return try Mapper.toColorToken(variable, colorMode: colorMode)
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
  static func toColorValue(_ variable: Variable) throws -> ColorValue {
    var name = variable.name
    let rawColorValue: String?

    if case let .stringValue(value) = variable.value {
      rawColorValue = value
    } else {
      throw MappingError.invalidValue(variable.value)
    }

    guard let rawColorValue else {
      throw MappingError.noColorName
    }

    return .init(
      varName: name.toColorTokenColorName(),
      hexValue: ""
    )
  }

  static func toRadius(_ variable: Variable) throws -> SwiftModel.Radius {
    var name = variable.name
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
      varName: name.toSwiftRadiusVarName(),
      radius: Double(rawRadiusValue)
    )
  }

  static func toSpacings(_ collections: [Collection]) throws -> [SwiftModel.Spacing] {
    let collections = collections.filter({ $0.name == Constants.kSpacingCollectionName })

    guard !collections.isEmpty else {
      throw MappingError.noCollection(Constants.kSpacingCollectionName)
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

  static func toSpacing(_ variable: Variable) throws -> SwiftModel.Spacing {
    var name = variable.name
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
      varName: name.toSwiftSpacingVarName(),
      spacing: Double(rawRadiusValue)
    )
  }
}
