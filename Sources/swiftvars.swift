import ArgumentParser
import Files
import Foundation
import PathKit
import Stencil

@main
struct SwiftVARS: ParsableCommand {
  static let configuration = CommandConfiguration(
    abstract: "SwiftVARS",
    subcommands: [
      KotlinCommand.self,
      SwiftCommand.self
    ]
  )
}
