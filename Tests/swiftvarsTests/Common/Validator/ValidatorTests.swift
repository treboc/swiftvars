//  Created by Marvin Lee Kobert on 15.06.24.
//
//

import Testing
@testable import swiftvars

struct ValidatorTests {
  let sut = Validator()

  static let validHexValues = ["#FFFFFF", "#000000", "#123456", "#abcdef", "#ABCDEF", "#FFFFFFFF", "#12345678", "#abcdef12", "#ABCDEF34"]
  static let invalidLengthHexValues = ["#123", "#1234", "#12345", "#1234567", "#123456789"]
  static let missingHashHexValues = ["FFFFFF", "000000", "123456", "abcdef", "ABCDEF", "FFFFFFFF", "12345678", "abcdef12", "ABCDEF34"]
  static let nonHexCharacterHexValues = ["#ZXCZXC"]

  @Test("valid hex colors should not throw any error", arguments: validHexValues)
  func validHexColors(hexColor: String) {
    #expect(throws: Never.self) {
       try sut.validateHexColor(hexColor)
    }
  }

  @Test("invalid length hex colors should throw an error", arguments: invalidLengthHexValues)
  func invalidLengthHexColors(hexColor: String) {
    #expect(throws: HexColorError.invalidLength) {
       try sut.validateHexColor(hexColor)
    }
  }

  @Test("invalid length hex color should throw correct error description", arguments: invalidLengthHexValues)
  func invalidLengthHexColorErrorDescription(hexColor: String) {
    do {
      try sut.validateHexColor(hexColor)
    } catch let error as HexColorError {
      #expect(error.description == "Hex color must be either 7 or 9 characters long (including the '#').")
    } catch {
      Issue.record(error)
    }
  }

  @Test("missing hash should thow `missingHash`", arguments: missingHashHexValues)
  func missingHashError(hexColor: String) {
    #expect(throws: HexColorError.missingHash) {
       try sut.validateHexColor(hexColor)
    }
  }

  @Test("missing hash should throw correct error description", arguments: missingHashHexValues)
  func missingHashErrorDescription(hexColor: String) {
    do {
      try sut.validateHexColor(hexColor)
    } catch let error as HexColorError {
      #expect(error.description ==  "Hex color must start with a '#'.")
    } catch {
      Issue.record(error)
    }
  }

  @Test("non hex character should throw `nonHexCharacter`", arguments: nonHexCharacterHexValues)
  func nonHexCharacterError(hexColor: String) {
    #expect(throws: HexColorError.nonHexCharacter) {
       try sut.validateHexColor(hexColor)
    }
  }

  @Test("non hex character should throw correct error description", arguments: nonHexCharacterHexValues)
  func nonHexCharacterErrorDescription(hexColor: String) {
    do {
      try sut.validateHexColor(hexColor)
    } catch let error as HexColorError {
      #expect(error.description == "Hex color contains non-hexadecimal characters.")
    } catch {
      Issue.record(error)
    }
  }

  @Test("empty string should throw `emptyString`")
  func emptyStringError() {
    #expect(throws: HexColorError.emptyString) {
       try sut.validateHexColor("")
    }
  }

  @Test("empty string should throw correct error description")
  func emptyStringErrorDescription() {
    do {
      try sut.validateHexColor("")
    } catch let error as HexColorError {
      #expect(error.description == "Hex color cannot be an empty string.")
    } catch {
      Issue.record(error)
    }
  }
}
