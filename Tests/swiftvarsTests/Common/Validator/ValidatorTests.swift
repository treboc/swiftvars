//  Created by Marvin Lee Kobert on 15.06.24.
//
//

@testable import swiftvars
import XCTest

final class ValidatorTests: XCTestCase {
  func testValidHexColors() throws {
    let validHexColors = [
      "#FFFFFF",
      "#000000",
      "#123456",
      "#abcdef",
      "#ABCDEF",
      "#FFFFFFFF",
      "#12345678",
      "#abcdef12",
      "#ABCDEF34",
    ]

    XCTAssertNoThrow(try validateHexColors(validHexColors))
  }

  func test_validateHexColor_invalidLength() {
    let invalidLengthHexColors = [
      "#123",
      "#1234",
      "#12345",
      "#1234567",
      "#12345678",
      "#123456789",
    ]

    XCTAssertThrowsError(try validateHexColors(invalidLengthHexColors)) { error in
      XCTAssertEqual(error as? HexColorError, .invalidLength)
    }
  }

  func test_validateHexColor_invalidLength_errorDescription() {
    let hexColor = "#123456789"
    XCTAssertThrowsError(try validateHexColors([hexColor])) { error in
      XCTAssertEqual((error as? HexColorError)?.description, "Hex color must be either 7 or 9 characters long (including the '#').")
    }
  }

  func test_validateHexColor_missingHash() {
    let missingHashHexColors = [
      "FFFFFF",
    ]

    XCTAssertThrowsError(try validateHexColors(missingHashHexColors)) { error in
      XCTAssertEqual(error as? HexColorError, .missingHash)
    }
  }

  func test_validateHexColor_missingHash_errorDescription() {
    let hexColor = "FFFFFF"
    XCTAssertThrowsError(try validateHexColors([hexColor])) { error in
      XCTAssertEqual((error as? HexColorError)?.description, "Hex color must start with a '#'.")
    }
  }

  func test_validateHexColor_nonHexCharacter() {
    let nonHexCharacterHexColors = [
      "#GGGGGG",
      "#12345G",
      "#123456789",
      "#1234",
      "#12345",
      "#FFFFFFFZ",
      "# ABCDE",
    ]

    XCTAssertThrowsError(try validateHexColors(nonHexCharacterHexColors)) { error in
      XCTAssertEqual(error as? HexColorError, .nonHexCharacter)
    }
  }

  func test_validateHexColor_nonHexCharacter_errorDescription() {
    let hexColor = "#GGGGGG"
    XCTAssertThrowsError(try validateHexColors([hexColor])) { error in
      XCTAssertEqual((error as? HexColorError)?.description, "Hex color contains non-hexadecimal characters.")
    }
  }

  func test_validateHexColor_emptyString() throws {
    XCTAssertThrowsError(try Validator.validateHexColor("")) { error in
      XCTAssertEqual(error as? HexColorError, .emptyString)
    }
  }

  func test_validateHexColor_emptyString_errorDescription() throws {
    XCTAssertThrowsError(try Validator.validateHexColor("")) { error in
      XCTAssertEqual((error as? HexColorError)?.description, "Hex color cannot be an empty string.")
    }
  }
}

private extension ValidatorTests {
  func validateHexColors(_ hexColors: [String]) throws {
    try hexColors.forEach {
      try Validator.validateHexColor($0)
    }
  }
}
