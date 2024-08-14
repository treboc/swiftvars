//  Created by Marvin Lee Kobert on 15.06.24.
//
//

import PathKit
import Stencil

private class SwiftSpacingFileStringLoader: Loader {
  func loadTemplate(name: String, environment: Environment) throws -> Template {
    guard let swiftVarTemplate = SwiftVarTemplate(rawValue: name) else {
      throw TemplateDoesNotExist(templateNames: [name], loader: self)
    }

    return Template(templateString: swiftVarTemplate.templateString)
  }
}

extension Template {
  static var environment = Environment(loader: SwiftSpacingFileStringLoader())

  static func loadTemplate(_ template: SwiftVarTemplate) throws -> Template {
    try environment.loadTemplate(name: template.rawValue)
  }

  static func renderTemplate(_ template: SwiftVarTemplate, context: [String: Any] = [:]) throws -> String {
    let template = try loadTemplate(template)
    return try template.render(context)
  }
}
