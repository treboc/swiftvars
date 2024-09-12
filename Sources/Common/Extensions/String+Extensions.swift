//  Created by Marvin Lee Kobert on 15.06.24.
//  Copyright © 2024 Marvin Lee Kobert. All rights reserved.
//

import Foundation

extension String {
  func substringFromLastOccurrence(of character: Character) -> String {
    guard self.contains(character), self.count > 1 else {
      return self
    }

    let index = lastIndex(of: character) ?? startIndex
    let indexAfterCharacter = self.index(after: index)
    return String(self[indexAfterCharacter...])
  }
}

extension [String] {
  func toUpperCamelCase() -> String {
    return map(\.capitalizeFirst)
      .joined()
  }

  func toLowerCamelCase() -> String {
    guard count > 1, let firstPart = first else {
      let string = joined()
      guard let firstChar = string.first?.lowercased() else {
        return string
      }
      let sequenceAfterFirstChar = string.dropFirst()
      return firstChar.lowercased() + sequenceAfterFirstChar
    }

    let capitalizedPart = dropFirst()
      .map(\.capitalizeFirst)
      .joined()

    return firstPart.lowercased() + capitalizedPart
  }
}

private extension StringProtocol {
  var capitalizeFirst: String {
    prefix(1).capitalized + dropFirst()
  }
}
