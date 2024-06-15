//  Created by Marvin Lee Kobert on 15.06.24.
//  
//

import XCTest
@testable import swiftvars

final class MapperTests: XCTestCase {
  func testToSwiftModel() throws {
    let model: VariablesModel = .stub
    let swiftModel = try Mapper.toSwiftModel(model)

    XCTAssertEqual(model.version, swiftModel.version)
  }
}
