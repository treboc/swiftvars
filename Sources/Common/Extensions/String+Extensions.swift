//  Created by Marvin Lee Kobert on 15.06.24.
//  Copyright © 2024 Marvin Lee Kobert. All rights reserved.
//

import Foundation

extension String {
  // MARK: - Color Token

  mutating func toColorTokenVarName() -> String {
    replaceChars()
      .split(separator: "/")
      .map(String.init)
      .toLowerCamelCase()
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
    return map(\.capitalized)
      .joined()
  }

  func toLowerCamelCase() -> String {
    guard count > 1, let firstPart = first else {
      return joined()
    }

    let capitalizedPart = dropFirst()
      .map(\.capitalized)
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
