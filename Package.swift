// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swiftvars",
  platforms: [.macOS("13.0")],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: .init(1, 4, 0)),
    .package(url: "https://github.com/JohnSundell/Files", from: .init(4, 2, 0)),
    .package(url: "https://github.com/pakLebah/ANSITerminal", from: .init(0, 0, 3)),
    .package(url: "https://github.com/stencilproject/Stencil.git", from: .init(0, 15, 1)),
    .package(url: "https://github.com/lukepistrol/SwiftLintPlugin.git", exact: .init(0, 53, 0)),
    .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.6"),
    .package(url: "https://github.com/mtynior/ColorizeSwift.git", from: "1.5.0")
  ],
  targets: [
    .executableTarget(
      name: "swiftvars",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "Files", package: "Files"),
        .product(name: "ANSITerminal", package: "ANSITerminal"),
        .product(name: "Stencil", package: "Stencil"),
        .product(name: "Yams", package: "Yams"),
        .product(name: "ColorizeSwift", package: "ColorizeSwift")
      ],
      plugins: [
        .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
      ]
    ),
    .testTarget(
      name: "swiftvarsTests",
      dependencies: ["swiftvars"]
    )
  ]
)
