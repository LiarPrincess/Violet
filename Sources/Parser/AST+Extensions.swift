import Foundation
import Core
import Lexer

//extension Statement {
//  public init(_ kind: StatementKind,
//              start: SourceLocation,
//              end: SourceLocation) {
//    self.init(kind: kind, start: start, end: end)
//  }
//}

extension Expression {
  public init(_ kind: ExpressionKind,
              start:  SourceLocation,
              end:    SourceLocation) {
    self.init(kind: kind, start: start, end: end)
  }
}

extension Slice {
  public init(_ kind: SliceKind, start: SourceLocation, end: SourceLocation) {
    self.kind = kind
    self.start = start
    self.end = end
  }
}

// TODO: (Elsa) Add default arguments
extension Arguments {
  public init(argss: [Arg] = [],
              defaults: [Expression] = [],
              vararg: Vararg = .none,
              kwOnlyArgs: [Arg] = [],
              kwOnlyDefaults: [Expression] = [],
              kwarg: Arg? = nil,
              start: SourceLocation,
              end: SourceLocation) {
    self.args = argss
    self.defaults = defaults
    self.vararg = vararg
    self.kwOnlyArgs = kwOnlyArgs
    self.kwOnlyDefaults = kwOnlyDefaults
    self.kwarg = kwarg
    self.start = start
    self.end = end
  }
}

extension Arg {
  public init(_ name:     String,
              annotation: Expression?,
              start:      SourceLocation,
              end:        SourceLocation) {
    self.name = name
    self.annotation = annotation
    self.start = start
    self.end = end
  }
}
