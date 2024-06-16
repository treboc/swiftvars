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

    return parts.toLowerCamelCase()
  }

  mutating func toColorTokenColorName() -> String {
    let prefixes = ["color/"]

    for prefix in prefixes {
      self = replacingOccurrences(of: prefix, with: "")
    }

    return replacingOccurrences(of: "-", with: "/")
      .split(separator: "/")
      .map(String.init)
      .toLowerCamelCase()
  }

  // MARK: - Radius

  mutating func toRadiusVarName() -> String {
    replacingOccurrences(of: "-", with: "")
  }

  // MARK: - Spacing

  mutating func toSpacingVarName() -> String {
    replacingOccurrences(of: "-", with: "")
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
