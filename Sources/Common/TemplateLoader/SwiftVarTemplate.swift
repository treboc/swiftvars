//  Created by Marvin Lee Kobert on 16.06.24.
//
//

import Foundation

private let kStencilFileExtension = ".stencil"
private let kKotlinFileExtension = ".kt"
private let kSwiftFileExtension = ".swift"

enum SwiftVarTemplate {
  case kotlinThemeFile
  case swiftBaseFile
  case swiftColorsFile
  case swiftColorValuesFile
  case swiftRadiusFile
  case swiftSpacingFile

  var templateFileName: String {
    filename + kStencilFileExtension
  }

  var outputFileName: String {
    switch self {
    case .kotlinThemeFile:
      filename + kKotlinFileExtension
    case .swiftBaseFile, .swiftColorValuesFile, .swiftColorsFile, .swiftRadiusFile, .swiftSpacingFile:
      filename + kSwiftFileExtension
    }
  }

  private var filename: String {
    switch self {
    case .kotlinThemeFile, .swiftBaseFile:
      "UITheme"
    case .swiftColorsFile:
      "UITheme+Colors"
    case .swiftColorValuesFile:
      "UITheme+ColorValues"
    case .swiftRadiusFile:
      "UITheme+Radius"
    case .swiftSpacingFile:
      "UITheme+Spacing"
    }
  }
}
