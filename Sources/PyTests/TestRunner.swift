import Foundation
import FileSystem
import VioletCore
import VioletObjects
import VioletVM

// swiftlint:disable function_body_length

struct TestRunner {

  struct Test {
    let name: String
    let path: Path
  }

  struct Result {
    let passedTests: [Test]
    let failedTests: [Test]
    let durationInSeconds: Double
  }

  private let defaultArguments: Arguments
  private let defaultEnvironment: Environment
  private let stopAtFirstFailedTest: Bool

  private var passedTests = [Test]()
  private var failedTests = [Test]()
  private var startTime: DispatchTime

  init(defaultArguments: Arguments,
       defaultEnvironment: Environment,
       stopAtFirstFailedTest: Bool) {

    assert(!defaultArguments.help)
    assert(!defaultArguments.version)
    assert(!defaultArguments.inspectInteractively)
    assert(defaultArguments.command == nil)
    assert(defaultArguments.module == nil)
    assert(defaultArguments.script == nil)

    self.defaultArguments = defaultArguments
    self.defaultEnvironment = defaultEnvironment
    self.stopAtFirstFailedTest = stopAtFirstFailedTest
    self.startTime = DispatchTime.now()
  }

  // MARK: - Run all tests

  mutating func runAllTests(from dir: Path, skipping: [String] = []) {
    var entries = fileSystem.readdirOrTrap(path: dir)
    entries.sort()

    for filename in entries {
      let path = fileSystem.join(path: dir, element: filename)
      let stat = fileSystem.statOrTrap(path: path)

      guard stat.type == .regularFile else {
        continue
      }

      guard filename.hasSuffix(".py") else {
        continue
      }

      if skipping.contains(filename) {
        continue
      }

      let dirName = fileSystem.basename(path: dir)
      let testName = "\(dirName) - \(filename)"
      self.runTest(name: testName, path: path)
    }
  }

  // MARK: - Run test

  /// This will leak memory on every call!
  /// (because we do not have GC to break circular references)
  mutating func runTest(name: String, path: Path) {
    print(name)
    let test = Test(name: name, path: path)

    var arguments = self.defaultArguments
    let environment = self.defaultEnvironment
    arguments.script = path.string

    let vm = VM(arguments: arguments, environment: environment)
    switch vm.run() {
    case .done:
      print("  ✔ Success")
      self.passedTests.append(test)
      return

    case .systemExit(let object):
      let status: String = {
        if PyCast.isNone(object) {
          return "None"
        }

        if let pyInt = PyCast.asInt(object) {
          return String(describing: pyInt.value)
        }

        return Py.reprOrGenericString(object: object)
      }()

      print("  ✔ Success (SystemExit: \(status))")
      self.passedTests.append(test)
      return

    case .error(let error):
      // Try to print error to original 'stdout'
      let stdout: PyTextFile
      switch Py.sys.get__stdout__() {
      case let .value(f): stdout = f
      case let .error(e): trap("'__stdout__' is missing: \(e)")
      }

      // 'printRecursive' ignores any new errors
      print("  ✖ Error:")
      Py.printRecursiveIgnoringErrors(error: error, file: stdout)
      self.failedTests.append(test)

      if self.stopAtFirstFailedTest {
        exit(1)
      }
    }
  }

  // MARK: - Results

  func getResult() -> Result {
    let now = DispatchTime.now()
    let diffNano = now.uptimeNanoseconds - self.startTime.uptimeNanoseconds
    let diffSeconds = Double(diffNano) / 1_000_000_000

    return Result(passedTests: self.passedTests,
                  failedTests: self.failedTests,
                  durationInSeconds: diffSeconds)
  }
}
