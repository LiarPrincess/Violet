import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

extension Compiler {
  internal func visitGeneratorExpression(elt: Expression,
                                         generators: NonEmptyArray<Comprehension>,
                                         location: SourceLocation) throws {
    throw self.notImplementedComprehension()
  }

  internal func visitListComprehension(elt: Expression,
                                       generators: NonEmptyArray<Comprehension>,
                                       location: SourceLocation) throws {
    throw self.notImplementedComprehension()
  }

  internal func visitSetComprehension(elt: Expression,
                                      generators: NonEmptyArray<Comprehension>,
                                      location: SourceLocation) throws {
    throw self.notImplementedComprehension()
  }

  internal func visitDictionaryComprehension(key: Expression,
                                             value: Expression,
                                             generators: NonEmptyArray<Comprehension>,
                                             location: SourceLocation) throws {
    throw self.notImplementedComprehension()
  }
}
