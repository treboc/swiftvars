//  Created by Marvin Lee Kobert on 15.06.24.
//  
//

import XCTest
@testable import swiftvars

final class MapperTests: XCTestCase {
  func test_toColorToken_withStringValue() {
    let variable = Variable(name: "primaryColor", value: .stringValue("red"))
    let colorMode = ColorMode.light

    do {
      let colorToken = try Mapper.toColorToken(variable, colorMode: colorMode)
      XCTAssertEqual(colorToken.varName, "LightPrimaryColor")
      XCTAssertEqual(colorToken.colorName, "Red")
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }

  func test_toColorToken_withValuePrimitivesCollection() {
    let value = Variable.ValueObject(collection: .primitives, name: "blue")
    let variable = Variable(name: "SecondaryColor", value: .objectValue(value))
    let colorMode = ColorMode.dark

    do {
      let colorToken = try Mapper.toColorToken(variable, colorMode: colorMode)
      XCTAssertEqual(colorToken.varName, "DarkSecondaryColor")
      XCTAssertEqual(colorToken.colorName, "Blue")
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }

  func test_toColorToken_withIntegerValue() {
    let variable = Variable(name: "invalidColor", value: .numberValue(123))
    let colorMode = ColorMode.light

    XCTAssertThrowsError(try Mapper.toColorToken(variable, colorMode: colorMode)) { error in
      XCTAssertEqual(error as? MappingError, MappingError.invalidValue(Variable.Value.numberValue(123)))
    }
  }

  func test_toColorToken_withValueNonPrimitivesCollection() {
    let value = Variable.ValueObject(collection: .colorToken, name: "blue")
    let variable = Variable(name: "secondaryColor", value: .objectValue(value))
    let colorMode = ColorMode.dark

    XCTAssertThrowsError(try Mapper.toColorToken(variable, colorMode: colorMode)) { error in
      XCTAssertEqual(error as? MappingError, MappingError.invalidCollection(value.collection))
    }
  }

  func test_toColorToken_withEmptyString() {
    let variable = Variable(name: "emptyColor", value: .stringValue(""))
    let colorMode = ColorMode.light

    XCTAssertThrowsError(try Mapper.toColorToken(variable, colorMode: colorMode)) { error in
      XCTAssertEqual(error as? MappingError, .noColorName)
    }
  }
}
