//  Created by Marvin Lee Kobert on 15.06.24.
//  
//

import Foundation

enum HexColorError: Error, CustomStringConvertible {
  case missingHash
  case invalidLength
  case nonHexCharacter
  case emptyString

  var description: String {
    switch self {
    case .missingHash:
      "Hex color must start with a '#'."
    case .invalidLength:
      "Hex color must be either 7 or 9 characters long (including the '#')."
    case .nonHexCharacter:
      "Hex color contains non-hexadecimal characters."
    case .emptyString:
      "Hex color cannot be an empty string."
    }
  }
}

enum Validator {
  static func validateHexColor(_ hex: String) throws {
    if hex.isEmpty {
      throw HexColorError.emptyString
    }

    guard hex.hasPrefix("#") else {
      throw HexColorError.missingHash
    }

    let hexPart = hex.dropFirst()
    guard hexPart.count == 6 || hexPart.count == 8 else {
      throw HexColorError.invalidLength
    }

    let hexColorRegex = "^[0-9a-fA-F]{6}$|^[0-9a-fA-F]{8}$"
    let hexColorPredicate = NSPredicate(format: "SELF MATCHES %@", hexColorRegex)
    if !hexColorPredicate.evaluate(with: String(hexPart)) {
      throw HexColorError.nonHexCharacter
    }
  }
}
