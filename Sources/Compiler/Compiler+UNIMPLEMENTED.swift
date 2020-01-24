import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable unavailable_function

internal typealias Comprehensions = NonEmptyArray<Comprehension>

extension Compiler {

  // MARK: - Comprehension

  internal func visitGeneratorExpression(elt: Expression,
                                         generators: Comprehensions) throws {
    // Remember about self.setAppendLocation(ASTNode)!
    throw self.notImplementedComprehension()
  }

  internal func visitListComprehension(elt: Expression,
                                       generators: Comprehensions) throws {
    throw self.notImplementedComprehension()
  }

  internal func visitSetComprehension(elt: Expression,
                                      generators: Comprehensions) throws {
    throw self.notImplementedComprehension()
  }

  internal func visitDictionaryComprehension(key: Expression,
                                             value: Expression,
                                             generators: Comprehensions) throws {
    throw self.notImplementedComprehension()
  }

  // MARK: - Compiler+If+Loops

  internal func visitAsyncFor(target: Expression,
                              iter:   Expression,
                              body:   NonEmptyArray<Statement>,
                              orElse: [Statement]) throws {
    throw self.notImplementedAsync()
  }

  // MARK: - With

  internal func visitAsyncWith(items: NonEmptyArray<WithItem>,
                               body:  NonEmptyArray<Statement>) throws {
    throw self.notImplementedAsync()
  }

  // MARK: - Compiler+Function

  internal func visitAsyncFunctionDef(args: FunctionDefArgs,
                                      statement: Statement) throws {
    throw self.notImplementedAsync()
  }

  // MARK: - Helpers

  private func notImplementedAsync() -> Error {
    fatalError("[Compiler] 'async' is currently not implemented.")
  }

  private func notImplementedComprehension() -> Error {
    fatalError("[Compiler] 'comprehensions' are currently not implemented.")
  }
}
