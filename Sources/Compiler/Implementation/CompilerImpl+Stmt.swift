import Foundation
import VioletCore
import VioletParser
import VioletBytecode

// In CPython:
// Python -> compile.c

extension CompilerImpl {

  /// compiler_visit_stmt(struct compiler *c, stmt_ty s)

  internal func visit(_ node: Statement) throws {
    self.setAppendLocation(node)
    try node.accept(self)
  }

  /// compiler_visit_stmt(struct compiler *c, stmt_ty s)
  internal func visit<S: Sequence>(_ stmts: S) throws where S.Element == Statement {
    for s in stmts {
      try self.visit(s)
    }
  }

  // MARK: - For

  /// compiler_for(struct compiler *c, stmt_ty s)
  ///
  /// This is also useful:
  /// https://docs.python.org/3.7/tutorial/controlflow.html
  ///
  /// ```c
  /// dis.dis('''
  /// for a in b: c
  /// else: d
  /// ''')
  /// ```
  /// gives us:
  ///
  /// ```c
  ///  0 SETUP_LOOP              20 (to 22)
  ///  2 LOAD_NAME                0 (b)
  ///  4 GET_ITER
  ///  6 FOR_ITER                 8 (to 16)
  ///  8 STORE_NAME               1 (a)
  /// 10 LOAD_NAME                2 (c)
  /// 12 POP_TOP
  /// 14 JUMP_ABSOLUTE            6
  /// 16 POP_BLOCK
  ///
  /// 18 LOAD_NAME                3 (d)
  /// 20 POP_TOP
  /// 22 LOAD_CONST               0 (None)
  /// 24 RETURN_VALUE
  /// ```
  internal func visit(_ node: ForStmt) throws {
    let iterationStart = self.builder.createLabel()
    let cleanup = self.builder.createLabel()
    let end = self.builder.createLabel()

    self.builder.appendSetupLoop(loopEnd: end)

    // 'continue' will jump to 'startLabel'
    try self.inBlock(.loop(continueTarget: iterationStart)) {
      try self.visit(node.iterable)
      self.builder.appendGetIter()

      self.builder.setLabel(iterationStart)
      self.builder.appendForIter(ifEmpty: cleanup)
      try self.visit(node.target)
      try self.visit(node.body)
      self.builder.appendJumpAbsolute(to: iterationStart)

      self.builder.setLabel(cleanup)
      self.builder.appendPopBlock()
    }

    try self.visit(node.orElse)
    self.builder.setLabel(end)
  }

  // MARK: - While

  /// compiler_while(struct compiler *c, stmt_ty s)
  ///
  /// This is also useful:
  /// https://docs.python.org/3.7/tutorial/controlflow.html
  ///
  /// ```c
  /// dis.dis('''
  /// while a: b
  /// else: c
  /// ''')
  /// ```
  /// gives us:
  ///
  /// ```c
  ///  0 SETUP_LOOP              16 (to 18)
  ///  2 LOAD_NAME                0 (a)
  ///  4 POP_JUMP_IF_FALSE       12
  ///  6 LOAD_NAME                1 (b)
  ///  8 POP_TOP
  /// 10 JUMP_ABSOLUTE            2
  /// 12 POP_BLOCK
  ///
  /// 14 LOAD_NAME                2 (c)
  /// 16 POP_TOP
  /// 18 LOAD_CONST               0 (None)
  /// 20 RETURN_VALUE
  /// ```
  internal func visit(_ node: WhileStmt) throws {
    let iterationStart = self.builder.createLabel()
    let cleanup = self.builder.createLabel()
    let end = self.builder.createLabel()

    self.builder.appendSetupLoop(loopEnd: end)
    self.builder.setLabel(iterationStart)

    // 'continue' will jump to 'startLabel'
    try self.inBlock(.loop(continueTarget: iterationStart)) {
      try self.visit(node.test, andJumpTo: cleanup, ifBooleanValueIs: false)
      try self.visit(node.body)
      self.builder.appendJumpAbsolute(to: iterationStart)

      self.builder.setLabel(cleanup)
      self.builder.appendPopBlock()
    }

    try self.visit(node.orElse)
    self.builder.setLabel(end)
  }

