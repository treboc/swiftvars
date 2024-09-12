//  Created by Marvin Lee Kobert on 15.06.24.
//
//

import PathKit
import Stencil

private class StringTemplateLoader: Loader {
  func loadTemplate(name: String, environment: Environment) throws -> Template {
    guard let swiftVarTemplate = SwiftVarTemplate(rawValue: name) else {
      throw TemplateDoesNotExist(templateNames: [name], loader: self)
    }

    return Template(templateString: swiftVarTemplate.templateString)
  }
}

protocol TemplateLoaderProtocol {
  func loadTemplate(_ template: SwiftVarTemplate) throws -> Template
  func renderTemplate(_ template: SwiftVarTemplate, context: [String: Any]) throws -> String
}

final class TemplateLoader: TemplateLoaderProtocol {
  let environment: Environment

  init(loader: Loader = StringTemplateLoader()) {
    self.environment = Environment(loader: loader)
  }

  func loadTemplate(_ template: SwiftVarTemplate) throws -> Template {
    try self.environment.loadTemplate(name: template.rawValue)
  }

  func renderTemplate(_ template: SwiftVarTemplate, context: [String: Any]) throws -> String {
    let template = try loadTemplate(template)
    return try template.render(context)
  }
}
