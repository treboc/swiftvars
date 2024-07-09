//  Created by Marvin Lee Kobert on 15.06.24.
//  
//

import XCTest
@testable import swiftvars

final class MapperTests: XCTestCase {
  func test_toColorToken_withStringValue() {
    let variable = Variable(name: "primaryColor", value: .string("red"))
    let colorMode = ColorMode.light

    do {
      let colorToken = try Mapper.toColorToken(variable, colorMode: colorMode)
      XCTAssertEqual(colorToken.varName, "lightPrimaryColor")
      XCTAssertEqual(colorToken.colorName, "red")
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }

  func test_toColorToken_withValuePrimitivesCollection() {
    let value = Variable.ColorTokenValue(collection: .primitives, name: "blue")
    let variable = Variable(name: "SecondaryColor", value: .colorTokenValue(value))
    let colorMode = ColorMode.dark

    do {
      let colorToken = try Mapper.toColorToken(variable, colorMode: colorMode)
      XCTAssertEqual(colorToken.varName, "darkSecondaryColor")
      XCTAssertEqual(colorToken.colorName, "blue")
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }

  func test_toColorToken_withIntegerValue() {
    let variable = Variable(name: "invalidColor", value: .integer(123))
    let colorMode = ColorMode.light

    XCTAssertThrowsError(try Mapper.toColorToken(variable, colorMode: colorMode)) { error in
      XCTAssertEqual(error as? MappingError, MappingError.invalidValue(123))
    }
  }

  func test_toColorToken_withValueNonPrimitivesCollection() {
    let value = Variable.ColorTokenValue(collection: .colorToken, name: "blue")
    let variable = Variable(name: "secondaryColor", value: .colorTokenValue(value))
    let colorMode = ColorMode.dark

    XCTAssertThrowsError(try Mapper.toColorToken(variable, colorMode: colorMode)) { error in
      XCTAssertEqual(error as? MappingError, MappingError.invalidCollection(Variable.CollectionEnum.colorToken))
    }
  }

  func test_toColorToken_withEmptyString() {
    let variable = Variable(name: "emptyColor", value: .string(""))
    let colorMode = ColorMode.light

    XCTAssertThrowsError(try Mapper.toColorToken(variable, colorMode: colorMode)) { error in
      XCTAssertEqual(error as? MappingError, .noColorName)
    }
  }
}
