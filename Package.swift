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
    // We will use 'TSCUtility.ArgumentParser' from this package.
    // Also: this is VERY old version of SPM, but it works, so whatever.
    .package(url: "https://github.com/apple/swift-package-manager", from: "0.4.0")
  ],
  targets: [
    // Shared module that all of the other modules depend on.
    .target(name: "Core", dependencies: []),
    .testTarget(name: "CoreTests", dependencies: ["Core"]),

    // String -> Tokens
    .target(name: "Lexer", dependencies: ["Core"]),
    .testTarget(name: "LexerTests", dependencies: ["Core", "Lexer"]),

    // Tokens -> AST
    .target(name: "Parser", dependencies: ["Lexer"]),
    .testTarget(name: "ParserTests", dependencies: ["Parser", "Rapunzel"]),

    // AST -> Bytecode
    .target(name: "Compiler", dependencies: ["Parser", "Bytecode"]),
    .testTarget(name: "CompilerTests", dependencies: ["Compiler"]),

    // VM instructions
    .target(name: "Bytecode", dependencies: ["Core"]),
    .testTarget(name: "BytecodeTests", dependencies: ["Bytecode"]),

    // Python objects
    .target(name: "Objects", dependencies: ["Bytecode"]),
    .testTarget(name: "ObjectsTests", dependencies: ["Objects"]),

    // Python runtime + bytecode interpretation
    .target(name: "VM", dependencies: ["Compiler", "Objects", "SPMUtility"]),
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
