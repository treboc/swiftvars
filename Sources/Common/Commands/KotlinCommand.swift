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

    guard let packageName = config.packageName else {
      Logger.fatal("Cannot find a package name in the config file.")
    }

    let mapper = Mapper(platform: .kotlin)
    let variablesModel = try decodeVariablesFile(atPath: config.sourceDir)
    let kotlinModel = try mapper.toKotlinModel(variablesModel)

    let renderedThemeFile = try renderThemeFile(model: kotlinModel, packageName: packageName)
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

  func renderThemeFile(model: KotlinModel, packageName: String) throws -> String {
    let context: [String: Any] = [
      "packageName": packageName,
      "version": model.version,
      "lightColorToken": model.colorTokens.filter({ $0.colorMode == .light }),
      "darkColorToken": model.colorTokens.filter({ $0.colorMode == .dark }),
      "rawColors": model.rawColors,
      "radii": model.radii,
      "spacings": model.spacings
    ]

    return try Template.renderTemplate(.kotlinThemeFile, context: context)
  }
}
