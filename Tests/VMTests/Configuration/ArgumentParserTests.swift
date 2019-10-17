import Foundation
import XCTest
import Compiler
@testable import VM

// swiftlint:disable file_length

class ArgumentParserTests: XCTestCase {

  private let programName = "Violet"

  // MARK: - Version, debug, quiet, interactive

  func test_version() {
    for cmd in ["-v", "--version"] {
      if let parsed = self.parse(cmd) {
        var expected = Arguments()
        expected.printVersion = true
        assertEqual(parsed, expected)
      }
    }
  }

  func test_debug() {
    if let parsed = self.parse("-d") {
      var expected = Arguments()
      expected.debug = true
      assertEqual(parsed, expected)
    }
  }

  func test_quiet() {
    if let parsed = self.parse("-q") {
      var expected = Arguments()
      expected.quiet = true
      assertEqual(parsed, expected)
    }
  }

  func test_inspect() {
    if let parsed = self.parse("-i") {
      var expected = Arguments()
      expected.inspectInteractively = true
      assertEqual(parsed, expected)
    }
  }

  // MARK: - Isolate

  func test_ignoreEnvironment() {
    if let parsed = self.parse("-E") {
      var expected = Arguments()
      expected.ignoreEnvironment = true
      assertEqual(parsed, expected)
    }
  }

  func test_isolate() {
    if let parsed = self.parse("-I") {
      var expected = Arguments()
      expected.isolated = true
      expected.ignoreEnvironment = true
      expected.noUserSite = true
      assertEqual(parsed, expected)
    }
  }

  func test_noSite() {
    if let parsed = self.parse("-S") {
      var expected = Arguments()
      expected.noSite = true
      assertEqual(parsed, expected)
    }
  }

  func test_noUserSite() {
    if let parsed = self.parse("-s") {
      var expected = Arguments()
      expected.noUserSite = true
      assertEqual(parsed, expected)
    }
  }

  // MARK: - Byte compare

  func test_bytes() {
    let values: [String: BytesWarningOption] = [
      "-b": .warning,
      "-bb": .error
    ]

    for (cmd, compare) in values {
      if let parsed = self.parse(cmd) {
        var expected = Arguments()
        expected.bytesWarning = compare
        assertEqual(parsed, expected)
      }
    }
  }

  func test_bytes_warning_doesNotOverrideError() {
    if let parsed = self.parse("-bb -b") {
      var expected = Arguments()
      expected.bytesWarning = .error
      assertEqual(parsed, expected)
    }
  }

  // MARK: - Optimization levels

  func test_optimization() {
    let values: [String: OptimizationLevel] = [
      "-O": .O,
      "-OO": .OO
    ]

    for (cmd, optimization) in values {
      if let parsed = self.parse(cmd) {
        var expected = Arguments()
        expected.optimization = optimization
        assertEqual(parsed, expected)
      }
    }
  }

  func test_optimization_O_doesNotOverrideOO() {
    if let parsed = self.parse("-OO -O") {
      var expected = Arguments()
      expected.optimization = .OO
      assertEqual(parsed, expected)
    }
  }

  // MARK: - Warnings

  func test_warnings() {
    let values: [String: WarningOption] = [
      "-Wdefault": .default,
      "-Werror": .error,
      "-Walways": .always,
      "-Wmodule": .module,
      "-Wonce": .once,
      "-Wignore": .ignore
    ]

    for (cmd, warning) in values {
      if let parsed = self.parse(cmd) {
        var expected = Arguments()
        expected.warnings = [warning]
        assertEqual(parsed, expected)
      }
    }
  }

  func test_warnings_multiple() {
    let cmd = "-Wdefault -Werror -Walways -Wmodule -Wonce -Wignore"
    let warnings: [WarningOption] = [
      .default, .error, .always, .module, .once, .ignore
    ]

    if let parsed = self.parse(cmd) {
      var expected = Arguments()
      expected.warnings = warnings
      assertEqual(parsed, expected)
    }
  }

  // MARK: - Flag ordering

  func test_flagsOrder_doesNotMatter() {
    let flags = ["-v", "-d", "-q", "-b", "-O"]
    let values = [
      flags.joined(separator: " "),
      flags.reversed().joined(separator: " ")
    ]

    for cmd in values {
      if let parsed = self.parse(cmd) {
        var expected = Arguments()
        expected.printVersion = true
        expected.debug = true
        expected.quiet = true
        expected.bytesWarning = .warning
        expected.optimization = .O
        assertEqual(parsed, expected)
      }
    }
  }

  // MARK: - Command, module, script, interactive

