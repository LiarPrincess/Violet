import Foundation
import VioletCore
import VioletObjects
import VioletVM

internal var rootDir: URL = {
  let currentFile = URL(fileURLWithPath: #file)
  return currentFile
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()
}()

internal let testDir = rootDir.appendingPathComponent("PyTests")

// If we call 'open' we want to start at repository root.
guard FileManager.default.changeCurrentDirectoryPath(rootDir.path) else {
  trap("Failed to set cwd to: '\(rootDir.path)'")
}

//runOldTypes()
//runOldBuiltins()
runRustPythonTests()
//runVioletTests()