  // MARK: - If

  /// compiler_if(struct compiler *c, stmt_ty s)
  ///
  /// This is also useful:
  /// https://docs.python.org/3.7/tutorial/controlflow.html
  ///
  /// ```c
  /// dis.dis('''
  /// if a: b
  /// else: c
  /// ''')
  /// ```
  /// gives us:
  ///
  /// ```c
  ///  0 LOAD_NAME                0 (a)
  ///  2 POP_JUMP_IF_FALSE       10
  ///  4 LOAD_NAME                1 (b)
  ///  6 POP_TOP
  ///  8 JUMP_FORWARD             4 (to 14)
  ///
  /// 10 LOAD_NAME                2 (c)
  /// 12 POP_TOP
  /// 14 LOAD_CONST               0 (None)
  /// 16 RETURN_VALUE
  /// ```
  internal func visit(_ node: IfStmt) throws {
    let end = self.builder.createLabel()
    let orElseStart = node.orElse.any ? self.builder.createLabel() : end

    try self.visit(node.test, andJumpTo: orElseStart, ifBooleanValueIs: false)
    try self.visit(node.body)

    if node.orElse.any {
      self.builder.appendJumpAbsolute(to: end)
      self.builder.setLabel(orElseStart)
      try self.visit(node.orElse)
    }

    self.builder.setLabel(end)
  }

  // MARK: - With

  /// compiler_with(struct compiler *c, stmt_ty s, int pos)
  ///
  /// ```
  /// with EXPR as VAR:
  ///     BLOCK
  /// ```
  /// It is implemented roughly as:
  /// ```c
  /// context = EXPR
  /// exit = context.__exit__  # not calling it
  /// value = context.__enter__()
  /// try:
  ///     VAR = value  # if VAR present in the syntax
  ///     BLOCK
  /// finally:
  ///     if an exception was raised:
  ///         exc = copy of (exception, instance, traceback)
  ///     else:
  ///         exc = (None, None, None)
  ///     exit(*exc)
  /// ```
  internal func visit(_ node: WithStmt) throws {
    try self.visitWith(items: node.items, body: node.body, index: 0)
  }

  /// compiler_with(struct compiler *c, stmt_ty s, int pos)
  ///
  /// ```c
  /// dis.dis('''
  /// with a as b:
  ///   c
  /// ''')
  /// ```
  /// gives us:
  ///
  /// ```c
  ///  0 LOAD_NAME                0 (a)
  ///  2 SETUP_WITH              10 (to 14)
  ///  4 STORE_NAME               1 (b)
  ///
  ///  6 LOAD_NAME                2 (c)
  ///  8 POP_TOP
  /// 10 POP_BLOCK
  /// 12 LOAD_CONST               0 (None)
  /// 14 WITH_CLEANUP_START
  /// 16 WITH_CLEANUP_FINISH
  /// 18 END_FINALLY
  /// 20 LOAD_CONST               0 (None)
  /// 22 RETURN_VALUE
  /// ```
  private func visitWith(items: NonEmptyArray<WithItem>,
                         body: NonEmptyArray<Statement>,
                         index: Int) throws {
    let item = items[index]
    let afterBody = self.builder.createLabel()

    // Evaluate EXPR
    try self.visit(item.contextExpr)
    self.builder.appendSetupWith(afterBody: afterBody)

    // SETUP_WITH pushes a finally block.
    try self.inBlock(.finallyTry) {
      if let opt = item.optionalVars {
        try self.visit(opt)
      } else {
        // Discard result from context.__enter__()
        self.builder.appendPopTop()
      }

      let nextIndex = index + 1
      if nextIndex == items.count {
        // BLOCK code
        try self.visit(body)
      } else {
        try self.visitWith(items: items, body: body, index: nextIndex)
      }

      // End of try block; start the finally block
      self.builder.appendPopBlock()
    }

    self.builder.appendNone()
    self.builder.setLabel(afterBody)

    self.inBlock(.finallyEnd) {
      // Finally block starts; context.__exit__ is on the stack under
      // the exception or return information. Just issue our magic opcode.
      self.builder.appendWithCleanupStart()
      self.builder.appendWithCleanupFinish()

      // Finally block ends.
      self.builder.appendEndFinally()
    }
  }

