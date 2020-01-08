import Core
import Bytecode
import Parser

// In CPython:
// Include -> symtable.h

public final class SymbolTable {

  /// Top scope in symbol table, corresponds to top scope in AST.
  public let top: SymbolScope

  /// All of the scopes by their corresponding AST node.
  public let scopeByNode: ScopeByNodeDictionary

  // CPython also contains 'st_global' (for 'borrowed ref to st_top->ste_symbols'),
  // but AFAIK it is not used anywhere.

  // `internal` so, that we can't instantiate it outside of this module.
  internal init(top: SymbolScope, scopeByNode: ScopeByNodeDictionary) {
    self.top = top
    self.scopeByNode = scopeByNode
  }
}

/// Mapping from ASTNode to Symbol scope.
/// Returns `nil` if no scope is associated with given node.
public struct ScopeByNodeDictionary {

  // We can't use `Node` as key because it as an protocol.
  private var inner = [ASTNodeId:SymbolScope]()

  // `internal` so, that we can't instantiate it outside of this module.
  internal init() { }

  public internal(set) subscript<N: ASTNode>(key: N) -> SymbolScope? {
    get { return self.get(key) }
    set { self.insert(key, value: newValue) }
  }

  public func get<N: ASTNode>(_ key: N) -> SymbolScope? {
    return self.inner[key.id]
  }

  internal mutating func insert<N: ASTNode>(_ key: N, value: SymbolScope?) {
    self.inner[key.id] = value
  }
}
