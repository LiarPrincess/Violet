import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable function_body_length

extension Compiler {

  // MARK: - Raise

  /// compiler_visit_stmt(struct compiler *c, stmt_ty s)
  internal func visitRaise(exception: Expression?,
                           cause:     Expression?,
                           location:  SourceLocation) throws {
    var arg = RaiseArg.reRaise
    if let exc = exception {
      try self.visitExpression(exc)
      arg = .exceptionOnly

      if let c = cause {
        try self.visitExpression(c)
        arg = .exceptionAndCause
      }
    }

    try self.codeObject.emitRaiseVarargs(arg: arg, location: location)
  }

  // MARK: - Try

  internal func visitTry(body: NonEmptyArray<Statement>,
                         handlers: [ExceptHandler],
                         orElse: [Statement],
                         finalBody: [Statement],
                         location: SourceLocation) throws {
    if finalBody.any {
      try self.visitTryFinally(body: body,
                               handlers: handlers,
                               orElse: orElse,
                               finalBody: finalBody,
                               location: location)
    } else {
      try self.visitTryExcept(body: body,
                              handlers: handlers,
                              orElse: orElse,
                              location: location)
    }
  }

  ///compiler_try_finally(struct compiler *c, stmt_ty s)
  ///
  /// Code generated for "try: <body> finally: <finalbody>" is as follows:
  ///
  ///       SETUP_FINALLY           Label
  ///       <code for body>
  ///       POP_BLOCK
  ///       LOAD_CONST              <None>
  ///   Label:   <code for finalbody>
  ///       END_FINALLY
  ///
  /// SETUP_FINALLY:
  ///   Pushes the current value stack level and the label
  ///   onto the block stack.
  /// POP_BLOCK:
  ///   Pops en entry from the block stack, and pops the value
  ///   stack until its level is the same as indicated on the
  ///   block stack.  (The label is ignored.)
  /// END_FINALLY:
  ///   Pops a variable number of entries from the *value* stack
  ///   and re-raises the exception they specify.  The number of
  ///   entries popped depends on the (pseudo) exception type.
  ///
  ///   The block stack is unwound when an exception is raised:
  ///   when a SETUP_FINALLY entry is found, the exception is pushed
  ///   onto the value stack (and the exception condition is cleared),
  ///   and the interpreter jumps to the label gotten from the block
  ///   stack.
  private func visitTryFinally(body: NonEmptyArray<Statement>,
                               handlers:  [ExceptHandler],
                               orElse:    [Statement],
                               finalBody: [Statement],
                               location:  SourceLocation) throws {
    let finallyStart = self.codeObject.addLabel()
    // TODO: Rename 'finalBody' -> 'finally'

    // body
    try self.codeObject.emitSetupFinally(firstInstruction: finallyStart,
                                         location: location)
    try self.inBlock(.finallyTry) {
      if handlers.any {
        try self.visitTryExcept(body: body,
                                handlers: handlers,
                                orElse:   orElse,
                                location: location)
      } else {
        try self.visitStatements(body)
      }

      try self.codeObject.emitPopTop(location: location)
    }

    try self.codeObject.emitNone(location: location)

    // finally
    self.codeObject.setLabel(finallyStart)
    try self.inBlock(.finallyEnd) {
      try self.visitStatements(finalBody)
      try self.codeObject.emitEndFinally(location: location)
    }
  }

