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
    .library(name: "LibViolet", targets: ["VioletVM"]),

    // Code generation tool used for AST and bytecode
    .executable(name: "Elsa", targets: ["Elsa"]),
    // Pretty printer based on Philip Wadler idea:
    // https://homepages.inf.ed.ac.uk/wadler/papers/prettier/prettier.pdf
    .library(name: "Rapunzel", targets: ["Rapunzel"]),
    // Tool to dump module interface (all of the 'public' and 'open' declarations)
    .executable(name: "Ariel", targets: ["Ariel"])
  ],
  dependencies: [
    // We try to avoid adding new dependencies because… oh so many reasons!
    // Tbh. I’m still not sure if we can trust this ‘apple’ person…
    .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.4.0")),
    // 0.50300.0 -> swift-5.3-RELEASE	-> Xcode 12.0
    .package(url: "https://github.com/apple/swift-syntax.git", .exact("0.50300.0"))
  ],
  targets: [

    // IMPORTANT:
    // Module names have 'Violet' prefix, but directories do not
    // (for example: 'VioletParser' module is inside 'Sources/Parser' directory)!

    // Shared module that all of the other modules depend on.
    .target(name: "VioletCore", dependencies: [], path: "Sources/Core"),
    .testTarget(name: "VioletCoreTests", dependencies: ["VioletCore"], path: "Tests/CoreTests"),

    // Apparently we have our own implementation of unlimited integers…
    // Ehh…
    .target(name: "BigInt", dependencies: ["VioletCore"]),
    .testTarget(name: "BigIntTests", dependencies: ["BigInt"]),

    // We also bundle our own Unicode database, because why not…
    // Ehh… Ehh…
    //
    // But don't worry, it is basically a 1:1 copy of following things from CPython:
    // - Objects/unicodectype.c
    // - Tools/unicode/makeunicodedata.py - generation script (we have it inside '/Scripts/unicode' dir)
    //
    // Btw. name comes from similar module in Python.
    .target(name: "UnicodeData", dependencies: []),
    .testTarget(name: "UnicodeDataTests", dependencies: ["UnicodeData"]),

    // Helper module for working with file system (duh…).
    //
    // Please note that this module was written 'on by-need basis'
    // and may not conform to the quality standards of other Violet modules.
    .target(name: "FileSystem", dependencies: ["VioletCore"]),
    .testTarget(name: "FileSystemTests", dependencies: ["FileSystem"]),

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

    // Python objects (+ part of runtime)
    .target(name: "VioletObjects", dependencies: ["VioletCompiler", "ArgumentParser", "UnicodeData", "FileSystem"], path: "Sources/Objects"),
    .testTarget(name: "VioletObjectsTests", dependencies: ["VioletObjects"], path: "Tests/ObjectsTests"),

    // Bytecode interpretation (+ remaining part of the Python runtime)
    .target(name: "VioletVM", dependencies: ["VioletObjects"], path: "Sources/VM"),
    .testTarget(name: "VioletVMTests", dependencies: ["VioletVM"], path: "Tests/VMTests"),

    // Main executable
    .target(name: "Violet", dependencies: ["VioletVM"]),

    // Target for running tests written in Python (from 'PyTest' directory)
    .target(name: "PyTests", dependencies: ["VioletVM", "FileSystem"]),

    // Code generation tool used for AST and bytecode
    .target(name: "Elsa"),

    // Pretty printer based on Philip Wadler idea:
    // https://homepages.inf.ed.ac.uk/wadler/papers/prettier/prettier.pdf
    .target(name: "Rapunzel", dependencies: []),
    .testTarget(name: "RapunzelTests", dependencies: ["Rapunzel"]),

    // Tool to dump module interface (all of the 'public' and 'open' declarations).
    // We need a separate 'LibAriel' to be able to write unit tests.
    .target(name: "LibAriel", dependencies: ["SwiftSyntax", "ArgumentParser", "FileSystem"]),
    .target(name: "Ariel", dependencies: ["LibAriel"]),
    .testTarget(name: "ArielTests", dependencies: ["LibAriel"])
  ]
)
