public struct CompilerOptions {

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