  /// compiler_try_except(struct compiler *c, stmt_ty s)
  ///
  /// Code generated for "try: S except E1 as V1: S1 except E2 as V2: S2 ...":
  /// (The contents of the value stack is shown in [], with the top
  /// at the right; 'tb' is trace-back info, 'val' the exception's
  /// associated value, and 'exc' the exception.)
  ///
  /// Value stack          Label   Instruction     Argument
  /// []                           SETUP_EXCEPT    L1
  /// []                           <code for S>
  /// []                           POP_BLOCK
  /// []                           JUMP_FORWARD    L0
  ///
  /// [tb, val, exc]       L1:     DUP                             )
  /// [tb, val, exc, exc]          <evaluate E1>                   )
  /// [tb, val, exc, exc, E1]      COMPARE_OP      EXC_MATCH       ) only if E1
  /// [tb, val, exc, 1-or-0]       POP_JUMP_IF_FALSE       L2      )
  /// [tb, val, exc]               POP
  /// [tb, val]                    <assign to V1>  (or POP if no V1)
  /// [tb]                         POP
  /// []                           <code for S1>
  ///                             JUMP_FORWARD    L0
  ///
  /// [tb, val, exc]       L2:     DUP
  /// .............................etc.......................
  ///
  /// [tb, val, exc]       Ln+1:   END_FINALLY     # re-raise exception
  ///
  /// []                   L0:     <next statement>
  ///
  /// Of course, parts are not generated if Vi or Ei is not present.
  private func visitTryExcept(body: NonEmptyArray<Statement>,
                              handlers: [ExceptHandler],
                              orElse:   [Statement],
                              location: SourceLocation) throws {
    let firstExcept = self.codeObject.addLabel()
    let orElseStart = self.codeObject.addLabel()
    let end = self.codeObject.addLabel()

    // body
    try self.codeObject.emitSetupExcept(firstExcept: firstExcept, location: location)
    try self.inBlock(.except) {
      try self.visitStatements(body)
      try self.codeObject.emitPopBlock(location: location)
    }
    // if no exception happened then go to 'orElse'
    try self.codeObject.emitJumpAbsolute(to: orElseStart, location: location)

    // except
    self.codeObject.setLabel(firstExcept)
    for (index, handler) in handlers.enumerated() {
      // TODO: ExceptHandler should be sum type default|normal
      let isDefault = handler.type == nil
      let isLast = index == handlers.count - 1
      if isDefault && !isLast {
        // default 'except:' must be last
        fatalError()
      }

      let nextExcept = self.codeObject.addLabel()

      if let type = handler.type {
        try self.codeObject.emitDupTop(location: location)
        try self.visitExpression(type)
        try self.codeObject.emitCompareOp(.exceptionMatch, location: location)
        try self.codeObject.emitPopJumpIfFalse(to: nextExcept, location: location)
      }
      try self.codeObject.emitPopTop(location: location)

      if let name = handler.name {
        try self.codeObject.emitStoreName(name: name, location: location)
        try self.codeObject.emitPopTop(location: location)

        // try:
        //     # body
        // except type as name:
        //     try:
        //         # body
        //     finally:
        //         name = None
        //         del name

        // second try:
        let cleanupEnd = self.codeObject.addLabel()
        try self.codeObject.emitSetupFinally(firstInstruction: cleanupEnd, location: location)
        try self.inBlock(.finallyTry) {
          try self.visitStatements(handler.body)
          try self.codeObject.emitPopBlock(location: location)
        }

        // finally:
        try self.codeObject.emitNone(location: location)
        self.codeObject.setLabel(cleanupEnd)

        try self.inBlock(.finallyEnd) {
          // name = None
          try self.codeObject.emitNone(location: location)
          try self.codeObject.emitStoreName(name: name, location: location)
          // del name
          try self.codeObject.emitDeleteName(name: name, location: location)
          // cleanup
          try self.codeObject.emitEndFinally(location: location)
          try self.codeObject.emitPopExcept(location: location)
        }
      } else {
        try self.codeObject.emitPopTop(location: location)
        try self.codeObject.emitPopTop(location: location)

        try self.inBlock(.finallyTry) {
          try self.visitStatements(handler.body)
          try self.codeObject.emitPopExcept(location: location)
        }
      }

      try self.codeObject.emitJumpAbsolute(to: end, location: location)
      self.codeObject.setLabel(nextExcept)
    }

    try self.codeObject.emitEndFinally(location: location)
    self.codeObject.setLabel(orElseStart)
    try self.visitStatements(orElse)
    self.codeObject.setLabel(end)
  }
}
