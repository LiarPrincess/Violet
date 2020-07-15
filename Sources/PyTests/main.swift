import Foundation
import VioletCore
import VioletObjects
import VioletVM

private let currentFile = URL(fileURLWithPath: #file)

let rootDir = currentFile
  .deletingLastPathComponent()
  .deletingLastPathComponent()
  .deletingLastPathComponent()

let testDir = rootDir.appendingPathComponent("PyTests")

// If we call 'open' we want to start at repository root.
guard FileManager.default.changeCurrentDirectoryPath(rootDir.path) else {
  trap("Failed to set cwd to: '\(rootDir.path)'")
}

// MARK: - Config

stopAtFirstFailedTest = true

// MARK: - Rust tests

try runAllTests(
  from: testDir.appendingPathComponent("RustPython"),
  skip: [
    "code.py", // We do not support all properties
    "extra_bool_eval.py" // Needs peephole optimizer
  ]
)

// MARK: - Violet tests

try runAllTests(from: testDir.appendingPathComponent("Violet"))

// MARK: - Summary

printSummary()