  // MARK: - Expression statement

  /// compiler_visit_stmt_expr(struct compiler *c, expr_ty value)
  internal func visit(_ node: ExprStmt) throws {
    if self.isInteractive && self.nestLevel <= 1 {
      try self.visit(node.expression)
      self.builder.appendPrintExpr()
      return
    }

    try self.visit(node.expression)
    self.builder.appendPopTop()
  }

  // MARK: - Assert

  /// compiler_assert(struct compiler *c, stmt_ty s)
  internal func visit(_ node: AssertStmt) throws {
    guard self.options.optimizationLevel == .none else {
      return
    }

    if let tuple = node.test as? TupleExpr, tuple.elements.any {
      self.warn(.assertionWithTuple)
    }

    let end = self.builder.createLabel()
    try self.visit(node.test, andJumpTo: end, ifBooleanValueIs: true)
    self.builder.appendLoadGlobal(SpecialIdentifiers.assertionErrorTypeName)

    if let message = node.msg {
      // Call 'AssertionError' with single argument
      try self.visit(message)
      self.builder.appendCallFunction(argumentCount: 1)
    }

    self.builder.appendRaiseVarargs(arg: .exceptionOnly)
    self.builder.setLabel(end)
  }

  // MARK: - Continue

  /// compiler_continue(struct compiler *c)
  ///
  /// This is also useful:
  /// https://docs.python.org/3.7/tutorial/controlflow.html
  internal func visit(_ node: ContinueStmt) throws {
    guard let blockType = self.blockStack.last else {
      throw self.error(.continueOutsideLoop)
    }

    switch blockType {
    case let .loop(continueTarget):
      // If 'continue' is directly in loop then we can just jump.
      self.builder.appendJumpAbsolute(to: continueTarget)

    case .except,
         .finallyTry:
      let blocksWithoutAlreadyChecked = self.blockStack.dropLast()

      // Try to find the previous loop.
      for block in blocksWithoutAlreadyChecked.reversed() {
        switch block {
        case .loop(let continueTarget):
          // If 'continue' is nested inside 'except' or 'finally',
          // then we have to unwind that block first.
          // For this we have separate 'continue' instruction.
          self.builder.appendContinue(loopStartLabel: continueTarget)
          return

        case .except,
             .finallyTry:
          break // ignore

        case .finallyEnd:
          throw self.error(.continueInsideFinally)
        }
      }

      throw self.error(.continueOutsideLoop)

    case .finallyEnd:
      throw self.error(.continueInsideFinally)
    }
  }

  // MARK: - Break

  /// compiler_visit_stmt(struct compiler *c, stmt_ty s)
  ///
  /// This is also useful:
  /// https://docs.python.org/3.7/tutorial/controlflow.html
  internal func visit(_ node: BreakStmt) throws {
    if !self.isInLoop {
      throw self.error(.breakOutsideLoop)
    }

    self.builder.appendBreak()
  }

  // MARK: - Return

  /// compiler_visit_stmt(struct compiler *c, stmt_ty s)
  internal func visit(_ node: ReturnStmt) throws {
    guard self.currentScope.kind.isFunctionLambdaComprehension else {
      throw self.error(.returnOutsideFunction)
    }

    if let v = node.value {
      if self.currentScope.isCoroutine || self.currentScope.isGenerator {
        throw self.error(.returnWithValueInAsyncGenerator)
      }

      try self.visit(v)
    } else {
      self.builder.appendNone()
    }

    self.builder.appendReturn()
  }

  // MARK: - Delete

  internal func visit(_ node: DeleteStmt) throws {
    try self.visit(node.values)
  }

  // MARK: - Pass

  internal func visit(_ node: PassStmt) throws {}

  // MARK: - Global, nonlocal

  internal func visit(_ node: GlobalStmt) throws {
    // This will be taken from symbol table when emitting expressions.
  }

  internal func visit(_ node: NonlocalStmt) throws {
    // This will be taken from symbol table when emitting expressions.
  }
}
