//  Created by Marvin Lee Kobert on 15.06.24.
//
//

import PathKit
import Stencil

extension Template {
  static let environment = Environment(loader: FileSystemLoader(paths: [.templatesPath]), trimBehaviour: .smart)

  static func loadTemplate(_ template: SwiftVarTemplate, platform: Platform) throws -> Template {
    let path = Path(components: [platform.folderName, template.templateFileName])
    return try environment.loadTemplate(name: path.string)
  }

  static func renderTemplate(_ template: SwiftVarTemplate, platform: Platform, context: [String: Any] = [:]) throws -> String {
    let template = try loadTemplate(template, platform: platform)
    return try template.render(context)
  }
}
