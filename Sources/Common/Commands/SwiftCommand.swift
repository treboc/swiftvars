//  Created by Marvin Lee Kobert on 16.06.24.
//
//

import ArgumentParser
import Files
import Foundation
import PathKit
import Stencil

struct SwiftCommand: ParsableCommand {
  @Option(help: "Path where the config file is located")
  var configPath: String?

  static let configuration = CommandConfiguration(commandName: "swift")

  func run() throws {
    Logger.info("Starting Swift command...")
    let config = ConfigLoader.loadConfig(atPath: unwrappedConfigPath)

    let mapper = Mapper(validator: Validator(), platform: .swift)
    let templateLoader = TemplateLoader()

    let variablesModel = try decodeVariablesFile(config.sourceDir)
    let swiftModel = try mapper.toSwiftModel(variablesModel)

    let renderedBaseFile = try renderBaseFile(loader: templateLoader, model: swiftModel)
    let renderedBaseFileDest = Path(components: [config.destinationDir, SwiftVarTemplate.swiftBaseFile.outputFileName])

    let renderedColorFile = try renderColorFile(loader: templateLoader, model: swiftModel)
    let renderedColorFileDest = Path(components: [config.destinationDir, SwiftVarTemplate.swiftColorsFile.outputFileName])

    let renderedColorValuesFile = try renderColorValuesFile(loader: templateLoader, model: swiftModel)
    let renderedColorValuesFileDest = Path(components: [config.destinationDir, SwiftVarTemplate.swiftColorValuesFile.outputFileName])

    let renderedRadiusFile = try renderRadiusFile(loader: templateLoader, model: swiftModel)
    let renderedRadiusFileDest = Path(components: [config.destinationDir, SwiftVarTemplate.swiftRadiusFile.outputFileName])

    let renderedSpacingsFile = try renderSpacingsFile(loader: templateLoader, model: swiftModel)
    let renderedSpacingsFileDest = Path(components: [config.destinationDir, SwiftVarTemplate.swiftSpacingFile.outputFileName])

    try renderedBaseFile.write(toFile: renderedBaseFileDest.string, atomically: true, encoding: .utf8)
    try renderedColorFile.write(toFile: renderedColorFileDest.string, atomically: true, encoding: .utf8)
    try renderedColorValuesFile.write(toFile: renderedColorValuesFileDest.string, atomically: true, encoding: .utf8)
    try renderedRadiusFile.write(toFile: renderedRadiusFileDest.string, atomically: true, encoding: .utf8)
    try renderedSpacingsFile.write(toFile: renderedSpacingsFileDest.string, atomically: true, encoding: .utf8)

    Logger.info("Done!")
  }
}

private extension SwiftCommand {
  var unwrappedConfigPath: Path {
    if let configPath {
      Path(configPath)
    } else {
      Path.current
    }
  }

  func decodeVariablesFile(_ sourceDir: String) throws -> VariablesModel {
    let path = Path(components: [sourceDir, Constants.variablesFileName])
    let file = try File(path: path.string)
    let data = try file.read()
    let decoder = JSONDecoder()
    let model = try decoder.decode(VariablesModel.self, from: data)
    return model
  }

  func renderBaseFile(loader: TemplateLoaderProtocol, model: SwiftModel) throws -> String {
    let context: [String: Any] = [
      "version": model.version
    ]

    return try loader.renderTemplate(.swiftBaseFile, context: context)
  }

  func renderColorFile(loader: TemplateLoaderProtocol, model: SwiftModel) throws -> String {
    let context: [String: Any] = [
      "version": model.version,
      "colors": model.colorTokens
    ]

    return try loader.renderTemplate(.swiftColorsFile, context: context)
  }

  func renderColorValuesFile(loader: TemplateLoaderProtocol, model: SwiftModel) throws -> String {
    let context: [String: Any] = [
      "version": model.version,
      "colors": model.colorValues
    ]

    return try loader.renderTemplate(.swiftColorValuesFile, context: context)
  }

  func renderRadiusFile(loader: TemplateLoaderProtocol, model: SwiftModel) throws -> String {
    let context: [String: Any] = [
      "version": model.version,
      "radii": model.radii
    ]

    return try loader.renderTemplate(.swiftRadiusFile, context: context)
  }

  func renderSpacingsFile(loader: TemplateLoaderProtocol, model: SwiftModel) throws -> String {
    let context: [String: Any] = [
      "version": model.version,
      "spacings": model.spacings
    ]

    return try loader.renderTemplate(.swiftSpacingFile, context: context)
  }
}
