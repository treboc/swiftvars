//  Created by Marvin Lee Kobert on 16.06.24.
//
//

import Testing
@testable import swiftvars

struct StringExtensionsTest {
  @Test(
    "toUpperCamelCase should return correct result",
    arguments: [
      (["hello", "world"], "HelloWorld"),
      (["swift", "rocks"], "SwiftRocks")
    ]
  )
  func toUpperCamelCase(input: [String], output: String) {
    #expect(input.toUpperCamelCase() == output)
  }

  @Test(
    "toLowerCamelCase should return correct result",
    arguments: [
      (["hello", "world"], "helloWorld"),
      (["swift", "rocks"], "swiftRocks")
    ]
  )
  func toLowerCamelCase(input: [String], output: String) {
    #expect(input.toLowerCamelCase() == output)
  }
}
