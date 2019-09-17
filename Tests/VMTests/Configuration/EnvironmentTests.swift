import Foundation
import XCTest
@testable import VM

// Song reference: https://youtu.be/40kfRj_ZUHY?t=36
class EnvironmentTests: XCTestCase {

  // MARK: - PATH

  func test_PATH_single() {
    let env = VM.Environment(from: [
      "PATH": "All those days, chasing down a daydream"
    ])

    var expected = VM.Environment()
    expected.PATH = ["All those days, chasing down a daydream"]
    self.assertEqual(env, expected)
  }

  func test_PATH_multiple() {
    let env = VM.Environment(from: [
      "PATH": "All those years:living in a blur"
    ])

    var expected = VM.Environment()
    expected.PATH = ["All those years", "living in a blur"]
    self.assertEqual(env, expected)
  }

  func test_PATH_multiple_endingWithColon() {
    let dict = [
      "PATH": "All that time:never truly seeing:"
    ]

    let env = VM.Environment(from: dict)

    var expected = VM.Environment()
    expected.PATH = ["All that time", "never truly seeing"]
    self.assertEqual(env, expected)
  }

  // MARK: - Violet path

  func test_violetPath_single() {
    let env = VM.Environment(from: [
      "VIOLETPATH": "Things the way they were"
    ])

    var expected = VM.Environment()
    expected.violetPath = ["Things the way they were"]
    self.assertEqual(env, expected)
  }

  func test_violetPath_multiple() {
    let env = VM.Environment(from: [
      "VIOLETPATH": "Now she's here:shining in the starlight"
    ])

    var expected = VM.Environment()
    expected.violetPath = ["Now she's here", "shining in the starlight"]
    self.assertEqual(env, expected)
  }

  func test_violetPath_multiple_endingWithColon() {
    let env = VM.Environment(from: [
      "VIOLETPATH": "Now she's here:suddenly I know:"
    ])

    var expected = VM.Environment()
    expected.violetPath = ["Now she's here", "suddenly I know"]
    self.assertEqual(env, expected)
  }

  // MARK: - PYTHONPATH

  func test_pythonPath_single() {
    let env = VM.Environment(from: [
      "PYTHONPATH": "If she's here, it's crystal clear"
    ])

    var expected = VM.Environment()
    expected.pythonPath = ["If she's here, it's crystal clear"]
    self.assertEqual(env, expected)
  }

  func test_pythonPath_multiple() {
    let env = VM.Environment(from: [
      "PYTHONPATH": "I'm where:I'm meant to go"
    ])

    var expected = VM.Environment()
    expected.pythonPath = ["I'm where", "I'm meant to go"]
    self.assertEqual(env, expected)
  }

  func test_pythonPath_multiple_endingWithColon() {
    let env = VM.Environment(from: [
      "PYTHONPATH": "And at last:I see the light:"
    ])

    var expected = VM.Environment()
    expected.pythonPath = ["And at last", "I see the light"]
    self.assertEqual(env, expected)
  }

  // MARK: - Optimize

  func test_optimize_O() {
    let env = VM.Environment(from: [
      "PYTHONOPTIMIZE": "And it's like the fog has lifted"
    ])

    var expected = VM.Environment()
    expected.pythonOptimize = .O
    self.assertEqual(env, expected)
  }

  func test_optimize_OO() {
    let env = VM.Environment(from: [
      "PYTHONOPTIMIZE": "2010"
    ])

    var expected = VM.Environment()
    expected.pythonOptimize = .OO
    self.assertEqual(env, expected)
  }

  // MARK: - Warning

  func test_warnings_single() {
    let presets: [String: WarningOption] = [
      "default": .default,
      "error":   .error,
      "always":  .always,
      "module":  .module,
      "once":    .once,
      "ignore":  .ignore
    ]

    for (value, warning) in presets {
      let env = VM.Environment(from: [
        "PYTHONWARNINGS": value
      ])

      var expected = VM.Environment()
      expected.pythonWarnings = [warning]
      self.assertEqual(env, expected)
    }
  }

  func test_warnings_multiple() {
    let env = VM.Environment(from: [
      "PYTHONWARNINGS": "default,error,always,module,once,ignore"
    ])

    var expected = VM.Environment()
    expected.pythonWarnings = [.default, .error, .always, .module, .once, .ignore]
    self.assertEqual(env, expected)
  }

  func test_warnings_unknown_isIgnored() {
    let env = VM.Environment(from: [
      "PYTHONWARNINGS": "And at last, I see the light"
    ])

    var expected = VM.Environment()
    expected.pythonWarnings = []
    self.assertEqual(env, expected)
  }

  // MARK: - Debug, inspect and noUserSite

  func test_debug() {
    let env = VM.Environment(from: [
      "PYTHONDEBUG": "And at last, I see the light"
    ])

    var expected = VM.Environment()
    expected.pythonDebug = true
    self.assertEqual(env, expected)
  }

  func test_inspect() {
    let env = VM.Environment(from: [
      "PYTHONINSPECT": "And it's like the sky is new"
    ])

    var expected = VM.Environment()
    expected.pythonInspectInteractively = true
    self.assertEqual(env, expected)
  }

  func test_noUserSite() {
    let env = VM.Environment(from: [
      "PYTHONNOUSERSITE": "And it's warm and real and bright"
    ])

    var expected = VM.Environment()
    expected.pythonNoUserSite = true
    self.assertEqual(env, expected)
  }

  // MARK: - Other

  func test_other_isIgnored() {
    let env = VM.Environment(from: [
      "TANGLED": "I'm where I'm meant to be"
    ])

    let expected = VM.Environment()
    self.assertEqual(env, expected)
  }

  // MARK: - Helpers

  private func assertEqual(_ lhs: VM.Environment,
                           _ rhs: VM.Environment,
                           file:  StaticString = #file,
                           line:  UInt         = #line) {
    XCTAssertEqual(lhs.PATH, rhs.PATH, "PATH", file: file, line: line)
    XCTAssertEqual(lhs.violetPath, rhs.violetPath, "violetPath", file: file, line: line)
    XCTAssertEqual(lhs.pythonPath, rhs.pythonPath, "pythonPath", file: file, line: line)
    XCTAssertEqual(lhs.pythonOptimize, rhs.pythonOptimize, "pythonOptimize", file: file, line: line)
    XCTAssertEqual(lhs.pythonWarnings, rhs.pythonWarnings, "pythonWarnings", file: file, line: line)
    XCTAssertEqual(lhs.pythonDebug, rhs.pythonDebug, "pythonDebug", file: file, line: line)

    XCTAssertEqual(lhs.pythonNoUserSite,
                   rhs.pythonNoUserSite,
                   "pythonNoUserSite",
                   file: file,
                   line: line)
    XCTAssertEqual(lhs.pythonInspectInteractively,
                   rhs.pythonInspectInteractively,
                   "pythonInspectInteractively",
                   file: file,
                   line: line)
  }
}
