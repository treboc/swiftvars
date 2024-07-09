//  Created by Marvin Lee Kobert on 16.06.24.
//
//

import XCTest
@testable import swiftvars

final class StringExtensionsTests: XCTestCase {
  func test_toColorTokenVarName() {
    var input = "primaryColor"
    let colorMode = ColorMode.light
    let result = input.toColorTokenVarName(colorMode: colorMode)
    XCTAssertEqual(result, "LightPrimaryColor")

    var input2 = "background/color"
    let result2 = input2.toColorTokenVarName(colorMode: colorMode)
    XCTAssertEqual(result2, "LightBackgroundColor")
  }

  func test_toColorTokenColorName() {
    var input = "color/primary-color"
    let result = input.toColorTokenColorName()
    XCTAssertEqual(result, "PrimaryColor")

    var input2 = "color/background-color"
    let result2 = input2.toColorTokenColorName()
    XCTAssertEqual(result2, "BackgroundColor")
  }

  func test_toRadiusVarName() {
    var input = "radius-small"
    let result = input.toSwiftRadiusVarName()
    XCTAssertEqual(result, "radiussmall")

    var input2 = "radius-large"
    let result2 = input2.toSwiftRadiusVarName()
    XCTAssertEqual(result2, "radiuslarge")
  }

  func test_toSpacingVarName() {
    var input = "spacing-small"
    let result = input.toSwiftSpacingVarName()
    XCTAssertEqual(result, "spacingsmall")

    var input2 = "spacing-large"
    let result2 = input2.toSwiftSpacingVarName()
    XCTAssertEqual(result2, "spacinglarge")
  }

  func test_toCamelCase() {
    let input = ["hello", "world"]
    let result = input.toCamelCase()
    XCTAssertEqual(result, "HelloWorld")

    let input2 = ["swift", "rocks"]
    let result2 = input2.toCamelCase()
    XCTAssertEqual(result2, "SwiftRocks")
  }

  func test_toLowerCamelCase() {
    let input = ["hello", "world"]
    let result = input.toLowerCamelCase()
    XCTAssertEqual(result, "helloWorld")

    let input2 = ["swift", "rocks"]
    let result2 = input2.toLowerCamelCase()
    XCTAssertEqual(result2, "swiftRocks")
  }
}
