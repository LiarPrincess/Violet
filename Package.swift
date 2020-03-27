// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "Violet",
  platforms: [
    .macOS(.v10_11)
  ],
  products: [
    .executable(name: "Violet", targets: ["Violet"]),
    .library(name: "VioletFramework", targets: ["VM"]),

    .executable(name: "Elsa", targets: ["Elsa"]),
    .library(name: "Rapunzel", targets: ["Rapunzel"])
  ],
  dependencies: [
    // If it is possible we try to avoid adding new dependencies because… oh so many reasons!
    // Tbh. I’m still not sure if we can trust this ‘apple’ person…
    .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.0.1"))
  ],
  targets: [
    // Shared module that all of the other modules depend on.
    .target(name: "Core", dependencies: []),
    .testTarget(name: "CoreTests", dependencies: ["Core"]),

    // String -> Tokens
    .target(name: "Lexer", dependencies: ["Core"]),
    .testTarget(name: "LexerTests", dependencies: ["Lexer"]),

    // Tokens -> AST
    .target(name: "Parser", dependencies: ["Lexer", "Rapunzel"]),
    .testTarget(name: "ParserTests", dependencies: ["Parser"]),

    // AST -> Bytecode
    .target(name: "Compiler", dependencies: ["Parser", "Bytecode"]),
    .testTarget(name: "CompilerTests", dependencies: ["Compiler"]),

    // VM instructions
    .target(name: "Bytecode", dependencies: ["Core"]),
    .testTarget(name: "BytecodeTests", dependencies: ["Bytecode"]),

    // Python objects
    .target(name: "Objects", dependencies: ["Compiler", "ArgumentParser"]),
    .testTarget(name: "ObjectsTests", dependencies: ["Objects"]),

    // Python runtime + bytecode interpretation
    .target(name: "VM", dependencies: ["Objects"]),
    .testTarget(name: "VMTests", dependencies: ["VM"]),

    // Main executable
    .target(name: "Violet", dependencies: ["VM"]),

    // Code generation tool used for AST and bytecode
    .target(name: "Elsa"),

    // Pretty printer based on Philip Wadler idea:
    // https://homepages.inf.ed.ac.uk/wadler/papers/prettier/prettier.pdf
    .target(name: "Rapunzel", dependencies: []),
    .testTarget(name: "RapunzelTests", dependencies: ["Rapunzel"])
  ]
)
