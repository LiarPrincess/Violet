// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "Violet",
  platforms: [
    .macOS(.v10_11)
  ],
  products: [
    // Main executable
    .executable(name: "Violet", targets: ["Violet"]),
    // Executable for running tests written in Python (from 'PyTest' directory)
    .executable(name: "PyTests", targets: ["PyTests"]),
    // Violet as a library
    .library(name: "VioletFramework", targets: ["VioletVM"]),

    // Code generation tool used for AST and bytecode
    .executable(name: "Elsa", targets: ["Elsa"]),
    // Pretty printer based on Philip Wadler idea:
    // https://homepages.inf.ed.ac.uk/wadler/papers/prettier/prettier.pdf
    .library(name: "Rapunzel", targets: ["Rapunzel"])
  ],
  dependencies: [
    // If it is possible we try to avoid adding new dependencies because… oh so many reasons!
    // Tbh. I’m still not sure if we can trust this ‘apple’ person…
    .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.0.1"))
  ],
  targets: [

    // IMPORTANT:
    // Module names have 'Violet' prefix, but directories do not!
    // Sooo... we wrote the whole VM without this prefix and now we can't add it
    // because that would mess merges (and git history).
    // Let's just pretend that everything goes according to keikaku
    // (translators note: keikaku means plan).

    // Shared module that all of the other modules depend on.
    .target(name: "VioletCore", dependencies: [], path: "Sources/Core"),
    .testTarget(name: "VioletCoreTests", dependencies: ["VioletCore"], path: "Tests/CoreTests"),

    // Apparently we have our own implementation of unlimited integers…
    // Ehh…
    .target(name: "BigInt", dependencies: ["VioletCore"]),
    .testTarget(name: "BigIntTests", dependencies: ["BigInt"]),

    // String -> Tokens
    .target(name: "VioletLexer", dependencies: ["VioletCore", "BigInt"], path: "Sources/Lexer"),
    .testTarget(name: "VioletLexerTests", dependencies: ["VioletLexer"], path: "Tests/LexerTests"),

    // Tokens -> AST
    .target(name: "VioletParser", dependencies: ["VioletLexer", "Rapunzel"], path: "Sources/Parser"),
    .testTarget(name: "VioletParserTests", dependencies: ["VioletParser"], path: "Tests/ParserTests"),

    // AST -> Bytecode
    .target(name: "VioletCompiler", dependencies: ["VioletParser", "VioletBytecode"], path: "Sources/Compiler"),
    .testTarget(name: "VioletCompilerTests", dependencies: ["VioletCompiler"], path: "Tests/CompilerTests"),

    // VM instructions
    .target(name: "VioletBytecode", dependencies: ["VioletCore", "BigInt"], path: "Sources/Bytecode"),
    .testTarget(name: "VioletBytecodeTests", dependencies: ["VioletBytecode"], path: "Tests/BytecodeTests"),

    // Python objects
    .target(name: "VioletObjects", dependencies: ["VioletCompiler", "ArgumentParser"], path: "Sources/Objects"),
    .testTarget(name: "VioletObjectsTests", dependencies: ["VioletObjects"], path: "Tests/ObjectsTests"),

    // Python runtime + bytecode interpretation
    .target(name: "VioletVM", dependencies: ["VioletObjects"], path: "Sources/VM"),
    .testTarget(name: "VioletVMTests", dependencies: ["VioletVM"], path: "Tests/VMTests"),

    // Main executable
    .target(name: "Violet", dependencies: ["VioletVM"]),

    // Target for running tests written in Python (from 'PyTest' directory)
    .target(name: "PyTests", dependencies: ["VioletVM"]),

    // Code generation tool used for AST and bytecode
    .target(name: "Elsa"),

    // Pretty printer based on Philip Wadler idea:
    // https://homepages.inf.ed.ac.uk/wadler/papers/prettier/prettier.pdf
    .target(name: "Rapunzel", dependencies: []),
    .testTarget(name: "RapunzelTests", dependencies: ["Rapunzel"])
  ]
)
