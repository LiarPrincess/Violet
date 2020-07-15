import Foundation
import VioletCore
import VioletObjects
import VioletVM

// swiftlint:disable function_body_length

internal var stopAtFirstFailedTest = false

private var passedTests = [String]()
private var failedTests = [String]()

internal func runAllTests(from dir: URL, skip: [String] = []) throws {
  var filenames = try FileManager.default.contentsOfDirectory(atPath: dir.path)
  filenames.sort()

  for filename in filenames {
    guard filename.hasSuffix(".py") else {
      continue
    }

    if skip.contains(filename) {
      continue
    }

    let dirName = dir.lastPathComponent
    let testName = "\(dirName) - \(filename)"

    let file = dir.appendingPathComponent(filename)
    runTest(testName: testName, path: file)
  }
}

/// This will leak memory on every call!
/// (because we do not have GC to break circular references)
private func runTest(testName: String, path: URL) {
  print(testName)

  var arguments = Arguments()
  let environment = Environment()
  arguments.script = path.path

  let vm = VM(arguments: arguments, environment: environment)
  switch vm.run() {
  case .done:
    print("  ✔ Success")
    passedTests.append(testName)
    return

  case .systemExit(let object):
    let status: String = {
      switch object {
      case let o where o.isNone:
        return "None"
      case let int as PyInt:
        return String(describing: int.value)
      default:
        return Py.reprOrGeneric(object: object)
      }
    }()

    print("  ✔ Success (SystemExit: \(status))")
    passedTests.append(testName)
    return

  case .error(let error):
    // Try to print error to orginal 'stdout'
    let stdout: PyTextFile
    switch Py.sys.get__stdout__() {
    case let .value(f): stdout = f
    case let .error(e): trap("'__stdout__' is missing: \(e)")
    }

    // 'printRecursive' ignores any new errors
    print("  ✖ Error:")
    Py.printRecursive(error: error, file: stdout)
    failedTests.append(testName)

    if stopAtFirstFailedTest {
      exit(1)
    }
  }
}

/// In case we need to run all of the tests, so see 'what sticks'.
///
/// Just remember to comment the 'exit' on 'error' case in 'runTest' switch.
internal func printSummary() {
  func printSummary(title: String, tests: [String]) {
    print(title)
    if tests.isEmpty {
      print("  (empty)")
    } else {
      for test in tests {
        print("  \(test)")
      }
    }
  }

  // Did we even run any test?
  guard passedTests.any || failedTests.any else {
    return
  }

  printSummary(title: "Passed tests:", tests: passedTests)
  printSummary(title: "Failed tests:", tests: failedTests)
}
