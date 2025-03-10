//  Created by Marvin Lee Kobert on 16.06.24.
//  
//

import Foundation

enum Platform: String {
  case swift
  case kotlin

  var folderName: String {
    rawValue
  }

  var defaultCaseStyle: CaseStyle {
    switch self {
    case .swift:
      return .lowerCamelCase
    case .kotlin:
      return .upperCamelCase
    }
  }
}
