import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

extension Compiler {

  internal func visitAwait(expr: Expression, location: SourceLocation) throws {
  }

  internal func visitYield(value: Expression?, location: SourceLocation) throws {
  }

  internal func visitYieldFrom(expr: Expression, location: SourceLocation) throws {
  }
}
