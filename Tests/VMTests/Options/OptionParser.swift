import Foundation
import XCTest
@testable import VM

// swiftlint:disable file_length

class OptionParser: XCTestCase {

  // MARK: - Version

  func test_version() throws {
    for arguments in ["-v", "--version"] {
      if let options = self.parse(arguments) {
        var expected = Options()
        expected.version = true
        assertEqual(options, expected)
      }
    }
  }

  // MARK: - Debug

  func test_debug() throws {
    if let options = self.parse("-d") {
      var expected = Options()
      expected.debug = true
      assertEqual(options, expected)
    }
  }

  // MARK: - Interactive

  func test_enterInteractiveAfterExecuting() throws {
    if let options = self.parse("-i") {
      var expected = Options()
      expected.enterInteractiveAfterExecuting = true
      assertEqual(options, expected)
    }
  }

  // MARK: - Quiet

  func test_quiet() throws {
    if let options = self.parse("-q") {
      var expected = Options()
      expected.quiet = true
      assertEqual(options, expected)
    }
  }

  // MARK: - Bytes

  func test_bytes() throws {
    let values: [String: ByteCompareOptions] = [
      "-b": .warning,
      "-bb": .error
    ]

    for (arguments, compare) in values {
      if let options = self.parse(arguments) {
        var expected = Options()
        expected.byteCompare = compare
        assertEqual(options, expected)
      }
    }
  }

  func test_bytes_warning_doesNotOverrideError() throws {
    if let options = self.parse("-bb -b") {
      var expected = Options()
      expected.byteCompare = .error
      assertEqual(options, expected)
    }
  }

  // MARK: - Optimization levels

  func test_optimization() throws {
    let values: [String: OptimizationLevel] = [
      "-O": .O,
      "-OO": .OO
    ]

    for (arguments, optimization) in values {
      if let options = self.parse(arguments) {
        var expected = Options()
        expected.optimization = optimization
        assertEqual(options, expected)
      }
    }
  }

  func test_optimization_O_doesNotOverrideOO() throws {
    if let options = self.parse("-OO -O") {
      var expected = Options()
      expected.optimization = .OO
      assertEqual(options, expected)
    }
  }

  // MARK: - Warning

  func test_warnings() throws {
    let values: [String: WarningOptions] = [
      "ignore": .ignore,
      "error": .error
    ]

    for (arguments, warnings) in values {
      if let options = self.parse("-W " + arguments) {
        var expected = Options()
        expected.warnings = warnings
        assertEqual(options, expected)
      }
    }
  }

  // MARK: - Flag ordering

  func test_flagsOrder_doesNotMatter() throws {
    let flags = ["-v", "-d", "-q", "-b", "-O"]
    let values = [
      flags.joined(separator: " "),
      flags.reversed().joined(separator: " ")
    ]

    for arguments in values {
      if let options = self.parse(arguments) {
        var expected = Options()
        expected.version = true
        expected.debug = true
        expected.quiet = true
        expected.byteCompare = .warning
        expected.optimization = .O
        assertEqual(options, expected)
      }
    }
  }

  // MARK: - Command, module, script, interactive

  func test_command() throws {
    let fn = "rapunzel()"
    let arguments = "-c \(fn)"

    if let options = self.parse(arguments) {
      var expected = Options()
      expected.command = fn
      assertEqual(options, expected)
    }
  }

  func test_command_withFlags() throws {
    let fn = "rapunzel()"
    let arguments = "-v -d -q -b -O -c \(fn)"

    if let options = self.parse(arguments) {
      var expected = Options()
      expected.version = true
      expected.debug = true
      expected.quiet = true
      expected.byteCompare = .warning
      expected.optimization = .O
      expected.command = fn
      assertEqual(options, expected)
    }
  }

  func test_module() throws {
    let file = "tangled.py"
    let arguments = "-m \(file)"

    if let options = self.parse(arguments) {
      var expected = Options()
      expected.module = file
      assertEqual(options, expected)
    }
  }

