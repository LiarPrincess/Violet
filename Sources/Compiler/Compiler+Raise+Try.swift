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

    try self.codeObject.appendRaiseVarargs(arg: arg, at: location)
  }

  // MARK: - Try

  internal func visitTry(body: NonEmptyArray<Statement>,
                         handlers: [ExceptHandler],
                         orElse:   [Statement],
                         finally:  [Statement],
                         location: SourceLocation) throws {
    if finally.any {
      try self.visitTryFinally(body: body,
                               handlers: handlers,
                               orElse:   orElse,
                               finally:  finally,
                               location:  location)
    } else {
      try self.visitTryExcept(body: body,
                              handlers: handlers,
                              orElse:   orElse,
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
                               handlers: [ExceptHandler],
                               orElse:   [Statement],
                               finally:  [Statement],
                               location: SourceLocation) throws {
    let finallyStart = self.codeObject.createLabel()

    // body
    try self.codeObject.appendSetupFinally(finallyStart: finallyStart, at: location)
    try self.inBlock(.finallyTry) {
      if handlers.any {
        try self.visitTryExcept(body: body,
                                handlers: handlers,
                                orElse:   orElse,
                                location: location)
      } else {
        try self.visitStatements(body)
      }

      try self.codeObject.appendPopBlock(at: location)
    }

    try self.codeObject.appendNone(at: location)

    // finally
    self.codeObject.setLabel(finallyStart)
    try self.inBlock(.finallyEnd) {
      try self.visitStatements(finally)
      try self.codeObject.appendEndFinally(at: location)
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
    let firstExcept = self.codeObject.createLabel()
    let orElseStart = self.codeObject.createLabel()
    let end = self.codeObject.createLabel()

    // body
    try self.codeObject.appendSetupExcept(firstExcept: firstExcept, at: location)
    try self.inBlock(.except) {
      try self.visitStatements(body)
      try self.codeObject.appendPopBlock(at: location)
    }
    // if no exception happened then go to 'orElse'
    try self.codeObject.appendJumpAbsolute(to: orElseStart, at: location)

    // except
    self.codeObject.setLabel(firstExcept)
    for (index, handler) in handlers.enumerated() {
      // TODO: AST: ExceptHandler should be sum type default|normal
      let isDefault = handler.type == nil
      let isLast = index == handlers.count - 1
      if isDefault && !isLast {
        throw self.error(.defaultExceptNotLast, location: location)
      }

      let nextExcept = self.codeObject.createLabel()

      if let type = handler.type {
        try self.codeObject.appendDupTop(at: location)
        try self.visitExpression(type)
        try self.codeObject.appendCompareOp(.exceptionMatch, at: location)
        try self.codeObject.appendPopJumpIfFalse(to: nextExcept, at: location)
      }
      try self.codeObject.appendPopTop(at: location)

      if let name = handler.name {
        try self.codeObject.appendStoreName(name, at: location)
        try self.codeObject.appendPopTop(at: location)

        // try:
        //     # body
        // except type as name:
        //     try:
        //         # body
        //     finally:
        //         name = None
        //         del name

        // second try:
        let cleanupEnd = self.codeObject.createLabel()
        try self.codeObject.appendSetupFinally(finallyStart: cleanupEnd, at: location)
        try self.inBlock(.finallyTry) {
          try self.visitStatements(handler.body)
          try self.codeObject.appendPopBlock(at: location)
        }

        // finally:
        try self.codeObject.appendNone(at: location)
        self.codeObject.setLabel(cleanupEnd)

        try self.inBlock(.finallyEnd) {
          // name = None
          try self.codeObject.appendNone(at: location)
          try self.codeObject.appendStoreName(name, at: location)
          // del name
          try self.codeObject.appendDeleteName(name, at: location)
          // cleanup
          try self.codeObject.appendEndFinally(at: location)
          try self.codeObject.appendPopExcept(at: location)
        }
      } else {
        try self.codeObject.appendPopTop(at: location)
        try self.codeObject.appendPopTop(at: location)

        try self.inBlock(.finallyTry) {
          try self.visitStatements(handler.body)
          try self.codeObject.appendPopExcept(at: location)
        }
      }

      try self.codeObject.appendJumpAbsolute(to: end, at: location)
      self.codeObject.setLabel(nextExcept)
    }

    try self.codeObject.appendEndFinally(at: location)
    self.codeObject.setLabel(orElseStart)
    try self.visitStatements(orElse)
    self.codeObject.setLabel(end)
  }
}
