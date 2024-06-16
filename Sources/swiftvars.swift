import ArgumentParser
import Files
import Foundation
import PathKit
import Stencil

// 1. Get Source and Destination path correctly
// 2. Decode to `VariablesModel`
// 3. Switch between `SwiftModel` and `KotlinModel`
// 4. Map to model
// 5. Create files with the help of stancil
// 6. Move created files to destination

// TODO: - Add Stancil templates!
// TODO: - Add unit tests!

@main
struct MainCLI: ParsableCommand {
  var sourcePath: String = "/Users/treboc/SWIFTVARS_TESTDIR/variables.json"

  @Argument(help: PlatformArgument.help)
  var platform: PlatformArgument

  func run() throws {
    print("Starting...")

    switch platform {
    case .swift:
      let variablesModel = try decodeVariablesFile(sourcePath)
      let swiftModel = try Mapper.toSwiftModel(variablesModel)

      let renderedBaseFile = try renderBaseFile(model: swiftModel)
      let renderedColorFile = try renderColorFile(model: swiftModel)
      let renderedColorValuesFile = try renderColorValuesFile(model: swiftModel)
      let renderedRadiusFile = try renderRadiusFile(model: swiftModel)
      let renderedSpacingsFile = try renderSpacingsFile(model: swiftModel)

      try renderedBaseFile.write(toFile: "/Users/treboc/SWIFTVARS_TESTDIR/UITheme.swift", atomically: true, encoding: .utf8)
      try renderedColorFile.write(toFile: "/Users/treboc/SWIFTVARS_TESTDIR/UITheme+Colors.swift", atomically: true, encoding: .utf8)
      try renderedColorValuesFile.write(toFile: "/Users/treboc/SWIFTVARS_TESTDIR/UITheme+ColorValues.swift", atomically: true, encoding: .utf8)
      try renderedRadiusFile.write(toFile: "/Users/treboc/SWIFTVARS_TESTDIR/UITheme+Radius.swift", atomically: true, encoding: .utf8)
      try renderedSpacingsFile.write(toFile: "/Users/treboc/SWIFTVARS_TESTDIR/UITheme+Spacings.swift", atomically: true, encoding: .utf8)

      print("Done!")
    case .kotlin:
      fatalError("Not implemented yet")
    }
  }

  func decodeVariablesFile(_ filepath: String) throws -> VariablesModel {
    let file = try File(path: filepath)
    let data = try file.read()
    let decoder = JSONDecoder()
    let model = try decoder.decode(VariablesModel.self, from: data)
    return model
  }

  func renderBaseFile(model: SwiftModel) throws -> String {
    let context: [String: Any] = [
      "version": model.version
    ]

    return try Template.renderTemplate(.swiftBaseFile, context: context)
  }

  func renderColorFile(model: SwiftModel) throws -> String {
    let context: [String: Any] = [
      "version": model.version,
      "colors": model.colorTokens
    ]

    return try Template.renderTemplate(.swiftColorsFile, context: context)
  }

  func renderColorValuesFile(model: SwiftModel) throws -> String {
    let context: [String: Any] = [
      "version": model.version,
      "colors": model.colorValues
    ]

    return try Template.renderTemplate(.swiftColorValuesFile, context: context)
  }

  func renderRadiusFile(model: SwiftModel) throws -> String {
    let context: [String: Any] = [
      "version": model.version,
      "radii": model.radii
    ]

    return try Template.renderTemplate(.swiftRadiusFile, context: context)
  }

  func renderSpacingsFile(model: SwiftModel) throws -> String {
    let context: [String: Any] = [
      "version": model.version,
      "spacings": model.spacings
    ]

    return try Template.renderTemplate(.swiftSpacingFile, context: context)
  }
}
