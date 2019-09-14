// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "Violet",
  platforms: [
    .macOS(.v10_11)
  ],
  products: [
    .executable(name: "Violet", targets: ["Main"]),
    .library(name: "VioletFramework", targets: ["VM"]),

    .executable(name: "Elsa", targets: ["Elsa"])
  ],
  dependencies: [
  ],
  targets: [
    .target(name: "Core", dependencies: []),
    .testTarget(name: "CoreTests", dependencies: ["Core"]),

    .target(name: "Lexer", dependencies: ["Core"]),
    .testTarget(name: "LexerTests", dependencies: ["Core", "Lexer"]),

    .target(name: "Parser", dependencies: ["Lexer"]),
    .testTarget(name: "ParserTests", dependencies: ["Parser"]),

    .target(name: "Compiler", dependencies: ["Parser", "Bytecode"]),
    .testTarget(name: "CompilerTests", dependencies: ["Compiler"]),

    .target(name: "Bytecode", dependencies: ["Core"]),
    .testTarget(name: "BytecodeTests", dependencies: ["Bytecode"]),

    .target(name: "Objects", dependencies: ["Core"]),
    .testTarget(name: "ObjectsTests", dependencies: ["Objects"]),

    .target(name: "VM", dependencies: ["Compiler", "Objects"]),
    .testTarget(name: "VMTests", dependencies: ["VM"]),

    .target(name: "Main", dependencies: ["VM"]),

    // Elsa is our code generation tool.
    .target(name: "Elsa")
  ]
)
