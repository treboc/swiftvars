//  Created by Marvin Lee Kobert on 16.06.24.
//
//

import Files
import PathKit
import Yams

private extension Constants {
  static let configFileName = ".swiftvars.yml"
}

enum ConfigLoaderError: Error {
  case fileNotFound
  case invalidFile

  var description: String {
    switch self {
    case .fileNotFound:
      "Config file not found, make sure it exists in your current directory, or in the specified path"
    case .invalidFile:
      "Invalid config file, check format please."
    }
  }
}

struct Config: Codable {
  let sourceDir: String
  let destinationDir: String
}

enum ConfigLoader {
  static func loadConfig(atPath path: Path) throws -> Config {
    let configPath = path + Constants.configFileName
    let configFile: File

    do {
      configFile = try File(path: configPath.string)
    } catch {
      throw ConfigLoaderError.fileNotFound
    }

    do {
      let configData = try configFile.read()
      let decoder = YAMLDecoder()
      return try decoder.decode(from: configData)
    } catch {
      throw ConfigLoaderError.invalidFile
    }
  }
}
