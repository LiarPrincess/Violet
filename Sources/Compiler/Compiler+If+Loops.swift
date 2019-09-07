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
    // TODO: CPython: constant = expr_constant(s->v.If.test);
    let endLabel = self.codeObject.addLabel()
    let orElseLabel = orElse.any ? self.codeObject.addLabel() : endLabel

    try self.visitExpression(test,
                             andJumpTo: orElseLabel,
                             ifBooleanValueIs: false,
                             location: location)

    try self.visitStatements(body)
    if orElse.any {
      try self.codeObject.emitJumpAbsolute(to: endLabel, location: location)
      self.codeObject.setLabelToNextInstruction(orElseLabel)
      try self.visitStatements(orElse)
    }

    self.codeObject.setLabelToNextInstruction(endLabel)
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
    let startLabel   = self.codeObject.addLabel()
    let cleanupLabel = self.codeObject.addLabel()
    let endLabel     = self.codeObject.addLabel()

    try self.codeObject.emitSetupLoop(loopEnd: endLabel, location: location)

    // 'continue' will jump to 'startLabel'
    try self.inBlock(.loop(startLabel: startLabel)) {
      try self.visitExpression(iter)
      try self.codeObject.emitGetIter(location: location)

      self.codeObject.setLabelToNextInstruction(startLabel)
      try self.codeObject.emitForIter(ifEmpty: cleanupLabel, location: location)
      try self.visitExpression(target)
      try self.visitStatements(body)
      try self.codeObject.emitJumpAbsolute(to: startLabel, location: location)

      self.codeObject.setLabelToNextInstruction(cleanupLabel)
      try self.codeObject.emitPopBlock(location: location)
    }

    try self.visitStatements(orElse)
    self.codeObject.setLabelToNextInstruction(endLabel)
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
    // TODO: CPython: constant = expr_constant(s->v.If.test);
    let startLabel = self.codeObject.addLabel()
    let endLabel   = self.codeObject.addLabel()
    let afterBodyLabel = self.codeObject.addLabel() // CPython: anchor

    try self.codeObject.emitSetupLoop(loopEnd: endLabel, location: location)

    self.codeObject.setLabelToNextInstruction(startLabel)

    // 'continue' will jump to 'startLabel'
    try self.inBlock(.loop(startLabel: startLabel)) {
      try self.visitExpression(test,
                               andJumpTo: afterBodyLabel,
                               ifBooleanValueIs: false,
                               location: location)

      try self.visitStatements(body)
      try self.codeObject.emitJumpAbsolute(to: startLabel, location: location)

      self.codeObject.setLabelToNextInstruction(afterBodyLabel)
      try self.codeObject.emitPopBlock(location: location)
    }

    try self.visitStatements(orElse)
    self.codeObject.setLabelToNextInstruction(endLabel)
  }

  // MARK: - Continue, break

  /// compiler_continue(struct compiler *c)
  internal func visitContinue(location: SourceLocation) throws {
    guard let blockType = self.blockStack.last else {
      throw self.error(.continueOutsideLoop, location: location)
    }

    switch blockType {
    case let .loop(startLabel):
      try self.codeObject.emitJumpAbsolute(to: startLabel, location: location)
    case .except:
      break
    case .finallyTry:
      break
    case .finallyEnd:
      throw self.error(.continueInsideFinally, location: location)
    }
  }

  /// compiler_visit_stmt(struct compiler *c, stmt_ty s)
  internal func visitBreak(location: SourceLocation) throws {
    if !self.isInLoop {
      throw self.error(.breakOutsideLoop, location: location)
    }

    try self.codeObject.emitBreak(location: location)
  }
}
