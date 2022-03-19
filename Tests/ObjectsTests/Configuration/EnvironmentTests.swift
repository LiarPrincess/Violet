import XCTest
import Foundation
import FileSystem
@testable import VioletObjects

// Song reference: https://youtu.be/40kfRj_ZUHY?t=36
class EnvironmentTests: XCTestCase {

  // MARK: - Violet home

  func test_violetHome_prefix() {
    let env = Environment(from: [
      "VIOLETHOME": "All those days, chasing down a daydream"
    ])

    var expected = Environment()
    expected.violetHome = Path(string: "All those days, chasing down a daydream")
    self.assertEqual(env, expected)
  }

  func test_violetHome_prefix_colon_execPrefix() {
    // We don't support 'prefix:exec_prefix' notation, we only have prefix.
    let env = Environment(from: [
      "VIOLETHOME": "All those years:living in a blur"
    ])

    var expected = Environment()
    expected.violetHome = Path(string: "All those years")
    self.assertEqual(env, expected)
  }

  func test_violetHome_prefix_colon_execPrefix_withAnotherColon() {
    // We don't support 'prefix:exec_prefix' notation, we only have prefix.
    let dict = [
      "VIOLETHOME": "All that time:never truly seeing:"
    ]

    let env = Environment(from: dict)

    var expected = Environment()
    expected.violetHome = Path(string: "All that time")
    self.assertEqual(env, expected)
  }

  // MARK: - Violet path

  func test_violetPath_single() {
    let env = Environment(from: [
      "VIOLETPATH": "Things the way they were"
    ])

    var expected = Environment()
    expected.violetPath = [Path(string: "Things the way they were")]
    self.assertEqual(env, expected)
  }

  func test_violetPath_multiple() {
    let env = Environment(from: [
      "VIOLETPATH": "Now she's here:shining in the starlight"
    ])

    var expected = Environment()
    expected.violetPath = [
      Path(string: "Now she's here"),
      Path(string: "shining in the starlight")
    ]
    self.assertEqual(env, expected)
  }

  func test_violetPath_multiple_endingWithColon() {
    let env = Environment(from: [
      "VIOLETPATH": "Now she's here:suddenly I know:"
    ])

    var expected = Environment()
    expected.violetPath = [
      Path(string: "Now she's here"),
      Path(string: "suddenly I know")
    ]
    self.assertEqual(env, expected)
  }

  // There is a gap in the lyrics here, because at some point we supported PATH.
  // Anyway, here are the verses that we are missing:
  // If she's here, it's crystal clear
  // I'm where I'm meant to go
  // And at last I see the light

  // MARK: - Optimize

  func test_optimize_O() {
    let env = Environment(from: [
      "PYTHONOPTIMIZE": "And it's like the fog has lifted"
    ])

    var expected = Environment()
    expected.optimize = .O
    self.assertEqual(env, expected)
  }

  func test_optimize_OO() {
    let env = Environment(from: [
      "PYTHONOPTIMIZE": "2010"
    ])

    var expected = Environment()
    expected.optimize = .OO
    self.assertEqual(env, expected)
  }

  // MARK: - Warning

  func test_warnings_single() {
    let presets: [String: Arguments.WarningOption] = [
      "default": .default,
      "error": .error,
      "always": .always,
      "module": .module,
      "once": .once,
      "ignore": .ignore
    ]

    for (value, warning) in presets {
      let env = Environment(from: [
        "PYTHONWARNINGS": value
      ])

      var expected = Environment()
      expected.warnings = [warning]
      self.assertEqual(env, expected)
    }
  }

  func test_warnings_multiple() {
    let env = Environment(from: [
      "PYTHONWARNINGS": "default,error,always,module,once,ignore"
    ])

    var expected = Environment()
    expected.warnings = [.default, .error, .always, .module, .once, .ignore]
    self.assertEqual(env, expected)
  }

  func test_warnings_unknown_isIgnored() {
    let env = Environment(from: [
      "PYTHONWARNINGS": "And at last, I see the light"
    ])

    var expected = Environment()
    expected.warnings = []
    self.assertEqual(env, expected)
  }

  // MARK: - Debug, inspect and noUserSite

  func test_debug() {
    let env = Environment(from: [
      "PYTHONDEBUG": "And at last, I see the light"
    ])

    var expected = Environment()
    expected.debug = true
    self.assertEqual(env, expected)
  }

  func test_inspect() {
    let env = Environment(from: [
      "PYTHONINSPECT": "And it's like the sky is new"
    ])

    var expected = Environment()
    expected.inspectInteractively = true
    self.assertEqual(env, expected)
  }

  // MARK: - Other

  func test_other_isIgnored() {
    let env = Environment(from: [
      "TANGLED": "And it's warm and real and bright"
    ])

    let expected = Environment()
    self.assertEqual(env, expected)
  }

  // MARK: - Helpers

  private func assertEqual(_ lhs: Environment,
                           _ rhs: Environment,
                           file: StaticString = #file,
                           line: UInt = #line) {
    XCTAssertEqual(lhs.violetHome, rhs.violetHome, "violetHome", file: file, line: line)
    XCTAssertEqual(lhs.violetPath, rhs.violetPath, "violetPath", file: file, line: line)
    XCTAssertEqual(lhs.optimize, rhs.optimize, "optimize", file: file, line: line)
    XCTAssertEqual(lhs.warnings, rhs.warnings, "warnings", file: file, line: line)
    XCTAssertEqual(lhs.debug, rhs.debug, "debug", file: file, line: line)

    XCTAssertEqual(lhs.inspectInteractively,
                   rhs.inspectInteractively,
                   "inspectInteractively",
                   file: file,
                   line: line)
  }
}
