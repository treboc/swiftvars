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

// TODO: - Add unit tests!
// TODO: - Info on empty fields!

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
      let variablesModel = try decodeVariablesFile(sourcePath)
      let kotlinModel = try Mapper.toKotlinModel(variablesModel)

      let renderedThemeFile = try renderThemeFile(model: kotlinModel)
      try renderedThemeFile.write(toFile: "/Users/treboc/SWIFTVARS_TESTDIR/UITheme.kt", atomically: true, encoding: .utf8)
    }
  }

  func decodeVariablesFile(_ filepath: String) throws -> VariablesModel {
    let file = try File(path: filepath)
    let data = try file.read()
    let decoder = JSONDecoder()
    let model = try decoder.decode(VariablesModel.self, from: data)
    return model
  }

  // Kotlin

  func renderThemeFile(model: KotlinModel) throws -> String {
    let context: [String: Any] = [
      "packageName": "de.enercity.app.android.ui.theme",
      "version": model.version,
      "colors": model.colorValues,
      "radii": model.radii,
      "spacings": model.spacings
    ]

    return try Template.renderTemplate(.kotlinThemeFile, platform: .kotlin, context: context)
  }

  // Swift

  func renderBaseFile(model: SwiftModel) throws -> String {
    let context: [String: Any] = [
      "version": model.version
    ]

    return try Template.renderTemplate(.swiftBaseFile, platform: .swift, context: context)
  }

  func renderColorFile(model: SwiftModel) throws -> String {
    let context: [String: Any] = [
      "version": model.version,
      "colors": model.colorTokens
    ]

    return try Template.renderTemplate(.swiftColorsFile, platform: .swift, context: context)
  }

  func renderColorValuesFile(model: SwiftModel) throws -> String {
    let context: [String: Any] = [
      "version": model.version,
      "colors": model.colorValues
    ]

    return try Template.renderTemplate(.swiftColorValuesFile, platform: .swift, context: context)
  }

  func renderRadiusFile(model: SwiftModel) throws -> String {
    let context: [String: Any] = [
      "version": model.version,
      "radii": model.radii
    ]

    return try Template.renderTemplate(.swiftRadiusFile, platform: .swift, context: context)
  }

  func renderSpacingsFile(model: SwiftModel) throws -> String {
    let context: [String: Any] = [
      "version": model.version,
      "spacings": model.spacings
    ]

    return try Template.renderTemplate(.swiftSpacingFile, platform: .swift, context: context)
  }
}
