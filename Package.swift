// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "Violet",
  platforms: [
    .macOS(.v10_11)
  ],
  products: [
    .library(name: "VioletLib", targets: ["VioletLib"]),
    .executable(name: "Violet", targets: ["Violet"]),
    .executable(name: "VioletLibTestsPy", targets: ["VioletLibTestsPy"])
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "VioletLib",
      dependencies: [],
      path: "VioletLib"
    ),
    .target(
      name: "Violet",
      dependencies: ["VioletLib"],
      path: "Violet"
    ),
    .testTarget(
      name: "VioletLibTests",
      dependencies: ["VioletLib"],
      path: "VioletLibTests"
    ),
    .target(
      name: "VioletLibTestsPy",
      dependencies: ["VioletLib"],
      path: "VioletLibTestsPy"
    )
  ]
)
