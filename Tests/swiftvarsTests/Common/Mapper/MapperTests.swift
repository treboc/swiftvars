//  Created by Marvin Lee Kobert on 15.06.24.
//  
//

import XCTest
@testable import swiftvars

final class MapperTests: XCTestCase {
  func test_toColorToken_withStringValue() {
    // When
    let sut = makeSUT(platform: .kotlin)
    let variable = Variable(name: "primaryColor", value: .stringValue("red"))
    let colorMode = ColorMode.light

    do {
      // Given
      let colorToken = try sut.toColorToken(variable, colorMode: colorMode)

      // Then
      XCTAssertEqual(colorToken.varName, "PrimaryColor")
      XCTAssertEqual(colorToken.colorName, "Red")
      XCTAssertEqual(colorToken.colorMode, colorMode)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }

  func test_toColorToken_withValuePrimitivesCollection() {
    // When
    let sut = makeSUT(platform: .kotlin)
    let value = Variable.ValueObject(collection: .primitives, name: "blue")
    let variable = Variable(name: "SecondaryColor", value: .objectValue(value))
    let colorMode = ColorMode.dark

    do {
      // Given
      let colorToken = try sut.toColorToken(variable, colorMode: colorMode)

      // Then
      XCTAssertEqual(colorToken.varName, "SecondaryColor")
      XCTAssertEqual(colorToken.colorName, "Blue")
      XCTAssertEqual(colorToken.colorMode, colorMode)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }

  func test_toColorToken_withIntegerValue() {
    // When
    let sut = makeSUT(platform: .kotlin)
    let variable = Variable(name: "invalidColor", value: .numberValue(123))
    let colorMode = ColorMode.light

    XCTAssertThrowsError(try sut.toColorToken(variable, colorMode: colorMode)) { error in
      XCTAssertEqual(error as? MappingError, MappingError.invalidValue(Variable.Value.numberValue(123)))
    }
  }

  func test_toColorToken_withValueNonPrimitivesCollection() {
    // WHen
    let sut = makeSUT(platform: .kotlin)
    let value = Variable.ValueObject(collection: .colorToken, name: "blue")
    let variable = Variable(name: "secondaryColor", value: .objectValue(value))
    let colorMode = ColorMode.dark

    // Given
    XCTAssertThrowsError(try sut.toColorToken(variable, colorMode: colorMode)) { error in
      // Then
      XCTAssertEqual(error as? MappingError, MappingError.invalidCollection(value.collection))
    }
  }

  func test_toColorToken_withEmptyString() {
    // When
    let sut = makeSUT(platform: .kotlin)
    let variable = Variable(name: "emptyColor", value: .stringValue(""))
    let colorMode = ColorMode.light

    // Given
    XCTAssertThrowsError(try sut.toColorToken(variable, colorMode: colorMode)) { error in
      // Then
      XCTAssertEqual(error as? MappingError, .noColorName)
    }
  }

  func test_colorTokenVariableName_isUpperCamelCaseInKotlin() {
    // When
    let sut = makeSUT(platform: .kotlin)
    let input = "button/secondary+text/button-background-secondary-disabled"

    // Given
    let result = sut.colorTokenVariableName(from: input)

    // Then
    XCTAssertEqual(result, "ButtonBackgroundSecondaryDisabled")
  }

  func test_colorTokenColorName_isLowerCamelCaseInSwift() {
    // When
    let sut = makeSUT(platform: .swift)
    let input = "button/secondary+text/button-background-secondary-disabled"

    // Given
    let result = sut.colorTokenVariableName(from: input)

    // Then
    XCTAssertEqual(result, "buttonBackgroundSecondaryDisabled")
  }

  func test_colorTokenColorName_isUpperCamelCaseInKotlin() {
    // When
    let sut = makeSUT(platform: .kotlin)
    let input = "color/brand-primary/purple/050"

    // Given
    let result = sut.colorTokenColorName(from: input)

    // Then
    XCTAssertEqual(result, "ColorBrandPrimaryPurple050")
  }

  func test_colorTokenColorName_isLoweCamelCaseInSwift() {
    // When
    let sut = makeSUT(platform: .swift)
    let input = "color/brand-primary/purple/050"

    // Given
    let result = sut.colorTokenColorName(from: input)

    // Then
    XCTAssertEqual(result, "colorBrandPrimaryPurple050")
  }

  func test_radiusVariableName_isUpperCamelCaseInKotlin() {
    // When
    let sut = makeSUT(platform: .kotlin)
    let input = "radius-32"

    // Given
    let result = sut.radiusVariableName(from: input)

    // Then
    XCTAssertEqual(result, "Radius32")
  }

  func test_radiusVariableName_isLowerCamelCaseInSwift() {
    // When
    let sut = makeSUT(platform: .swift)
    let input = "radius-32"

    // Given
    let result = sut.radiusVariableName(from: input)

    // Then
    XCTAssertEqual(result, "radius32")
  }

  func test_spacingVariableName_isUpperCamelCaseInKotlin() {
    // When
    let sut = makeSUT(platform: .kotlin)
    let input = "spacing-32"

    // Given
    let result = sut.spacingVariableName(from: input)

    // Then
    XCTAssertEqual(result, "Spacing32")
  }

  func test_spacingVariableName_isLowerCamelCaseInSwift() {
    // When
    let sut = makeSUT(platform: .swift)
    let input = "spacing-32"

    // Given
    let result = sut.spacingVariableName(from: input)

    // Then
    XCTAssertEqual(result, "spacing32")
  }
}

extension MapperTests {
  func makeSUT(platform: Platform) -> MapperProtocol {
    Mapper(platform: platform)
  }
}
