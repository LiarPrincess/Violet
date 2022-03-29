import XCTest
import VioletCore
import VioletParser
@testable import VioletCompiler

// cSpell:ignore asname

// MARK: - Asserts

private func XCTAssertNoFlags(_ features: FutureFeatures,
                              file: StaticString = #file,
                              line: UInt = #line) {
  // All flags default to 'false'.
  XCTAssertFlags(features, file: file, line: line)
}

private func XCTAssertFlags(_ features: FutureFeatures,
                            absoluteImport: Bool = false,
                            division: Bool = false,
                            withStatement: Bool = false,
                            printFunction: Bool = false,
                            unicodeLiterals: Bool = false,
                            barryAsBdfl: Bool = false,
                            generatorStop: Bool = false,
                            annotations: Bool = false,
                            file: StaticString = #file,
                            line: UInt = #line) {
  let hasAbsoluteImport = features.flags.contains(.absoluteImport)
  XCTAssertEqual(hasAbsoluteImport, absoluteImport, "absoluteImport", file: file, line: line)

  let hasDivision = features.flags.contains(.division)
  XCTAssertEqual(hasDivision, division, "division", file: file, line: line)

  let hasWithStatement = features.flags.contains(.withStatement)
  XCTAssertEqual(hasWithStatement, withStatement, "withStatement", file: file, line: line)

  let hasPrintFunction = features.flags.contains(.printFunction)
  XCTAssertEqual(hasPrintFunction, printFunction, "printFunction", file: file, line: line)

  let hasUnicodeLiterals = features.flags.contains(.unicodeLiterals)
  XCTAssertEqual(hasUnicodeLiterals, unicodeLiterals, "unicodeLiterals", file: file, line: line)

  let hasBarryAsBdfl = features.flags.contains(.barryAsBdfl)
  XCTAssertEqual(hasBarryAsBdfl, barryAsBdfl, "barryAsBdfl", file: file, line: line)

  let hasGeneratorStop = features.flags.contains(.generatorStop)
  XCTAssertEqual(hasGeneratorStop, generatorStop, "generatorStop", file: file, line: line)

  let hasAnnotations = features.flags.contains(.annotations)
  XCTAssertEqual(hasAnnotations, annotations, "annotations", file: file, line: line)
}

class FutureFeaturesTests: XCTestCase, ASTCreator {

  // MARK: - barry_as_FLUFL

  /// from `__future__` import barry_as_FLUFL
  ///
  /// Module (node)
  ///   body (list)
  ///     ImportFrom (node)
  ///       module: '__future__'
  ///       names (list)
  ///         alias (node)
  ///           name: 'barry_as_FLUFL'
  ///           asname: None
  ///       level: 0
  func test_future_flufl_isRecognized() throws {
    let features = try self.parse(statements: [
      self.importFromStmt(
        moduleName: "__future__",
        names: [self.alias(name: "barry_as_FLUFL", asName: nil)],
        level: 0,
        start: SourceLocation(line: 12, column: 0)
      )
    ])

    XCTAssertEqual(features.lastLine, 12)
    XCTAssertFlags(features, barryAsBdfl: true)
  }

  /// from `__future__` import barry_as_FLUFL as BDFL
  func test_future_flufl_withAlias_isRecognized() throws {
    let features = try self.parse(statements: [
      self.importFromStmt(
        moduleName: "__future__",
        names: [self.alias(name: "barry_as_FLUFL", asName: "BDFL")],
        level: 0,
        start: SourceLocation(line: 12, column: 0)
      )
    ])

    XCTAssertEqual(features.lastLine, 12)
    XCTAssertFlags(features, barryAsBdfl: true)
  }

  // MARK: - annotations

  /// from __future__ import annotations
  func test_future_annotations_isRecognized() throws {
    let features = try self.parse(statements: [
      self.importFromStmt(
        moduleName: "__future__",
        names: [self.alias(name: "annotations", asName: nil)],
        level: 0,
        start: SourceLocation(line: 12, column: 0)
      )
    ])

    XCTAssertEqual(features.lastLine, 12)
    XCTAssertFlags(features, annotations: true)
  }

  /// from __future__ import annotations as ann
  func test_future_annotations_withAlias_isRecognized() throws {
    let features = try self.parse(statements: [
      self.importFromStmt(
        moduleName: "__future__",
        names: [self.alias(name: "annotations", asName: "ann")],
        level: 0,
        start: SourceLocation(line: 12, column: 0)
      )
    ])

    XCTAssertEqual(features.lastLine, 12)
    XCTAssertFlags(features, annotations: true)
  }

