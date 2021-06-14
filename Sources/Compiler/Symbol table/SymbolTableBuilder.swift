import VioletCore
import VioletParser

// In CPython:
// Python -> symtable.c

public final class SymbolTableBuilder {

  private let impl: SymbolTableBuilderImpl

  public init(delegate: CompilerDelegate?) {
    self.impl = SymbolTableBuilderImpl(delegate: delegate)
  }

  public func visit(ast: AST) throws -> SymbolTable {
    return try self.impl.visit(ast: ast)
  }
}
