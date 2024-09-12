import PathKit
import Stencil
import Testing
@testable import swiftvars

struct TemplateTests {
  let sut = TemplateLoader()

  @Test(
    "theme files should be loaded without error",
    arguments: SwiftVarTemplate.allCases
  )
  func loadTemplate(template: SwiftVarTemplate) throws {
    let loadedTemplate = try sut.loadTemplate(template)
    #expect(loadedTemplate != nil)
  }
}
