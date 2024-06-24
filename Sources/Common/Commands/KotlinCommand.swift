//  Created by Marvin Lee Kobert on 16.06.24.
//
//

import ArgumentParser
import Files
import Foundation
import PathKit
import Stencil

struct KotlinCommand: ParsableCommand {
  static let configuration = CommandConfiguration(commandName: "kotlin")

  @Option(help: "Path where the config file is located")
  var configPath: String?

  func run() throws {
    // Load Config
    let config = ConfigLoader.loadConfig(atPath: unwrappedConfigPath)

    // Decode Variables File
    let variablesModel = try decodeVariablesFile(atPath: config.sourceDir)
    let kotlinModel = try Mapper.toKotlinModel(variablesModel)

    let renderedThemeFile = try renderThemeFile(model: kotlinModel)
    let renderedThemeFileDest = Path(components: [config.destinationDir, SwiftVarTemplate.kotlinThemeFile.outputFileName])
    try renderedThemeFile.write(toFile: renderedThemeFileDest.string, atomically: true, encoding: .utf8)

    print("Done!")
  }
}

private extension KotlinCommand {
  var unwrappedConfigPath: Path {
    if let configPath {
      Path(configPath)
    } else {
      Path.current
    }
  }

  func decodeVariablesFile(atPath path: String) throws -> VariablesModel {
    let filepath = Path(components: [path, Constants.variablesFileName]).string
    let file = try File(path: filepath)
    let data = try file.read()
    let decoder = JSONDecoder()
    let model = try decoder.decode(VariablesModel.self, from: data)
    return model
  }

  func renderThemeFile(model: KotlinModel) throws -> String {
    let context: [String: Any] = [
      // TODO: Add package name as option
      "packageName": "INSERT PACKAGE NAME HERE!",
      "version": model.version,
      "colors": model.colorValues,
      "radii": model.radii,
      "spacings": model.spacings
    ]

    return try Template.renderTemplate(.kotlinThemeFile, platform: .kotlin, context: context)
  }
}
