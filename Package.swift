// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "Violet",
  platforms: [
    .macOS(.v10_11)
  ],
  products: [
    .library(name: "LibViolet", targets: ["Core", "Lexer"]),
    .executable(name: "Violet", targets: ["Main"]),
    .executable(name: "PyTests", targets: ["PyTests"]),

    .executable(name: "Elsa", targets: ["Elsa"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(name: "Core", dependencies: []),
    .testTarget(name: "CoreTests", dependencies: ["Core"]),

    .target(name: "Lexer", dependencies: ["Core"]),
    .testTarget(name: "LexerTests", dependencies: ["Core", "Lexer"]),

    .target(name: "Main", dependencies: ["Core", "Lexer"]),

    // Utilities
    .target(name: "Elsa"),
    .target(name: "PyTests", dependencies: ["Core", "Lexer"]),
  ]
)
