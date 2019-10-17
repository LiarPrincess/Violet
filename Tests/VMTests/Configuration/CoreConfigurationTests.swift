import Foundation
import XCTest
import Compiler
@testable import VM

// swiftlint:disable file_length
// swiftlint:disable force_unwrapping

private class FakeDeps: CoreConfigurationDeps {

  fileprivate var bundleURL = URL(string: "/")!
  fileprivate var executablePath: String?

  fileprivate var files = [String]()

  fileprivate func fileExists(atPath path: String) -> Bool {
    return false
  }
}

class CoreConfigurationTests: XCTestCase {

  // MARK: - Program name

  func test_programName() {
    var args = Arguments()
    let env = Environment(from: [:])
    let deps = FakeDeps()

    args.raw = ["Violet"]
    let conf = CoreConfiguration(arguments: args, environment: env, dependencies: deps)

    XCTAssertEqual(conf.programName, "Violet")
  }

  // MARK: - Executable

  func test_executable_withBundle() {
    let args = Arguments()
    let env = Environment(from: [:])
    let deps = FakeDeps()

    deps.executablePath = "The-Little-Mermaid/Ariel"
    let conf = CoreConfiguration(arguments: args, environment: env, dependencies: deps)

    XCTAssertEqual(conf.executable, "The-Little-Mermaid/Ariel")
  }

  func test_executable_withoutBundle() {
    var args = Arguments()
    let env = Environment(from: [:])
    let deps = FakeDeps()

    args.raw = ["./The-Little-Mermaid/Ariel"]
    let conf = CoreConfiguration(arguments: args, environment: env, dependencies: deps)

    XCTAssertEqual(conf.executable, "./The-Little-Mermaid/Ariel")
  }

  // MARK: - Module search path

  func test_moduleSearchPaths() {
    var args = Arguments()
    var env = Environment(from: [:])
    let deps = FakeDeps()

    args.ignoreEnvironment = false
    env.violetPath = ["Ariel"]
    env.pythonPath = ["Eric"]
    deps.bundleURL = URL(string: "The/Little/Mermaid")!
    let conf = CoreConfiguration(arguments: args, environment: env, dependencies: deps)

    XCTAssertEqual(conf.moduleSearchPathsEnv, ["Ariel", "Eric"])
    XCTAssertEqual(conf.moduleSearchPaths, [
      "Ariel",
      "Eric",
      "The/Little/Mermaid",
      "The/Little",
      "The"
    ])
  }

  func test_moduleSearchPaths_ignoreEnv() {
    var args = Arguments()
    var env = Environment(from: [:])
    let deps = FakeDeps()

    args.ignoreEnvironment = true
    env.violetPath = ["Ariel"]
    env.pythonPath = ["Eric"]
    deps.bundleURL = URL(string: "The/Little/Mermaid")!
    let conf = CoreConfiguration(arguments: args, environment: env, dependencies: deps)

    XCTAssertEqual(conf.moduleSearchPathsEnv, [])
    XCTAssertEqual(conf.moduleSearchPaths, [
      "The/Little/Mermaid",
      "The/Little",
      "The"
    ])
  }

  // MARK: - Warnings

  func test_warnings() {
    var args = Arguments()
    var env = Environment(from: [:])
    let deps = FakeDeps()

    args.ignoreEnvironment = false
    args.warnings = [.always, .default, .error]
    env.pythonWarnings = [.ignore, .module, .once]
    let conf = CoreConfiguration(arguments: args, environment: env, dependencies: deps)

    XCTAssertEqual(conf.warnings, [
      .ignore, .module, .once, .always, .default, .error
    ])
  }

  func test_warnings_ignoreEnv() {
    var args = Arguments()
    var env = Environment(from: [:])
    let deps = FakeDeps()

    args.ignoreEnvironment = true
    args.warnings = [.always, .default, .error]
    env.pythonWarnings = [.ignore, .module, .once]
    let conf = CoreConfiguration(arguments: args, environment: env, dependencies: deps)

    XCTAssertEqual(conf.warnings, [
      .always, .default, .error
    ])
  }

  func test_bytesWarning() {
    let presets: [BytesWarningOption] = [.ignore, .warning, .error]

    for value in presets {
      var args = Arguments()
      let env = Environment(from: [:])
      let deps = FakeDeps()

      args.bytesWarning = value
      let conf = CoreConfiguration(arguments: args, environment: env, dependencies: deps)

      XCTAssertEqual(conf.bytesWarning, value)
    }
  }

  // MARK: - Optimizations

  func test_optimizations_arg_setToNone_alwaysUsesEnv() {
    let presets: [OptimizationLevel] = [.none, .O, .OO]

    for value in presets {
      var args = Arguments()
      var env = Environment(from: [:])
      let deps = FakeDeps()

      args.ignoreEnvironment = false
      args.optimization = .none
      env.pythonOptimize = value
      let conf = CoreConfiguration(arguments: args, environment: env, dependencies: deps)

      XCTAssertEqual(conf.optimization, value)
    }
  }

  func test_optimizations_arg_setToO_withEnv_setToNone_orO_isAlwaysOO() {
    let presets: [OptimizationLevel] = [.none, .O]

    for value in presets {
      var args = Arguments()
      var env = Environment(from: [:])
      let deps = FakeDeps()

      args.ignoreEnvironment = false
      args.optimization = .O
      env.pythonOptimize = value
      let conf = CoreConfiguration(arguments: args, environment: env, dependencies: deps)

      XCTAssertEqual(conf.optimization, .O)
    }
  }

