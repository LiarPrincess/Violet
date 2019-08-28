import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

public final class Compiler {

  internal var blocksStack = [CodeObject]()

  /// Code object that we are currently filling (top of the `self.blocksStack`).
  internal var currentBlock: CodeObject {
    _read {
//      assert(self.codeObjectStack.any)
//      yield self.codeObjectStack[self.codeObjectStack.count - 1]
      fatalError()
    }
    _modify {
//      assert(self.codeObjectStack.any)
//      yield &self.codeObjectStack[self.codeObjectStack.count - 1]
      fatalError()
    }
  }

  // TODO: Merge symbolTable and scope to code unit
  internal var symbolTable: SymbolTable!

  internal var scopeStack = [SymbolScope]()

  internal var currentScope: SymbolScope {
    fatalError()
  }

//  internal var isInLoop = false
//  internal var isInFunctionDef = false

//  internal var currentSourceLocation: SourceLocation = .start
//  internal var currentQualifiedPath: String?

  /// Optimization level
  internal let optimize: Bool

  public init(optimize: Bool) {
    self.optimize = optimize
  }

  /// PyAST_CompileObject(mod_ty mod, PyObject *filename, PyCompilerFlags ...)
  /// compiler_mod(struct compiler *c, mod_ty mod)
  public func compileObject(ast: AST) throws -> CodeObject {
    // TODO: Clean previous flags
    // TODO: Special identifiers

    let symbolTableBuilder = SymbolTableBuilder()
    self.symbolTable = try symbolTableBuilder.visit(ast)

    self.enterScope(node: ast)

    switch ast.kind {
    case let .single(stmts):
      break
    case let .fileInput(stmts):
      break
    case let .expression(expr):
      break
    }

    // TODO: Emit nop. because it may be an jump target!

    assert(self.blocksStack.count == 1)
    return self.currentBlock
  }

  // MARK: - Code object

  internal func pushCodeObject(name: String) {
//    let line_number = self.get_source_line_number();
//    self.code_object_stack.push(CodeObject::new(
//      Vec::new(),
//      Varargs::None,
//      Vec::new(),
//      Varargs::None,
//      self.source_path.clone().unwrap(),
//      line_number,
//      obj_name,
//    ));
  }

  internal func popCodeObject() {
    // self.code_object_stack.pop().unwrap()
  }

  // MARK: - Scope

  /// compiler_enter_scope(struct compiler *c, identifier name, ...)
  internal func enterScope<N: ASTNode>(node: N) {
    guard let scope = self.symbolTable.scopeByNode[node] else {
      fatalError()
    }
    self.scopeStack.push(scope)
  }

  internal func leaveScope() {
    assert(self.scopeStack.any)
    self.scopeStack.popLast()
  }

  internal func lookupName(name: MangledName) -> SymbolInfo {
    return self.currentScope.symbols[name]!
  }

  // MARK: - Labels

  private var nextLabel: UInt16 = 0

  internal func newLabel() throws -> Label {
    let index = self.currentBlock.labels.endIndex
    self.currentBlock.labels.append(0)
    return Label(index: index)
  }

  internal func setLabel(_ label: Label) {
    let jumpTarget = self.currentBlock.instructions.count

    guard let exact = UInt32(exactly: jumpTarget) else {
      fatalError()
    }

    self.currentBlock.labels[label.index] = exact
  }

  // MARK: - Qualified name

//  internal func createQualifiedName() {
//    if let Some(ref qualified_path) = self.current_qualified_path {
//      format!("{}.{}{}", qualified_path, name, suffix)
//    } else {
//      format!("{}{}", name, suffix)
//    }
//  }
}
