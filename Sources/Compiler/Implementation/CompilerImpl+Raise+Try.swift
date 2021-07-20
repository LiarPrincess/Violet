import Foundation
import VioletCore
import VioletParser
import VioletBytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable function_body_length

extension CompilerImpl {

  // MARK: - Raise

  /// compiler_visit_stmt(struct compiler *c, stmt_ty s)
  internal func visit(_ node: RaiseStmt) throws {
    var arg = Instruction.RaiseArg.reRaise

    if let exception = node.exception {
      try self.visit(exception)
      arg = .exceptionOnly

      if let cause = node.cause {
        try self.visit(cause)
        arg = .exceptionAndCause
      }
    }

    self.builder.appendRaiseVarargs(arg: arg)
  }

  // MARK: - Try

  internal func visit(_ node: TryStmt) throws {
    if node.finally.any {
      try self.visitTryFinally(body: node.body,
                               handlers: node.handlers,
                               orElse: node.orElse,
                               finally: node.finally)
    } else {
      try self.visitTryExcept(body: node.body,
                              handlers: node.handlers,
                              orElse: node.orElse)
    }
  }

  /// compiler_try_finally(struct compiler *c, stmt_ty s)
  ///
  /// Code generated for "try: <body> finally: <finalBody>" is as follows:
  ///
  ///       SETUP_FINALLY           Label
  ///       <code for body>
  ///       POP_BLOCK
  ///       LOAD_CONST              <None>
  ///   Label:   <code for finalBody>
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
                               orElse: [Statement],
                               finally: [Statement]) throws {
    let finallyStart = self.builder.createLabel()

    // body
    self.builder.appendSetupFinally(finallyStart: finallyStart)
    try self.inBlock(.finallyTry) {
      if handlers.any {
        try self.visitTryExcept(body: body, handlers: handlers, orElse: orElse)
      } else {
        try self.visit(body)
      }

      self.builder.appendPopBlock()
    }

    self.builder.appendNone()

    // finally
    self.builder.setLabel(finallyStart)
    try self.inBlock(.finallyEnd) {
      try self.visit(finally)
      self.builder.appendEndFinally()
    }
  }

  /// compiler_try_except(struct compiler *c, stmt_ty s)
  ///
  /// NOTE THAT THERE IS A DIFFERENCE BETWEEN US AND CPYTHON.
  /// We store only exception on stack and CPython stores type, exception
  /// and traceback. So where CPython does 3x 'pop' we do it once!
  ///
  /// Code generated for "try: S except E1 as V1: S1 except E2 as V2: S2 ...":
  /// (The contents of the value stack is shown in [], with the top at the right)
  ///
  /// ```
  /// Value stack          Label   Instruction     Argument
  /// []                           SETUP_EXCEPT    L1
  /// []                           <code for S>
  /// []                           POP_BLOCK
  /// []                           JUMP_FORWARD    L0 # go to next statement
  ///
  /// [exc]                L1:     DUP                             )
  /// [exc, exc]                   <evaluate E1>                   )
  /// [exc, exc, E1]               COMPARE_OP      EXC_MATCH       ) only if E1
  /// [exc, 1-or-0]                POP_JUMP_IF_FALSE       L2      )
  /// []                           <assign to V1>  (or POP if no V1)
  /// []                           <code for S1>
  ///                              JUMP_FORWARD    L0
  ///
  /// [exc]                L2:     DUP # another except
  /// .............................etc.......................
  ///
  /// [exc]                Ln+1:   END_FINALLY     # re-raise exception
  ///
  /// []                   L0:     # next statement
  /// ```
  ///
  /// Of course, parts are not generated if Vi or Ei is not present.
  private func visitTryExcept(body: NonEmptyArray<Statement>,
                              handlers: [ExceptHandler],
                              orElse: [Statement]) throws {
    // THERE IS A DIFFERENCE BETWEEN US AND CPYTHON.
    // SEE LONG COMMENT ABOVE THIS FUNCTION!
    // WE WILL PUSH ONLY EXCEPTION (WITHOUT TYPE AND TRACEBACK)!

    let firstExcept = self.builder.createLabel()
    let orElseStart = self.builder.createLabel()
    let end = self.builder.createLabel()

    // body
    self.builder.appendSetupExcept(firstExcept: firstExcept)
    try self.inBlock(.except) {
      try self.visit(body)
      self.builder.appendPopBlock()
    }
    // if no exception happened then go to 'orElse'
    self.builder.appendJumpAbsolute(to: orElseStart)

    // except
    self.builder.setLabel(firstExcept)
    for (index, handler) in handlers.enumerated() {
      let isLast = index == handlers.count - 1

      // default 'except:' must be last
      if case .default = handler.kind, !isLast {
        throw self.error(.defaultExceptNotLast)
      }

      self.setAppendLocation(handler)
      let nextExcept = self.builder.createLabel()

      // check if exception type match
      if case let .typed(type: type, asName: _) = handler.kind {
        self.builder.appendDupTop() // dup exception (exception match will consume it)
        try self.visit(type)
        self.builder.appendCompareOp(type: .exceptionMatch)
        self.builder.appendPopJumpIfFalse(to: nextExcept)
      }

      if case let .typed(type: _, asName: asName) = handler.kind,
              let name = asName {
        // we have name -> store exception
        self.visitName(name: name, context: .store)

        // try:
        //     # body
        // except type as name:
        //     try:
        //         # body
        //     finally:
        //         name = None
        //         del name

        // second try:
        let cleanupEnd = self.builder.createLabel()
        self.builder.appendSetupFinally(finallyStart: cleanupEnd)
        try self.inBlock(.finallyTry) {
          try self.visit(handler.body)
          self.builder.appendPopBlock()
        }

        // finally:
        self.builder.appendNone()
        self.builder.setLabel(cleanupEnd)

        self.inBlock(.finallyEnd) {
          // name = None
          self.builder.appendNone()
          self.visitName(name: name, context: .store)
          // del name
          self.visitName(name: name, context: .del)
          // cleanup
          self.builder.appendEndFinally()
          self.builder.appendPopExcept()
        }
      } else {
        self.builder.appendPopTop() // no name -> pop exception

        try self.inBlock(.finallyTry) {
          try self.visit(handler.body)
          self.builder.appendPopExcept()
        }
      }

      self.builder.appendJumpAbsolute(to: end)
      self.builder.setLabel(nextExcept)
    }

    self.builder.appendEndFinally()
    self.builder.setLabel(orElseStart)
    try self.visit(orElse)
    self.builder.setLabel(end)
  }
}
