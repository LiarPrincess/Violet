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

    .executable(name: "Elsa", targets: ["Elsa"])
  ],
  dependencies: [
    // We will use 'TSCUtility.ArgumentParser' from this package.
    // Also, this is VERY old version of SPM, but it works, so whatever.
    .package(url: "https://github.com/apple/swift-package-manager", from: "0.4.0")
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

    .target(name: "Objects", dependencies: ["Core", "Bytecode"]),
    .testTarget(name: "ObjectsTests", dependencies: ["Objects"]),

    .target(name: "VM", dependencies: ["Compiler", "Objects", "SPMUtility"]),
    .testTarget(name: "VMTests", dependencies: ["VM"]),

    // Main executable
    .target(name: "Violet", dependencies: ["VM"]),

    // Elsa is our code generation tool.
    .target(name: "Elsa")
  ]
)
