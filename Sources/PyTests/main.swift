import Foundation
import FileSystem
import VioletCore
import VioletObjects

// swiftlint:disable let_var_whitespace

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
runner.runAllTests(
  from: rustTestDir,
  skipping: [
    "code.py", // We do not support all properties
    "extra_bool_eval.py" // Requires peephole optimizer
  ]
)

// ====================
// === Violet tests ===
// ====================

let violetTestDir = fileSystem.join(path: testDir, element: "Violet")
runner.runAllTests(
  from: violetTestDir,
  skipping: [
    // cspell:disable-next Verre
    "Carlo_Verre_hack.py" // User can modify a builtin type if they try hard enough
  ]
)

// ==============
// === Result ===
// ==============

print("=== Summary ===")
let result = runner.getResult()

if result.failedTests.any {
  // swiftlint:disable:next force_unwrapping
  let emoji = ["😬", "🤒", "😵", "😕", "😟", "☹️", "😭", "😞", "😓"].randomElement()!
  print("\(emoji) Failed tests:")

  for test in result.failedTests {
    print("  \(test.name) (\(test.path))")
  }

  if result.passedTests.isEmpty {
    print("🦄 Ooo… Ooo?")
  }
} else {
  // swiftlint:disable:next force_unwrapping
  let emoji = ["😄", "😁", "😉", "😘", "🥰", "😍", "😇", "😋", "🥳"].randomElement()!
  print("\(emoji) All tests passed")
}

let durationInSeconds = String(format: "%.2f", result.durationInSeconds)
print("⏱️ Running time: \(durationInSeconds)s")

let returnValue: Int32 = result.failedTests.isEmpty ? 0 : 1
exit(returnValue)
