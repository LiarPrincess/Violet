import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

extension Compiler {

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visitAwait(expr: Expression) throws {
    guard self.currentScope.type == .function else {
      throw self.error(.awaitOutsideFunction)
    }

    let type = self.codeObject.type
    guard type == .asyncFunction || type == .comprehension else {
      throw self.error(.awaitOutsideAsyncFunction)
    }

    try self.visitExpression(expr)
    self.builder.appendGetAwaitable()
    self.builder.appendNone()
    self.builder.appendYieldFrom()
  }

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visitYield(value: Expression?) throws {
    guard self.currentScope.type == .function else {
      throw self.error(.yieldOutsideFunction)
    }

    if let v = value {
      try self.visitExpression(v)
    } else {
      self.builder.appendNone()
    }

    self.builder.appendYieldValue()
  }

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visitYieldFrom(expr: Expression) throws {
    guard self.currentScope.type == .function else {
      throw self.error(.yieldOutsideFunction)
    }

    if self.codeObject.type == .asyncFunction {
      throw self.error(.yieldFromInsideAsyncFunction)
    }

    try self.visitExpression(expr)
    self.builder.appendGetYieldFromIter()
    self.builder.appendNone()
    self.builder.appendYieldFrom()
  }
}
