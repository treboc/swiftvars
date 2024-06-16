//  Created by Marvin Lee Kobert on 16.06.24.
//  
//

import XCTest
@testable import swiftvars

final class MapperMappingErrorTests: XCTestCase {
  func test_equality_invalidValue() {
    let error1 = MappingError.invalidValue(123)
    let error2 = MappingError.invalidValue(123)
    XCTAssertEqual(error1, error2)
  }

  func test_equality_invalidCollection() {
    let error1 = MappingError.invalidCollection("Collection1")
    let error2 = MappingError.invalidCollection("Collection1")
    XCTAssertEqual(error1, error2)
  }

  func test_equality_noColorName() {
    let error1 = MappingError.noColorName
    let error2 = MappingError.noColorName
    XCTAssertEqual(error1, error2)
  }

  func test_equality_noColorModeName() {
    let error1 = MappingError.noColorModeName("unexpected")
    let error2 = MappingError.noColorModeName("unexpected")
    XCTAssertEqual(error1, error2)
  }

  func test_equality_noRadiusValue() {
    let error1 = MappingError.noRadiusValue
    let error2 = MappingError.noRadiusValue
    XCTAssertEqual(error1, error2)
  }

  func test_equality_noSpacings() {
    let error1 = MappingError.noSpacings
    let error2 = MappingError.noSpacings
    XCTAssertEqual(error1, error2)
  }

  func test_inequality_differentCases() {
    let error1 = MappingError.noColorName
    let error2 = MappingError.noRadiusValue
    XCTAssertNotEqual(error1, error2)
  }

  func test_invalidValueDescription() {
    let error = MappingError.invalidValue(123)
    XCTAssertEqual(error.description, "Invalid value: 123")
  }

  func test_invalidCollectionDescription() {
    let error = MappingError.invalidCollection("nonPrimitiveCollection")
    XCTAssertEqual(error.description, "Invalid collection: nonPrimitiveCollection")
  }

  func test_noColorNameDescription() {
    let error = MappingError.noColorName
    XCTAssertEqual(error.description, "Unable to get colorName from value")
  }

  func test_noColorModeNameDescription() {
    let error = MappingError.noColorModeName("unexpected")
    XCTAssertEqual(error.description, "Unable to get colorModeName from value, found: unexpected, expected: light/dark")
  }

  func test_noRadiusValueDescription() {
    let error = MappingError.noRadiusValue
    XCTAssertEqual(error.description, "Unable to get radiusValue from value")
  }

  func test_noSpacingsDescription() {
    let error = MappingError.noSpacings
    XCTAssertEqual(error.description, "No spacings found")
  }
}
