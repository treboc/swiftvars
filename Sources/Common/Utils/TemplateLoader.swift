//  Created by Marvin Lee Kobert on 15.06.24.
//
//

import PathKit
import Stencil

enum SwiftVarTemplate {
  case kotlinThemeFile
  case swiftBaseFile
  case swiftColorsFile
  case swiftColorValuesFile
  case swiftRadiusFile
  case swiftSpacingFile

  var fileNameWithExtension: String {
    let fileName = switch self {
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

    return fileName + Self.kStencilFileExtension
  }

  static let kStencilFileExtension = ".stencil"
}

extension Template {
  static let environment = Environment(loader: FileSystemLoader(paths: [.templatesPath]), trimBehaviour: .smart)

  static func loadTemplate(_ template: SwiftVarTemplate, platform: Platform) throws -> Template {
    let path = Path(components: [platform.folderName, template.fileNameWithExtension])
    return try environment.loadTemplate(name: path.string)
  }

  static func renderTemplate(_ template: SwiftVarTemplate, platform: Platform, context: [String: Any] = [:]) throws -> String {
    let template = try loadTemplate(template, platform: platform)
    return try template.render(context)
  }
}
