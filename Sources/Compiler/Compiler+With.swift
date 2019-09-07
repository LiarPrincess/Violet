import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

extension Compiler {

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
  internal func visitWith(items: NonEmptyArray<WithItem>,
                          body:   NonEmptyArray<Statement>,
                          location: SourceLocation) throws {
    try self.visitWith(items: items,
                       body:  body,
                       index: 0,
                       location: location)
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
                         body:  NonEmptyArray<Statement>,
                         index: Int,
                         location: SourceLocation) throws {
    let item = items[index]
    let afterBody = self.codeObject.createLabel()

    // Evaluate EXPR
    try self.visitExpression(item.contextExpr)
    try self.codeObject.appendSetupWith(afterBody: afterBody, at: location)

    // SETUP_WITH pushes a finally block.
    try self.inBlock(.finallyTry) {
      if let o = item.optionalVars {
        try self.visitExpression(o, context: .store)
      } else {
        // Discard result from context.__enter__()
        try self.codeObject.appendPopTop(at: location)
      }

      // TODO: some weird condition
      // BLOCK code
      try self.visitStatements(body)

      // End of try block; start the finally block
      try self.codeObject.appendPopBlock(at: location)
    }

    try self.codeObject.appendNone(at: location)
    self.codeObject.setLabel(afterBody)

    try self.inBlock(.finallyEnd) {
      // Finally block starts; context.__exit__ is on the stack under
      // the exception or return information. Just issue our magic opcode.
      try self.codeObject.appendWithCleanupStart(at: location)
      try self.codeObject.appendWithCleanupFinish(at: location)

      // Finally block ends.
      try self.codeObject.appendEndFinally(at: location)
    }
  }
}
