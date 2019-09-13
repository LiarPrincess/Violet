import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

// This is also usefull:
// https://docs.python.org/3.7/tutorial/controlflow.html

extension Compiler {

  // MARK: - If

  /// compiler_if(struct compiler *c, stmt_ty s)
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
  internal func visitIf(test:   Expression,
                        body:   NonEmptyArray<Statement>,
                        orElse: [Statement],
                        location: SourceLocation) throws {
    let end = self.builder.createLabel()
    let orElseStart = orElse.any ? self.builder.createLabel() : end

    try self.visitExpression(test,
                             andJumpTo: orElseStart,
                             ifBooleanValueIs: false,
                             location: location)

    try self.visitStatements(body)

    if orElse.any {
      try self.builder.appendJumpAbsolute(to: end, at: location)
      self.builder.setLabel(orElseStart)
      try self.visitStatements(orElse)
    }

    self.builder.setLabel(end)
  }

  // MARK: - For

  /// compiler_for(struct compiler *c, stmt_ty s)
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
  internal func visitFor(target: Expression,
                         iter:   Expression,
                         body:   NonEmptyArray<Statement>,
                         orElse: [Statement],
                         location: SourceLocation) throws {

    let iterationStart = self.builder.createLabel()
    let cleanup = self.builder.createLabel()
    let end = self.builder.createLabel()

    try self.builder.appendSetupLoop(loopEnd: end, at: location)

    // 'continue' will jump to 'startLabel'
    try self.inBlock(.loop(continueTarget: iterationStart)) {
      try self.visitExpression(iter)
      try self.builder.appendGetIter(at: location)

      self.builder.setLabel(iterationStart)
      try self.builder.appendForIter(ifEmpty: cleanup, at: location)
      try self.visitExpression(target, context: .store)
      try self.visitStatements(body)
      try self.builder.appendJumpAbsolute(to: iterationStart, at: location)

      self.builder.setLabel(cleanup)
      try self.builder.appendPopBlock(at: location)
    }

    try self.visitStatements(orElse)
    self.builder.setLabel(end)
  }

  // MARK: - While

  /// compiler_while(struct compiler *c, stmt_ty s)
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
  internal func visitWhile(test:   Expression,
                           body:   NonEmptyArray<Statement>,
                           orElse: [Statement],
                           location: SourceLocation) throws {

    let iterationStart = self.builder.createLabel()
    let cleanup = self.builder.createLabel()
    let end = self.builder.createLabel()

    try self.builder.appendSetupLoop(loopEnd: end, at: location)

    self.builder.setLabel(iterationStart)

    // 'continue' will jump to 'startLabel'
    try self.inBlock(.loop(continueTarget: iterationStart)) {
      try self.visitExpression(test,
                               andJumpTo: cleanup,
                               ifBooleanValueIs: false,
                               location: location)

      try self.visitStatements(body)
      try self.builder.appendJumpAbsolute(to: iterationStart, at: location)

      self.builder.setLabel(cleanup)
      try self.builder.appendPopBlock(at: location)
    }

    try self.visitStatements(orElse)
    self.builder.setLabel(end)
  }

  // MARK: - Continue, break

  /// compiler_continue(struct compiler *c)
  internal func visitContinue(location: SourceLocation) throws {
    guard let blockType = self.blockStack.last else {
      throw self.error(.continueOutsideLoop, location: location)
    }

    switch blockType {
    case let .loop(continueTarget):
      try self.builder.appendJumpAbsolute(to: continueTarget, at: location)
    case .except,
         .finallyTry:
      // Try to find the previous loop.
      for block in self.blockStack.reversed() {
        switch block {
        case let .loop(continueTarget):
          try self.builder.appendJumpAbsolute(to: continueTarget, at: location)
          return
        case .except,
             .finallyTry:
          break
        case .finallyEnd:
          throw self.error(.continueInsideFinally, location: location)
        }
      }
    case .finallyEnd:
      throw self.error(.continueInsideFinally, location: location)
    }
  }

  /// compiler_visit_stmt(struct compiler *c, stmt_ty s)
  internal func visitBreak(location: SourceLocation) throws {
    if !self.isInLoop {
      throw self.error(.breakOutsideLoop, location: location)
    }

    try self.builder.appendBreak(at: location)
  }
}