  func test_optimizations_arg_setToO_withEnv_setToOO_isOO() {
    var args = Arguments()
    var env = Environment(from: [:])
    let deps = FakeDeps()

    args.ignoreEnvironment = false
    args.optimization = .O
    env.pythonOptimize = .OO
    let conf = CoreConfiguration(arguments: args, environment: env, dependencies: deps)

    XCTAssertEqual(conf.optimization, .OO)
  }

  func test_optimizations_arg_setToOO_isAlwaysOO() {
    let presets: [OptimizationLevel] = [.none, .O, .OO]

    for value in presets {
      var args = Arguments()
      var env = Environment(from: [:])
      let deps = FakeDeps()

      args.ignoreEnvironment = false
      args.optimization = .OO
      env.pythonOptimize = value
      let conf = CoreConfiguration(arguments: args, environment: env, dependencies: deps)

      XCTAssertEqual(conf.optimization, .OO)
    }
  }

  func test_optimizations_ignoreEnv() {
    let presets: [OptimizationLevel] = [.none, .O, .OO]

    for value in presets {
      var args = Arguments()
      let env = Environment(from: [:])
      let deps = FakeDeps()

      args.ignoreEnvironment = true
      args.optimization = value
      let conf = CoreConfiguration(arguments: args, environment: env, dependencies: deps)

      XCTAssertEqual(conf.optimization, value)
    }
  }

  // MARK: - Flags

  func test_inspectInteractively() {
    var args = Arguments()
    let env = Environment(from: [:])
    let deps = FakeDeps()

    args.inspectInteractively = true
    let conf = CoreConfiguration(arguments: args, environment: env, dependencies: deps)

    XCTAssertEqual(conf.inspectInteractively, true)
  }

  func test_ignoreEnvironment() {
    var args = Arguments()
    let env = Environment(from: [:])
    let deps = FakeDeps()

    args.ignoreEnvironment = true
    let conf = CoreConfiguration(arguments: args, environment: env, dependencies: deps)

    XCTAssertEqual(conf.ignoreEnvironment, true)
  }

  func test_isolated() {
    var args = Arguments()
    let env = Environment(from: [:])
    let deps = FakeDeps()

    args.isolated = true
    let conf = CoreConfiguration(arguments: args, environment: env, dependencies: deps)

    XCTAssertEqual(conf.isolated, true)
  }

  func test_noSite() {
    var args = Arguments()
    let env = Environment(from: [:])
    let deps = FakeDeps()

    args.noSite = true
    let conf = CoreConfiguration(arguments: args, environment: env, dependencies: deps)

    XCTAssertEqual(conf.noSite, true)
  }

  func test_noUserSite() {
    var args = Arguments()
    let env = Environment(from: [:])
    let deps = FakeDeps()

    args.noUserSite = true
    let conf = CoreConfiguration(arguments: args, environment: env, dependencies: deps)

    XCTAssertEqual(conf.noUserSite, true)
  }

  // MARK: - Helpers

  private func createDefaultConfiguration() -> CoreConfiguration {
    let args = Arguments()
    let env = Environment(from: [:])
    let deps = FakeDeps()
    return CoreConfiguration(arguments: args, environment: env, dependencies: deps)
  }

  private func assertEqual(_ lhs: CoreConfiguration,
                           _ rhs: CoreConfiguration,
                           file:  StaticString = #file,
                           line:  UInt         = #line) {
    XCTAssertEqual(lhs.programName, rhs.programName, "programName", file: file, line: line)
    XCTAssertEqual(lhs.executable, rhs.executable, "executable", file: file, line: line)
    XCTAssertEqual(lhs.warnings, rhs.warnings, "warningOptions", file: file, line: line)
    XCTAssertEqual(lhs.bytesWarning, rhs.bytesWarning, "bytesWarning", file: file, line: line)
    XCTAssertEqual(lhs.debug, rhs.debug, "debug", file: file, line: line)
    XCTAssertEqual(lhs.quiet, rhs.quiet, "quiet", file: file, line: line)
    XCTAssertEqual(lhs.isolated, rhs.isolated, "isolated", file: file, line: line)
    XCTAssertEqual(lhs.noSite, rhs.noSite, "noSite", file: file, line: line)
    XCTAssertEqual(lhs.noUserSite, rhs.noUserSite, "noUserSite", file: file, line: line)

    XCTAssertEqual(lhs.moduleSearchPaths,
                   rhs.moduleSearchPaths,
                   "moduleSearchPaths",
                   file: file,
                   line: line)
    XCTAssertEqual(lhs.moduleSearchPathsEnv,
                   rhs.moduleSearchPathsEnv,
                   "moduleSearchPathEnv",
                   file: file,
                   line: line)
    XCTAssertEqual(lhs.inspectInteractively,
                   rhs.inspectInteractively,
                   "inspectInteractively",
                   file: file,
                   line: line)
    XCTAssertEqual(lhs.ignoreEnvironment,
                   rhs.ignoreEnvironment,
                   "ignoreEnvironment",
                   file: file,
                   line: line)
  }
}
