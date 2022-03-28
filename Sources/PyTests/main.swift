import Foundation
import FileSystem
import VioletCore
import VioletObjects

// swiftlint:disable force_unwrapping
// swiftlint:disable let_var_whitespace
// cspell:disable Verre

let fileSystem = FileSystem.default

let rootDir = fileSystem.getRepositoryRootOrTrap()
let testDir = fileSystem.join(path: rootDir, element: "PyTests")

// If we call 'open' we want to start at repository root.
fileSystem.setCurrentWorkingDirectoryOrTrap(path: rootDir)

let arguments = Arguments()
let environment = Environment()

var runner = TestRunner(
  defaultArguments: arguments,
  defaultEnvironment: environment,
  stopAtFirstFailedTest: false
)

// ========================
// === RustPython tests ===
// ========================

let rustTestDir = fileSystem.join(path: testDir, element: "RustPython")
runner.runTests(
  from: rustTestDir,
  only: [], // Use this if you want to execute only a single test.
  skip: [
    "code.py" // We do not support all properties
  ]
)

// ====================
// === Violet tests ===
// ====================

let violetTestDir = fileSystem.join(path: testDir, element: "Violet")
runner.runTests(
  from: violetTestDir,
  only: [],
  skip: [
    "Carlo_Verre_hack.py" // User can modify a builtin type if they try hard enough
  ]
)

// ==============
// === Result ===
// ==============

print("=== Summary ===")
let result = runner.getResult()

if result.failedTests.any {
  let emoji = ["😬", "🤒", "😵", "😕", "😟", "☹️", "😭", "😞", "😓"].randomElement()!
  print("\(emoji) Failed tests:")

  for test in result.failedTests {
    print("  \(test.name) (\(test.path))")
  }

  if result.passedTests.isEmpty {
    print("🦄 Ooo… Ooo?")
  }
} else {
  let emoji = ["😄", "😁", "😉", "😘", "🥰", "😍", "😇", "😋", "🥳"].randomElement()!
  print("\(emoji) All tests passed")
}

let durationInSeconds = String(format: "%.2f", result.durationInSeconds)
print("⏱️ Running time: \(durationInSeconds)s")

let returnValue: Int32 = result.failedTests.isEmpty ? EXIT_SUCCESS : EXIT_FAILURE
exit(returnValue)
