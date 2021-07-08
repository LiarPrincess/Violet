let rootDir = FileSystem.getRepositoryRoot()
let testDir = FileSystem.join(path: rootDir, element: "PyTests")

// If we call 'open' we want to start at repository root.
FileSystem.setCurrentWorkingDirectoryOrTrap(path: rootDir)

stopAtFirstFailedTest = false

let rustTestDir = FileSystem.join(path: testDir, element: "RustPython")
runAllTests(
  from: rustTestDir,
  skip: [
    "code.py", // We do not support all properties
    "extra_bool_eval.py" // Needs peephole optimizer
  ]
)

// Violet tests
let violetTestDir = FileSystem.join(path: testDir, element: "Violet")
runAllTests(
  from: violetTestDir
)

printSummary()
