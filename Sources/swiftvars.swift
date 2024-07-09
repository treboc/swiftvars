import ArgumentParser
import Files
import Foundation
import PathKit
import Stencil

@main
struct SwiftVARS: ParsableCommand {
  static let configuration = CommandConfiguration(
    abstract: "SwiftVARS",
    version: "1.0.0",
    subcommands: [
      KotlinCommand.self,
      SwiftCommand.self
    ]
  )
}