  // MARK: - braces

  /// from __future__ import braces
  func test_future_braces_isRecognized() throws {
    let location = SourceLocation(line: 12, column: 1)

    do {
      _ = try self.parse(statements: [
        self.importFromStmt(
          moduleName: "__future__",
          names: [self.alias(name: "braces", asName: nil)],
          level: 0,
          start: SourceLocation(line: 12, column: 1)
        )
      ])

      XCTFail("'from __future__ import braces' should throw")
    } catch let error as CompilerError {
      XCTAssertEqual(error.location, location)

      switch error.kind {
      case .fromFutureImportBraces:
        break
      default:
        XCTFail("Invalid error kind: '\(error.kind)'")
      }
    }
  }

  /// from __future__ import braces as nope
  func test_future_braces_withAlias_isRecognized() throws {
    let location = SourceLocation(line: 12, column: 1)

    do {
      _ = try self.parse(statements: [
        self.importFromStmt(
          moduleName: "__future__",
          names: [self.alias(name: "braces", asName: "nope")],
          level: 0,
          start: SourceLocation(line: 12, column: 1)
        )
      ])

      XCTFail("'from __future__ import braces' should throw.")
    } catch let error as CompilerError {
      XCTAssertEqual(error.location, location)

      switch error.kind {
      case .fromFutureImportBraces:
        break
      default:
        XCTFail("Invalid error kind: '\(error.kind)'")
      }
    }
  }

  // MARK: - Doc

  func test_future_flufl_afterDoc_isRecognized() throws {
    let features = try self.parse(statements: [
      self.exprStmt(
        expression: self.stringExpr(value: .literal("__doc__ line 1"))
      ),
      self.exprStmt(
        expression: self.stringExpr(value: .literal("__doc__ line 2"))
      ),
      self.importFromStmt(
        moduleName: "__future__",
        names: [self.alias(name: "barry_as_FLUFL", asName: nil)],
        level: 0,
        start: SourceLocation(line: 12, column: 0)
      )
    ])

    XCTAssertEqual(features.lastLine, 12)
    XCTAssertFlags(features, barryAsBdfl: true)
  }

  // MARK: - Multiple

  /// from __future__ import barry_as_FLUFL, annotations
  ///
  /// Module (node)
  ///   body (list)
  ///     ImportFrom (node)
  ///       module: '__future__'
  ///       names (list)
  ///         alias (node)
  ///           name: 'barry_as_FLUFL'
  ///           asname: None
  ///         alias (node)
  ///           name: 'annotations'
  ///           asname: None
  ///       level: 0
  func test_multiple_tuple_areRecognized() throws {
    let features = try self.parse(statements: [
      self.importFromStmt(
        moduleName: "__future__",
        names: [
          self.alias(name: "barry_as_FLUFL", asName: nil),
          self.alias(name: "annotations", asName: nil)
        ],
        level: 0,
        start: SourceLocation(line: 12, column: 0)
      )
    ])

    XCTAssertEqual(features.lastLine, 12)
    XCTAssertFlags(features, barryAsBdfl: true, annotations: true)
  }

  /// from __future__ import barry_as_FLUFL
  /// from __future__ import annotations
  ///
  /// Module (node)
  ///   body (list)
  ///     ImportFrom (node)
  ///       module: '__future__'
  ///       names (list)
  ///         alias (node)
  ///           name: 'barry_as_FLUFL'
  ///           asname: None
  ///       level: 0
  ///     ImportFrom (node)
  ///       module: '__future__'
  ///       names (list)
  ///         alias (node)
  ///           name: 'annotations'
  ///           asname: None
  ///       level: 0
  func test_multiple_separateStatements_areRecognized() throws {
    let features = try self.parse(statements: [
      self.importFromStmt(
        moduleName: "__future__",
        names: [self.alias(name: "barry_as_FLUFL", asName: nil)],
        level: 0,
        start: SourceLocation(line: 12, column: 0)
      ),
      self.importFromStmt(
        moduleName: "__future__",
        names: [
          self.alias(name: "barry_as_FLUFL", asName: nil),
          self.alias(name: "annotations", asName: nil)
        ],
        level: 0,
        start: SourceLocation(line: 15, column: 0)
      )
    ])

    XCTAssertEqual(features.lastLine, 15)
    XCTAssertFlags(features, barryAsBdfl: true, annotations: true)
  }