  func test_command() {
    let fn = "rapunzel()"
    let cmd = "-c \(fn)"

    if let parsed = self.parse(cmd) {
      var expected = Arguments()
      expected.command = fn + "\n"
      assertEqual(parsed, expected)
    }
  }

  func test_command_withFlags() {
    let fn = "rapunzel()"
    let cmd = "-v -d -q -b -O -c \(fn)"

    if let parsed = self.parse(cmd) {
      var expected = Arguments()
      expected.printVersion = true
      expected.debug = true
      expected.quiet = true
      expected.bytesWarning = .warning
      expected.optimization = .O
      expected.command = fn + "\n"
      assertEqual(parsed, expected)
    }
  }

  func test_module() {
    let file = "tangled.py"
    let cmd = "-m \(file)"

    if let parsed = self.parse(cmd) {
      var expected = Arguments()
      expected.module = file
      assertEqual(parsed, expected)
    }
  }

  func test_module_withFlags() {
    let file = "tangled.py"
    let cmd = "-v -d -q -b -O -m \(file)"

    if let parsed = self.parse(cmd) {
      var expected = Arguments()
      expected.printVersion = true
      expected.debug = true
      expected.quiet = true
      expected.bytesWarning = .warning
      expected.optimization = .O
      expected.module = file
      assertEqual(parsed, expected)
    }
  }

  func test_script() {
    let file = "tangled.py"
    let cmd = file

    if let parsed = self.parse(cmd) {
      var expected = Arguments()
      expected.script = file
      assertEqual(parsed, expected)
    }
  }

  func test_script_withFlags() {
    let file = "tangled.py"
    let cmd = "-v -d -q -b -O " + file

    if let parsed = self.parse(cmd) {
      var expected = Arguments()
      expected.printVersion = true
      expected.debug = true
      expected.quiet = true
      expected.bytesWarning = .warning
      expected.optimization = .O
      expected.script = file
      assertEqual(parsed, expected)
    }
  }

  func test_interactive() {
    let cmd = ""

    if let parsed = self.parse(cmd) {
      var expected = Arguments()
      expected.command = nil
      expected.module = nil
      expected.script = nil
      assertEqual(parsed, expected)
    }
  }

  func test_interactive_withFlags() {
    let cmd = "-v -d -q -b -O"

    if let parsed = self.parse(cmd) {
      var expected = Arguments()
      expected.printVersion = true
      expected.debug = true
      expected.quiet = true
      expected.bytesWarning = .warning
      expected.optimization = .O
      expected.command = nil
      expected.module = nil
      expected.script = nil
      assertEqual(parsed, expected)
    }
  }

  // MARK: - Help

  func test_help() {
    for cmd in ["-h", "-help", "--help"] {
      if let parsed = self.parse(cmd) {
        var expected = Arguments()
        expected.printHelp = true
        assertEqual(parsed, expected)
      }
    }
  }

  // MARK: - Helpers

  private func assertEqual(_ lhs: Arguments,
                           _ rhs: Arguments,
                           file:  StaticString = #file,
                           line:  UInt         = #line) {
    XCTAssertEqual(lhs.printHelp, rhs.printHelp, "printHelp", file: file, line: line)
    XCTAssertEqual(lhs.printVersion, rhs.printVersion, "printVersion", file: file, line: line)
    XCTAssertEqual(lhs.debug, rhs.debug, "debug", file: file, line: line)
    XCTAssertEqual(lhs.quiet, rhs.quiet, "quiet", file: file, line: line)
    XCTAssertEqual(lhs.isolated, rhs.isolated, "isolated", file: file, line: line)
    XCTAssertEqual(lhs.noSite, rhs.noSite, "noSite", file: file, line: line)
    XCTAssertEqual(lhs.noUserSite, rhs.noUserSite, "noUserSite", file: file, line: line)
    XCTAssertEqual(lhs.optimization, rhs.optimization, "optimization", file: file, line: line)
    XCTAssertEqual(lhs.warnings, rhs.warnings, "warnings", file: file, line: line)
    XCTAssertEqual(lhs.bytesWarning, rhs.bytesWarning, "bytesWarning", file: file, line: line)
    XCTAssertEqual(lhs.command, rhs.command, "command", file: file, line: line)
    XCTAssertEqual(lhs.module, rhs.module, "module", file: file, line: line)
    XCTAssertEqual(lhs.script, rhs.script, "script", file: file, line: line)

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

  private func parse(_ arguments: String,
                     file: StaticString = #file,
                     line: UInt         = #line) -> Arguments? {

    do {
      let parser = ArgumentParser()
      let split = arguments.split(separator: " ").map { String($0) }
      return try parser.parse(arguments: [programName] + split)
    } catch {
      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }
}
