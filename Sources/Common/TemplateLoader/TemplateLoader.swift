//  Created by Marvin Lee Kobert on 15.06.24.
//
//

import PathKit
import Stencil

class StringLoader: Loader {
  func loadTemplate(name: String, environment: Environment) throws -> Template {
    if name == SwiftVarTemplate.kotlinThemeFile.templateFileName {
      return Template(templateString: SwiftVarTemplate.kotlinThemeFile.templateString)
    }

    throw TemplateDoesNotExist(templateNames: [name], loader: self)
  }
}

extension Template {
  static var environment = Environment(loader: StringLoader())

  static func loadTemplate(_ template: SwiftVarTemplate, platform: Platform) throws -> Template {
    environment.trimBehaviour = .all
    return try environment.loadTemplate(name: template.templateFileName)
  }

  static func renderTemplate(_ template: SwiftVarTemplate, platform: Platform, context: [String: Any] = [:]) throws -> String {
    let template = try loadTemplate(template, platform: platform)
    return try template.render(context)
  }
}
