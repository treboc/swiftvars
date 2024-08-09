//  Created by Marvin Lee Kobert on 15.06.24.
//  Copyright © 2024 Marvin Lee Kobert. All rights reserved.
//

import Foundation

protocol MapperProtocol {
  var platform: Platform { get }

  func toColorToken(_ variable: Variable, colorMode: ColorMode) throws -> ColorToken
  func colorTokenColorName(from input: String) -> String
  func colorTokenVariableName(from input: String) -> String
  func radiusVariableName(from input: String) -> String
  func spacingVariableName(from input: String) -> String

  // Kotlin
  func toKotlinModel(_ model: VariablesModel) throws -> KotlinModel

  // Swift
  func toSwiftModel(_ model: VariablesModel) throws -> SwiftModel
}

struct Mapper: MapperProtocol {
  let platform: Platform

  func toColorToken(_ variable: Variable, colorMode: ColorMode) throws -> ColorToken {
    let rawColorName: String?

    if case let .stringValue(value) = variable.value {
      rawColorName = value
    } else if case let .objectValue(value) = variable.value {
      guard value.collection == .primitives else {
        throw MappingError.invalidCollection(value.collection)
      }

      rawColorName = value.name
    } else {
      throw MappingError.invalidValue(variable.value)
    }

    guard let rawColorName, !rawColorName.isEmpty else {
      throw MappingError.noColorName
    }

    return ColorToken(
      varName: colorTokenVariableName(from: variable.name),
      colorName: colorTokenColorName(from: rawColorName),
      colorMode: colorMode
    )
  }
}

// MARK: - ColorToken

extension Mapper {
  func colorTokenVariableName(from input: String) -> String {
    let parts = input
      .substringFromLastOccurrence(of: "/")
      .split(separator: "-")
      .map(String.init)

    return switch platform.defaultCaseStyle {
    case .lowerCamelCase:
      parts.toLowerCamelCase()
    case .upperCamelCase:
      parts.toUpperCamelCase()
    }
  }

  func colorTokenColorName(from input: String) -> String {
    let parts = input
      .replacingOccurrences(of: "-", with: "/")
      .split(separator: "/")
      .map(String.init)

    return switch platform.defaultCaseStyle {
    case .lowerCamelCase:
      parts.toLowerCamelCase()
    case .upperCamelCase:
      parts.toUpperCamelCase()
    }
  }
}

// MARK: - RawColor

extension Mapper {
  func colorValueName(from input: String) -> String {
    let parts = input
      .replacingOccurrences(of: "color/", with: "")
      .replacingOccurrences(of: "-", with: "/")
      .split(separator: "/")
      .map(String.init)

    return switch platform.defaultCaseStyle {
    case .lowerCamelCase:
      parts.toLowerCamelCase()
    case .upperCamelCase:
      parts.toUpperCamelCase()
    }
  }
}

// MARK: - Radius

extension Mapper {
  func radiusVariableName(from input: String) -> String {
    let formatted = input.replacingOccurrences(of: "-", with: "")

    return switch platform.defaultCaseStyle {
    case .lowerCamelCase:
      formatted
    case .upperCamelCase:
      formatted.capitalized
    }
  }
}

// MARK: - Spacing

extension Mapper {
  func spacingVariableName(from input: String) -> String {
    let formatted = input.replacingOccurrences(of: "-", with: "")

    return switch platform.defaultCaseStyle {
    case .lowerCamelCase:
      formatted
    case .upperCamelCase:
      formatted.capitalized
    }
  }
}

// MARK: - Constants

extension Constants {
  static let kColorTokenCollectionName = "Color Token"
  static let kColorValueCollectionName = "Primitives"
  static let kRadiusCollectionName = "Radius"
  static let kSpacingCollectionName = "Spacings"
}
