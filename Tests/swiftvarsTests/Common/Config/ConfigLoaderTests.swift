//  Created by Marvin Lee Kobert on 16.06.24.
//
//

import XCTest
import Foundation
import Yams // Assuming you're using Yams for YAML parsing
import PathKit

@testable import swiftvars

class ConfigLoaderTests: XCTestCase {
  let validYAML = """
    sourceDir: "/src"
    destinationDir: "/dest"
    """

  let invalidYAML = """
    sourceDir:
    - /src
    destinationDir: - /dest
    """

  func createTempFile(withContent content: String) -> Path {
    let tempDir = Path(NSTemporaryDirectory())
    let filePath = tempDir + Constants.configFileName
    do {
      try filePath.write(content)
    } catch {
      XCTFail("Failed to create temp file: \(error)")
    }
    return filePath
  }

  func deleteTempFile(atPath path: Path) {
    do {
      try path.delete()
    } catch {
      XCTFail("Failed to delete temp file: \(error)")
    }
  }

  func test_loadConfig_validConfigFile() {
    let tempFilePath = createTempFile(withContent: validYAML)

    let config = ConfigLoader.loadConfig(atPath: tempFilePath.parent())
    XCTAssertEqual(config.sourceDir, "/src")
    XCTAssertEqual(config.destinationDir, "/dest")

    deleteTempFile(atPath: tempFilePath)
  }

  func test_ConfigLoaderError_fileNotFoundDescription() {
    let error: ConfigLoaderError = .fileNotFound
    XCTAssertEqual(error.description, "Config file not found, make sure it exists in your current directory, or in the specified path")
  }

  func test_ConfigLoaderError_invalidFileDescription() {
    let error: ConfigLoaderError = .invalidFile
    XCTAssertEqual(error.description, "Invalid config file, check format please.")
  }
}
