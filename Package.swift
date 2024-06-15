// swift-tools-version: 5.10
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
    .package(url: "https://github.com/realm/SwiftLint.git", from: .init(0, 55, 1))
  ],
  targets: [
    .executableTarget(
      name: "swiftvars",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "Files", package: "Files"),
        .product(name: "ANSITerminal", package: "ANSITerminal"),
        .product(name: "Stencil", package: "Stencil")
      ],
      resources: [
        .copy("templates")
      ],
      plugins: [
        .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
      ]
    ),
    .testTarget(
      name: "swiftvarsTests",
      dependencies: ["swiftvars"]
    )
  ]
)