  func test_multiple_separateStatements_sameLine_areRecognized() throws {
    let features = try self.parse(statements: [
      self.importFromStmt(
        moduleName: "__future__",
        names: [self.alias(name: "barry_as_FLUFL", asName: nil)],
        level: 0,
        start: SourceLocation(line: 12, column: 0)
      ),
      self.importFromStmt(
        moduleName: "__future__",
        names: [
          self.alias(name: "barry_as_FLUFL", asName: nil),
          self.alias(name: "annotations", asName: nil)
        ],
        level: 0,
        start: SourceLocation(line: 12, column: 80)
      )
    ])

    XCTAssertEqual(features.lastLine, 12)
    XCTAssertFlags(features, barryAsBdfl: true, annotations: true)
  }

  // MARK: - Obsolete flags

  func test_obsoleteFlags_doNotThrow() throws {
    var line = SourceLocation.start.line

    func createImport(name: String) -> ImportFromStmt {
      line += 1
      return self.importFromStmt(
        moduleName: "__future__",
        names: [self.alias(name: name, asName: nil)],
        level: 0,
        start: SourceLocation(line: line, column: 0)
      )
    }

    let features = try self.parse(statements: [
      createImport(name: "nested_scopes"),
      createImport(name: "generators"),
      createImport(name: "division"),
      createImport(name: "absolute_import"),
      createImport(name: "with_statement"),
      createImport(name: "print_function"),
      createImport(name: "unicode_literals"),
      createImport(name: "generator_stop")
    ])

    XCTAssertEqual(features.lastLine, line)
    XCTAssertNoFlags(features)
  }

  // MARK: - Unrecognized future

  /// from __future__ import Kristoff as Princess
  func test_unrecognized_throws() throws {
    let location = SourceLocation(line: 12, column: 1)

    do {
      _ = try self.parse(statements: [
        self.importFromStmt(
          moduleName: "__future__",
          names: [self.alias(name: "Kristoff", asName: "Princess")],
          level: 0,
          start: location
        )
      ])

      XCTFail("'from __future__ import Kristoff as Princess' should throw.")
    } catch let error as CompilerError {
      XCTAssertEqual(error.location, location)

      switch error.kind {
      case .undefinedFutureFeature(let name):
        XCTAssertEqual(name, "Kristoff")
      default:
        XCTFail("Invalid error kind: '\(error.kind)'")
      }
    }
  }

  // MARK: - Late future

  /// import elsa
  /// from __future__ import braces
  func test_lateFuture_throws() throws {
    let location = SourceLocation(line: 12, column: 1)

    do {
      _ = try self.parse(statements: [
        self.importStmt(
          names: [self.alias(name: "elsa", asName: nil)]
        ),
        self.importFromStmt(
          moduleName: "__future__",
          names: [self.alias(name: "braces", asName: nil)],
          level: 0,
          start: location
        )
      ])

      XCTFail("Expected 'lateFuture' error.")
    } catch let error as CompilerError {
      XCTAssertEqual(error.location, location)

      switch error.kind {
      case .lateFuture:
        break
      default:
        XCTFail("Invalid error kind: '\(error.kind)'")
      }
    }
  }

  // MARK: - Import -> no flags

  func test_emptyAST_hasNoFutureFeatures() throws {
    let features = try self.parse(statements: [])
    XCTAssertEqual(features.lastLine, SourceLocation.start.line)
    XCTAssertNoFlags(features)
  }

  /// import Elsa
  ///
  /// Module (node)
  ///   body (list)
  ///     Import (node)
  ///       names (list)
  ///         alias (node)
  ///           name: 'Elsa'
  ///           asname: None
  func test_import_hasNoFutureFeatures() throws {
    let features = try self.parse(statements: [
      self.importStmt(names: [
        self.alias(name: "Elsa", asName: nil)
      ])
    ])

    XCTAssertEqual(features.lastLine, SourceLocation.start.line)
    XCTAssertNoFlags(features)
  }

  /// import Elsa as Princess
  ///
  /// Module (node)
  ///   body (list)
  ///     Import (node)
  ///       names (list)
  ///         alias (node)
  ///           name: 'Elsa'
  ///           asname: 'Princess'
  func test_import_withAlias_hasNoFutureFeatures() throws {
    let features = try self.parse(statements: [
      self.importStmt(names: [
        self.alias(name: "Elsa", asName: "Princess")
      ])
    ])

    XCTAssertEqual(features.lastLine, SourceLocation.start.line)
    XCTAssertNoFlags(features)
  }

  // MARK: - Parse

  private func parse(statements: [Statement]) throws -> FutureFeatures {
    let ast = self.moduleAST(statements: statements)
    return try FutureFeatures.parse(ast: ast)
  }
}
