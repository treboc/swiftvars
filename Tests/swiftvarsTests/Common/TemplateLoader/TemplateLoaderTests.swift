import XCTest
import PathKit
import Stencil
@testable import swiftvars

class TemplateTests: XCTestCase {
  var environment: Environment!

  func test_loadTemplate_swiftPlatform() {
    let template = SwiftVarTemplate.swiftBaseFile
    do {
      let loadedTemplate = try Template.loadTemplate(template)
      XCTAssertNotNil(loadedTemplate)
    } catch {
      XCTFail("Failed to load template: \(error)")
    }
  }

  func test_loadTemplate_kotlinPlatform() {
    let template = SwiftVarTemplate.kotlinThemeFile
    do {
      let loadedTemplate = try Template.loadTemplate(template)
      XCTAssertNotNil(loadedTemplate)
    } catch {
      XCTFail("Failed to load template: \(error)")
    }
  }
}
