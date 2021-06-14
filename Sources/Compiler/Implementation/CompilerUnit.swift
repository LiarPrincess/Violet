import VioletBytecode

/// The following items change on entry and exit of scope.
/// They must be saved and restored when returning to a scope.
internal final class CompilerUnit {

  internal let scope: SymbolScope
  internal let builder: CodeObjectBuilder
  /// Name of the class that we are currently filling (if any).
  /// Mostly used for mangling.
  internal let className: String?

  internal init(className: String?,
                scope: SymbolScope,
                builder: CodeObjectBuilder) {
    self.className = className
    self.scope = scope
    self.builder = builder
  }
}
