// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "Violet",
  platforms: [
    .macOS(.v10_11)
  ],
  products: [
    .library(name: "LibViolet", targets: ["Core", "Lexer", "Parser", "Compiler", "Bytecode"]),
    .executable(name: "Violet", targets: ["Main"]),

    .executable(name: "Elsa", targets: ["Elsa"])
  ],
  dependencies: [
  ],
  targets: [
    .target(name: "Core", dependencies: []),
    .testTarget(name: "CoreTests", dependencies: ["Core"]),

    .target(name: "Lexer", dependencies: ["Core"]),
    .testTarget(name: "LexerTests", dependencies: ["Core", "Lexer"]),

    .target(name: "Parser", dependencies: ["Core", "Lexer"]),
    .testTarget(name: "ParserTests", dependencies: ["Core", "Lexer", "Parser"]),

    .target(name: "Compiler", dependencies: ["Core", "Parser", "Bytecode"]),
    .testTarget(name: "CompilerTests", dependencies: ["Core", "Parser", "Compiler"]),

    .target(name: "Bytecode", dependencies: ["Core"]),

    .target(name: "Main", dependencies: ["Core", "Lexer"]),

    // -- Tools --

    // Elsa is our code generation tool.
    .target(name: "Elsa")
  ]
)
