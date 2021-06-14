import VioletCore
import VioletParser
import VioletBytecode

public final class Compiler {

  // MARK: - Options

  public struct Options {

    /// Controls various sorts of optimizations
    public let optimizationLevel: OptimizationLevel

    public init(optimizationLevel: OptimizationLevel) {
      self.optimizationLevel = optimizationLevel
    }
  }

  // MARK: - OptimizationLevel

  /// Controls various sorts of optimizations
  public enum OptimizationLevel: Equatable, Comparable {
    /// No optimizations.
    case none
    /// Remove assert statements and any code conditional on the value of `__debug__`.
    /// Command line: `-O`.
    case O
    /// Do `-O` and also discard `docstrings`.
    /// Command line: `-OO`.
    case OO

    public static func < (lhs: OptimizationLevel, rhs: OptimizationLevel) -> Bool {
      switch (lhs, rhs) {
      case (.none, .none): return false
      case (.none, _): return true

      case (.O, .OO): return true
      case (.O, _): return false

      case (.OO, _): return false
      }
    }
  }

  // MARK: - Implementation

  private let impl: CompilerImpl

  public init(filename: String,
              ast: AST,
              options: Options,
              delegate: CompilerDelegate?) {
    self.impl = CompilerImpl(filename: filename,
                             ast: ast,
                             options: options,
                             delegate: delegate)
  }

  public func run() throws -> CodeObject {
    return try self.impl.run()
  }
}
