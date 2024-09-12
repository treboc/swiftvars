//  Created by Marvin Lee Kobert on 16.06.24.
//
//

import Foundation
import PathKit
import Testing
import Yams
@testable import swiftvars

struct ConfigLoaderTests {
  let validYAML = """
    sourceDir: "/src"
    destinationDir: "/dest"
    """

  let invalidYAML = """
    sourceDir:
    - /src
    destinationDir: - /dest
    """

  @Test
  func loadConfigWithValidYAML() {
    let tempFilePath = createTempFile(withContent: validYAML)

    let config = ConfigLoader.loadConfig(atPath: tempFilePath.parent())
    #expect(config.sourceDir == "/src")
    #expect(config.destinationDir == "/dest")

    deleteTempFile(atPath: tempFilePath)
  }

  @Test(
    "`ConfigLoaderError` should return correct error description",
    arguments: [
      (ConfigLoaderError.fileNotFound, "Config file not found, make sure it exists in your current directory, or in the specified path"),
      (ConfigLoaderError.invalidFile, "Invalid config file, check format please.")
    ]
  )
  func configLoaderErrorDescription(error: ConfigLoaderError, description: String) {
    #expect(error.description == description)
  }
}

// MARK: - Helper
extension ConfigLoaderTests {
  func createTempFile(withContent content: String) -> Path {
    let tempDir = Path(NSTemporaryDirectory())
    let filePath = tempDir + Constants.configFileName
    do {
      try filePath.write(content)
    } catch {
      Issue.record("Failed to create temp file: \(error)")
    }
    return filePath
  }

  func deleteTempFile(atPath path: Path) {
    do {
      try path.delete()
    } catch {
      Issue.record("Failed to delete temp file: \(error)")
    }
  }
}
