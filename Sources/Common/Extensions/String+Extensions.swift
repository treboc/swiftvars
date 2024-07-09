//  Created by Marvin Lee Kobert on 15.06.24.
//  Copyright © 2024 Marvin Lee Kobert. All rights reserved.
//

import Foundation

extension String {
  // MARK: - Color Token

  mutating func toColorTokenVarName(colorMode: ColorMode) -> String {
    var parts = replaceChars()
      .split(separator: "/")
      .map(String.init)

    parts.insert(colorMode.rawValue, at: 0)

    return parts.toCamelCase()
  }

  mutating func toColorTokenColorName() -> String {
    let prefixes = ["color/"]

    for prefix in prefixes {
      self = replacingOccurrences(of: prefix, with: "")
    }

    return replacingOccurrences(of: "-", with: "/")
      .split(separator: "/")
      .map(String.init)
      .toCamelCase()
  }

  // MARK: - Radius

  mutating func toSwiftRadiusVarName() -> String {
    replacingOccurrences(of: "-", with: "")
  }

  mutating func toKotlinRadiusVarName() -> String {
    replacingOccurrences(of: "-", with: "")
      .capitalizeFirst
  }

  // MARK: - Spacing

  mutating func toSwiftSpacingVarName() -> String {
    replacingOccurrences(of: "-", with: "")
  }

  mutating func toKotlinSpacingVarName() -> String {
    replacingOccurrences(of: "-", with: "")
      .capitalizeFirst
  }
}

extension [String] {
  func toCamelCase() -> String {
    return map(\.capitalizeFirst)
      .joined()
  }

  func toLowerCamelCase() -> String {
    guard count > 1, let firstPart = first else {
      return joined()
    }

    let capitalizedPart = dropFirst()
      .map(\.capitalizeFirst)
      .joined()

    return firstPart.lowercased() + capitalizedPart
  }
}

// MARK: - Private

private extension String {
  static let charsToReplace = [" ", "+", "-"]

  mutating func replaceChars() -> String {
    for char in Self.charsToReplace {
      self = replacingOccurrences(of: char, with: "/")
    }

    return self
  }
}

private extension StringProtocol {
  var capitalizeFirst: String {
    prefix(1).capitalized + dropFirst()
  }
}
