//  Created by Marvin Lee Kobert on 15.06.24.
//
//

import PathKit
import Stencil

enum SwiftVarTemplate: String {
  case swiftBaseFile = "UITheme"
  case swiftColorsFile = "UITheme+Colors"
  case swiftRadiusFile = "UITheme+Radius"
  case swiftSpacingFile = "UITheme+Spacing"

  var fileNameWithExtension: String {
    rawValue + ".stencil"
  }
}

extension Template {
  static let environment = Environment(loader: FileSystemLoader(paths: [.templatesPath]), trimBehaviour: .smart)

  static func loadTemplate(_ template: SwiftVarTemplate) throws -> Template {
    return try environment.loadTemplate(name: template.fileNameWithExtension)
  }

  static func renderTemplate(_ template: SwiftVarTemplate, context: [String: Any] = [:]) throws -> String {
    let template = try loadTemplate(template)
    return try template.render(context)
  }
}
