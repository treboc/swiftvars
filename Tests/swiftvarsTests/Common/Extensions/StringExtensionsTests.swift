//  Created by Marvin Lee Kobert on 16.06.24.
//
//

import XCTest
@testable import swiftvars

final class StringExtensionsTests: XCTestCase {
  func test_toUpperCamelCasee() {
    let input = ["hello", "world"]
    let result = input.toUpperCamelCase()
    XCTAssertEqual(result, "HelloWorld")

    let input2 = ["swift", "rocks"]
    let result2 = input2.toUpperCamelCase()
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
