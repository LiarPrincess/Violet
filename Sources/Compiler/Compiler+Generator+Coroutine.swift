import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

extension Compiler {

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visitAwait(expr: Expression, location: SourceLocation) throws {
    guard self.currentScope.type == .function else {
      throw self.error(.awaitOutsideFunction, location: location)
    }

    let type = self.codeObject.type
    guard type == .asyncFunction || type == .comprehension else {
      throw self.error(.awaitOutsideAsyncFunction, location: location)
    }

    try self.visitExpression(expr)
    try self.codeObject.appendGetAwaitable(at: location)
    try self.codeObject.appendNone(at: location)
    try self.codeObject.appendYieldFrom(at: location)
  }

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visitYield(value: Expression?, location: SourceLocation) throws {
    guard self.currentScope.type == .function else {
      throw self.error(.yieldOutsideFunction, location: location)
    }

    if let v = value {
      try self.visitExpression(v)
    } else {
      try self.codeObject.appendNone(at: location)
    }

    try self.codeObject.appendYieldValue(at: location)
  }

  /// compiler_visit_expr(struct compiler *c, expr_ty e)
  internal func visitYieldFrom(expr: Expression, location: SourceLocation) throws {
    guard self.currentScope.type == .function else {
      throw self.error(.yieldOutsideFunction, location: location)
    }

    if self.codeObject.type == .asyncFunction {
      throw self.error(.yieldFromInsideAsyncFunction, location: location)
    }

    try self.visitExpression(expr)
    try self.codeObject.appendGetYieldFromIter(at: location)
    try self.codeObject.appendNone(at: location)
    try self.codeObject.appendYieldFrom(at: location)
  }
}
