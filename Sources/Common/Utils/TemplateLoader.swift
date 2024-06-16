//  Created by Marvin Lee Kobert on 15.06.24.
//
//

import PathKit
import Stencil

private let kFolderName = "swift"
private let kStencilFileExtension = ".stencil"

enum SwiftVarTemplate: String {
  case swiftBaseFile = "UITheme"
  case swiftColorsFile = "UITheme+Colors"
  case swiftColorValuesFile = "UITheme+ColorValues"
  case swiftRadiusFile = "UITheme+Radius"
  case swiftSpacingFile = "UITheme+Spacing"

  var fileNameWithExtension: String {
    rawValue + kStencilFileExtension
  }
}

extension Template {
  static let environment = Environment(loader: FileSystemLoader(paths: [.templatesPath]), trimBehaviour: .smart)

  static func loadTemplate(_ template: SwiftVarTemplate) throws -> Template {
    let path = Path(components: [kFolderName, template.fileNameWithExtension])
    return try environment.loadTemplate(name: path.string)
  }

  static func renderTemplate(_ template: SwiftVarTemplate, context: [String: Any] = [:]) throws -> String {
    let template = try loadTemplate(template)
    return try template.render(context)
  }
}
