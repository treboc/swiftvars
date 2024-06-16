import ArgumentParser
import Files
import Foundation
import PathKit
import Stencil

// TODO: - Add unit tests!
// TODO: - Info on empty fields!

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
