import VioletCore
import VioletParser
import VioletBytecode

// In CPython:
// Include -> symtable.h

/// Container that holds multiple 'SymbolScopes'.
public final class SymbolTable {

  /// Mapping from ASTNode to Symbol scope.
  /// Returns `nil` if no scope is associated with given node.
  public struct ScopeByNode {

    // We can't use `Node` as key because it as an protocol.
    private var inner = [ASTNodeId: SymbolScope]()

    // `internal` so, that we can't instantiate it outside of this module.
    internal init() {}

    public internal(set) subscript<N: ASTNode>(key: N) -> SymbolScope? {
      get { return self.inner[key.id] }
      set { self.inner[key.id] = newValue }
    }
  }

  /// Top scope in symbol table, corresponds to top scope in AST.
  public let top: SymbolScope
  /// All of the scopes by their corresponding AST node.
  public let scopeByNode: ScopeByNode

  // CPython also contains 'st_global' (for 'borrowed ref to st_top->ste_symbols'),
  // but AFAIK it is not used anywhere.

  // `internal` so, that we can't instantiate it outside of this module.
  internal init(top: SymbolScope, scopeByNode: ScopeByNode) {
    self.top = top
    self.scopeByNode = scopeByNode
  }
}