  func test_module_withFlags() throws {
    let file = "tangled.py"
    let arguments = "-v -d -q -b -O -m \(file)"

    if let options = self.parse(arguments) {
      var expected = Options()
      expected.version = true
      expected.debug = true
      expected.quiet = true
      expected.byteCompare = .warning
      expected.optimization = .O
      expected.module = file
      assertEqual(options, expected)
    }
  }

  func test_script() throws {
    let file = "tangled.py"
    let arguments = file

    if let options = self.parse(arguments) {
      var expected = Options()
      expected.script = file
      assertEqual(options, expected)
    }
  }

  func test_script_withFlags() throws {
    let file = "tangled.py"
    let arguments = "-v -d -q -b -O " + file

    if let options = self.parse(arguments) {
      var expected = Options()
      expected.version = true
      expected.debug = true
      expected.quiet = true
      expected.byteCompare = .warning
      expected.optimization = .O
      expected.script = file
      assertEqual(options, expected)
    }
  }

  func test_interactive() throws {
    let arguments = ""

    if let options = self.parse(arguments) {
      var expected = Options()
      expected.command = nil
      expected.module = nil
      expected.script = nil
      assertEqual(options, expected)
    }
  }

  func test_interactive_withFlags() throws {
    let arguments = "-v -d -q -b -O"

    if let options = self.parse(arguments) {
      var expected = Options()
      expected.version = true
      expected.debug = true
      expected.quiet = true
      expected.byteCompare = .warning
      expected.optimization = .O
      expected.command = nil
      expected.module = nil
      expected.script = nil
      assertEqual(options, expected)
    }
  }

  // MARK: - Help

  func test_help() throws {
    for arguments in ["-h", "-help", "--help"] {
      if let options = self.parse(arguments) {
        var expected = Options()
        expected.help = true
        assertEqual(options, expected)
      }
    }
  }

  // MARK: - Helpers

  private func assertEqual(_ lhs: Options,
                           _ rhs: Options,
                           file:  StaticString = #file,
                           line:  UInt         = #line) {

    XCTAssertEqual(lhs.command, rhs.command, "command", file: file, line: line)
    XCTAssertEqual(lhs.module,  rhs.module,  "module", file: file, line: line)
    XCTAssertEqual(lhs.script,  rhs.script,  "script", file: file, line: line)
    XCTAssertEqual(lhs.version, rhs.version, "version", file: file, line: line)
    XCTAssertEqual(lhs.debug,   rhs.debug,   "debug", file: file, line: line)

    XCTAssertEqual(lhs.byteCompare,
                   rhs.byteCompare,
                   "byteCompare",
                   file: file,
                   line: line)

    XCTAssertEqual(lhs.enterInteractiveAfterExecuting,
                   rhs.enterInteractiveAfterExecuting,
                   "enterInteractiveAfterExecuting",
                   file: file,
                   line: line)

    XCTAssertEqual(lhs.optimization,
                   rhs.optimization,
                   "optimization",
                   file: file,
                   line: line)

    XCTAssertEqual(lhs.quiet,    rhs.quiet,    "quiet", file: file, line: line)
    XCTAssertEqual(lhs.warnings, rhs.warnings, "warnings", file: file, line: line)

    // if we added new property, but did not put it in this method:
    XCTAssertEqual(lhs, rhs, file: file, line: line)
  }

  private func dump(_ options: Options) {
    print("Options:")
    print("  command:", options.command ?? "nil")
    print("  module:", options.module ?? "nil")
    print("  script:", options.script ?? "nil")
    print("  version:", options.version)
    print("  debug:", options.debug)
    print("  byteCompare:", options.byteCompare)
    print("  enterInteractiveAfterExecuting:", options.enterInteractiveAfterExecuting)
    print("  optimization:", options.optimization)
    print("  quiet:", options.quiet)
    print("  warnings:", options.warnings)
  }

  private func parse(_ arguments: String,
                     file: StaticString = #file,
                     line: UInt         = #line) -> Options? {

    do {
      let parser = OptionsParser()
      let split = arguments.split(separator: " ").map { String($0) }
      return try parser.parse(arguments: split)
    } catch {
      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }
}
