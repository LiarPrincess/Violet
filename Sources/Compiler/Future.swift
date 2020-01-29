import Core
import Parser

// In CPython:
// Python -> future.c

public struct FutureFeatureFlags: OptionSet {
  public let rawValue: UInt8

  /// Absolute imports are now default
  public static let absoluteImport  = FutureFeatureFlags(rawValue: 1 << 0)
  public static let division        = FutureFeatureFlags(rawValue: 1 << 1)
  public static let withStatement   = FutureFeatureFlags(rawValue: 1 << 2)
  public static let printFunction   = FutureFeatureFlags(rawValue: 1 << 3)
  public static let unicodeLiterals = FutureFeatureFlags(rawValue: 1 << 4)
  public static let barryAsBdfl     = FutureFeatureFlags(rawValue: 1 << 5)
  public static let generatorStop   = FutureFeatureFlags(rawValue: 1 << 6)
  public static let annotations     = FutureFeatureFlags(rawValue: 1 << 7)

  public init(rawValue: UInt8) {
    self.rawValue = rawValue
  }
}

public struct FutureFeatures {

  /// Flags set by future statements
  public fileprivate(set) var flags: FutureFeatureFlags = []

  /// Line number of last future statement
  public fileprivate(set) var lastLine: SourceLine = 0
}

public final class FutureBuilder {

  /// future_parse(PyFutureFeatures *ff, mod_ty mod, PyObject *filename)
  public func parse(ast: AST) throws -> FutureFeatures {
    var result = FutureFeatures()

    let statements = self.getStatements(from: ast)
    guard statements.any else {
      return result
    }

    var isDone = false
    var previousLine: SourceLine = 0
    let index = self.getIndexAfterDoc(statements)

    for stmt in statements[index...] {
      // it is possible to have multiple imports in the same line
      if isDone && stmt.start.line > previousLine {
        return result
      }

      previousLine = stmt.start.line

      if let importStmt = stmt as? ImportFromStmt,
        importStmt.moduleName == SpecialIdentifiers.__future__ {

        if isDone {
          // '__future__' imports have to be first, so this is not valid:
          // import tangled
          // from __future__ import braces
          throw CompilerError(.lateFuture, location: stmt.start)
        }

        result.lastLine = stmt.start.line
        try self.appendFeatures(from: importStmt.names,
                                into: &result,
                                errorLocation: stmt.start)
      } else {
        isDone = true
      }
    }

    return result
  }

  private func getStatements(from ast: AST) -> [Statement] {
    if let node = ast as? InteractiveAST {
      return node.statements
    }

    if let node = ast as? ModuleAST {
      return node.statements
    }

    return []
  }

  private func getIndexAfterDoc(_ statements: [Statement]) -> Int {
    var index = 0
    while index < statements.count && statements[index].isDocString {
      index += 1
    }
    return index
  }

  /// future_check_features(PyFutureFeatures *ff, stmt_ty s, PyObject *filename)
  private func appendFeatures(
    from imports: NonEmptyArray<Alias>,
    into features: inout FutureFeatures,
    errorLocation: SourceLocation) throws {

    for alias in imports {
      // Check 'name' not alias!
      // For example, this should throw:
      // from __future__ import braces as letItGo
      switch alias.name {
      case "nested_scopes",
           "generators",
           "division",
           "absolute_import",
           "with_statement",
           "print_function",
           "unicode_literals",
           "generator_stop":
        // Those features are already baked in.
        break
      case "barry_as_FLUFL":
        /// NotImplemented. We will throw later.
        /// https://www.python.org/dev/peps/pep-0401/
        features.flags.formUnion(.barryAsBdfl)
      case "annotations":
        features.flags.formUnion(.annotations)
      case "braces":
        throw CompilerError(.fromFutureImportBraces, location: errorLocation)
      default:
        let kind = CompilerErrorKind.undefinedFutureFeature(alias.name)
        throw CompilerError(kind, location: errorLocation)
      }
    }
  }
}
