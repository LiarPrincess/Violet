import XCTest
import Foundation
import FileSystem
@testable import VioletObjects

private func XCTAssertEqual(_ lhs: Arguments,
                            _ rhs: Arguments,
                            file: StaticString = #file,
                            line: UInt = #line) {
  XCTAssertEqual(lhs.help, rhs.help, "help", file: file, line: line)
  XCTAssertEqual(lhs.version, rhs.version, "version", file: file, line: line)
  XCTAssertEqual(lhs.debug, rhs.debug, "debug", file: file, line: line)
  XCTAssertEqual(lhs.quiet, rhs.quiet, "quiet", file: file, line: line)
  XCTAssertEqual(lhs.isolated, rhs.isolated, "isolated", file: file, line: line)
  XCTAssertEqual(lhs.optimize, rhs.optimize, "optimization", file: file, line: line)

  XCTAssertEqual(lhs.warnings, rhs.warnings, "warnings", file: file, line: line)
  XCTAssertEqual(lhs.bytesWarning,
                 rhs.bytesWarning,
                 "bytesWarning",
                 file: file,
                 line: line)

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

private func XCTAssertEqualStrings(_ lhs: String,
                                   _ rhs: String,
                                   file: StaticString = #file,
                                   line: UInt = #line) {
  func splitLines(_ s: String) -> [Substring] {
    return s.split(separator: "\n",
                   maxSplits: .max,
                   omittingEmptySubsequences: false)
  }

  let lhsLines = splitLines(lhs)
  let rhsLines = splitLines(rhs)

  XCTAssertEqual(lhsLines.count,
                 rhsLines.count,
                 "Line count",
                 file: file,
                 line: line)

  for (index, (l, r)) in zip(lhsLines, rhsLines).enumerated() {
    XCTAssertEqual(l,
                   r,
                   "Line \(index)",
                   file: file,
                   line: line)
  }
}

class ArgumentsTests: XCTestCase {

  private let programName = "Violet"

  // MARK: - Flags

  func test_help() {
    for cmd in ["-h", "-help", "--help"] {
      if let parsed = self.parse(cmd) {
        var expected = Arguments()
        expected.help = true
        XCTAssertEqual(parsed, expected)
      }
    }
  }

  func test_version() {
    for cmd in ["-V", "--version"] {
      if let parsed = self.parse(cmd) {
        var expected = Arguments()
        expected.version = true
        XCTAssertEqual(parsed, expected)
      }
    }
  }

  func test_debug() {
    if let parsed = self.parse("-d") {
      var expected = Arguments()
      expected.debug = true
      XCTAssertEqual(parsed, expected)
    }
  }

  func test_quiet() {
    if let parsed = self.parse("-q") {
      var expected = Arguments()
      expected.quiet = true
      XCTAssertEqual(parsed, expected)
    }
  }

  func test_inspect() {
    if let parsed = self.parse("-i") {
      var expected = Arguments()
      expected.inspectInteractively = true
      XCTAssertEqual(parsed, expected)
    }
  }

  func test_ignoreEnvironment() {
    if let parsed = self.parse("-E") {
      var expected = Arguments()
      expected.ignoreEnvironment = true
      XCTAssertEqual(parsed, expected)
    }
  }

  func test_isolate() {
    if let parsed = self.parse("-I") {
      var expected = Arguments()
      expected.isolated = true
      expected.ignoreEnvironment = true
      XCTAssertEqual(parsed, expected)
    }
  }

  func test_verbose() {
    for i in 1..<5 {
      let flag = "-" + String(repeating: "v", count: i)

      if let parsed = self.parse(flag) {
        var expected = Arguments()
        expected.verbose = i
        XCTAssertEqual(parsed, expected)
      }
    }
  }

  // MARK: - Byte compare

  func test_bytes() {
    let values: [String: Arguments.BytesWarningOption] = [
      "-b": .warning,
      "-bb": .error
    ]

    for (cmd, compare) in values {
      if let parsed = self.parse(cmd) {
        var expected = Arguments()
        expected.bytesWarning = compare
        XCTAssertEqual(parsed, expected)
      }
    }
  }

  func test_bytes_warning_doesNotOverrideError() {
    if let parsed = self.parse("-bb -b") {
      var expected = Arguments()
      expected.bytesWarning = .error
      XCTAssertEqual(parsed, expected)
    }
  }

  // MARK: - Optimization levels

  func test_optimization() {
    let values: [String: Py.OptimizationLevel] = [
      "-O": .O,
      "-OO": .OO
    ]

    for (cmd, optimize) in values {
      if let parsed = self.parse(cmd) {
        var expected = Arguments()
        expected.optimize = optimize
        XCTAssertEqual(parsed, expected)
      }
    }
  }

  func test_optimization_O_doesNotOverrideOO() {
    if let parsed = self.parse("-OO -O") {
      var expected = Arguments()
      expected.optimize = .OO
      XCTAssertEqual(parsed, expected)
    }
  }

  // MARK: - Warnings

  func test_warnings() {
    let values: [String: Arguments.WarningOption] = [
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
        XCTAssertEqual(parsed, expected)
      }
    }
  }

  func test_warnings_multiple() {
    let cmd = "-Wdefault -Werror -Walways -Wmodule -Wonce -Wignore"
    let warnings: [Arguments.WarningOption] = [
      .default, .error, .always, .module, .once, .ignore
    ]

    if let parsed = self.parse(cmd) {
      var expected = Arguments()
      expected.warnings = warnings
      XCTAssertEqual(parsed, expected)
    }
  }

  // MARK: - Flag ordering

  func test_flagsOrder_doesNotMatter() {
    let flags = ["-V", "-d", "-q", "-b", "-O"]
    let values = [
      flags.joined(separator: " "),
      flags.reversed().joined(separator: " ")
    ]

    for cmd in values {
      if let parsed = self.parse(cmd) {
        var expected = Arguments()
        expected.version = true
        expected.debug = true
        expected.quiet = true
        expected.bytesWarning = .warning
        expected.optimize = .O
        XCTAssertEqual(parsed, expected)
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
      XCTAssertEqual(parsed, expected)
    }
  }

  func test_command_withFlags() {
    let fn = "rapunzel()"
    let cmd = "-V -d -q -b -O -c \(fn)"

    if let parsed = self.parse(cmd) {
      var expected = Arguments()
      expected.version = true
      expected.debug = true
      expected.quiet = true
      expected.bytesWarning = .warning
      expected.optimize = .O
      expected.command = fn + "\n"
      XCTAssertEqual(parsed, expected)
    }
  }

  func test_module() {
    let file = "tangled.py"
    let cmd = "-m \(file)"

    if let parsed = self.parse(cmd) {
      var expected = Arguments()
      expected.module = file
      XCTAssertEqual(parsed, expected)
    }
  }

  func test_module_withFlags() {
    let file = "tangled.py"
    let cmd = "-V -d -q -b -O -m \(file)"

    if let parsed = self.parse(cmd) {
      var expected = Arguments()
      expected.version = true
      expected.debug = true
      expected.quiet = true
      expected.bytesWarning = .warning
      expected.optimize = .O
      expected.module = file
      XCTAssertEqual(parsed, expected)
    }
  }

  func test_script() {
    let file = "tangled.py"
    let cmd = file

    if let parsed = self.parse(cmd) {
      var expected = Arguments()
      expected.script = Path(string: file)
      XCTAssertEqual(parsed, expected)
    }
  }

  func test_script_withFlags() {
    let file = "tangled.py"
    let cmd = "-V -d -q -b -O " + file

    if let parsed = self.parse(cmd) {
      var expected = Arguments()
      expected.version = true
      expected.debug = true
      expected.quiet = true
      expected.bytesWarning = .warning
      expected.optimize = .O
      expected.script = Path(string: file)
      XCTAssertEqual(parsed, expected)
    }
  }

  func test_interactive() {
    let cmd = ""

    if let parsed = self.parse(cmd) {
      var expected = Arguments()
      expected.command = nil
      expected.module = nil
      expected.script = nil
      XCTAssertEqual(parsed, expected)
    }
  }

  func test_interactive_withFlags() {
    let cmd = "-V -d -q -b -O"

    if let parsed = self.parse(cmd) {
      var expected = Arguments()
      expected.version = true
      expected.debug = true
      expected.quiet = true
      expected.bytesWarning = .warning
      expected.optimize = .O
      expected.command = nil
      expected.module = nil
      expected.script = nil
      XCTAssertEqual(parsed, expected)
    }
  }

  // MARK: - Usage

  // swiftlint:disable:next function_body_length
  func test_usage() {
    let result = Arguments.helpMessage(columns: 80)
    XCTAssertEqualStrings(result, """
OVERVIEW: Violet - Python VM written in Swift

If a client requests it, we shall go anywhere.
Representing the Auto Memoir Doll service,
I am Violet Evergarden.

USAGE: Violet [<options>] [<script>]

ARGUMENTS:
  <script>                execute the code contained in script (terminates
                          option list)

OPTIONS:
  -h, --help, -help       print this help message and exit (also --help)
  -V, --version           print the Python version number and exit (also
                          --version)
  -d                      debug output messages; also PYTHONDEBUG=x
  -q                      don't print version and copyright messages on
                          interactive startup
  -i                      inspect interactively after running script; forces a
                          prompt even if stdin does not appear to be a
                          terminal; also PYTHONINSPECT=x
  -E                      ignore PYTHON* environment variables (such as
                          PYTHONPATH)
  -I                      isolate Violet from the user's environment (implies
                          -E)
  -v                      Print a message each time a module is initialized,
                          showing the place (filename or built-in module) from
                          which it is loaded. When given twice (-vv), print a
                          message for each file that is checked for when
                          searching for a module. Also provides information on
                          module cleanup at exit. See also PYTHONVERBOSE.
  -O                      remove assert and __debug__-dependent statements;
                          also PYTHONOPTIMIZE=x
  -OO                     do -O changes and also discard docstrings (overrides
                          '-O' if it is also set)
  -Wdefault, -Wd          warning control; warn once per call location; also
                          PYTHONWARNINGS=arg
  -Werror, -We            warning control; convert to exceptions; also
                          PYTHONWARNINGS=arg
  -Walways, -Wa           warning control; warn every time; also
                          PYTHONWARNINGS=arg
  -Wmodule, -Wm           warning control; warn once per calling module; also
                          PYTHONWARNINGS=arg
  -Wonce, -Wo             warning control; warn once per Python process; also
                          PYTHONWARNINGS=arg
  -Wignore, -Wi           warning control; never warn; also PYTHONWARNINGS=arg
  -b                      issue warning about str(bytes_instance),
                          str(bytearray_instance) and comparing bytes/bytearray
                          with str.
  -c <c>                  program passed in as string (terminates option list)
  -m <m>                  run library module as a script (terminates option
                          list)
""")
  }

  // MARK: - Helpers

  private func parse(_ arguments: String,
                     file: StaticString = #file,
                     line: UInt = #line) -> Arguments? {

    do {
      let split = arguments.split(separator: " ").map { String($0) }
      let result = try Arguments(from: [programName] + split)
      return result
    } catch {
      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }
}
