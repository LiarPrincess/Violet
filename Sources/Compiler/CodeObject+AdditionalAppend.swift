import Core
import Bytecode
import Parser

extension CodeObject {

  public func appendName<S: ConstantString>(name: S,
                                            context:  ExpressionContext,
                                            at location: SourceLocation) throws {
    switch context {
    case .store: try self.appendStoreName (name, at: location)
    case .load:  try self.appendLoadName  (name, at: location)
    case .del:   try self.appendDeleteName(name, at: location)
    }
  }

  public func appendFast<S: ConstantString>(name: S,
                                            context:  ExpressionContext,
                                            at location: SourceLocation) throws {
    switch context {
    case .store: try self.appendStoreFast (name, at: location)
    case .load:  try self.appendLoadFast  (name, at: location)
    case .del:   try self.appendDeleteFast(name, at: location)
    }
  }

  public func appendGlobal<S: ConstantString>(name: S,
                                              context:  ExpressionContext,
                                              at location: SourceLocation) throws {
    switch context {
    case .store: try self.appendStoreGlobal (name, at: location)
    case .load:  try self.appendLoadGlobal  (name, at: location)
    case .del:   try self.appendDeleteGlobal(name, at: location)
    }
  }

  public func appendSubscript(context: ExpressionContext,
                              at location: SourceLocation) throws {
    switch context {
    case .store: try self.appendStoreSubscr (at: location)
    case .load:  try self.appendBinarySubscr(at: location)
    case .del:   try self.appendDeleteSubscr(at: location)
    }
  }

  public func appendAttribute<S: ConstantString>(name: S,
                                                 context:  ExpressionContext,
                                                 at location: SourceLocation) throws {
    switch context {
    case .store: try self.appendStoreAttribute (name, at: location)
    case .load:  try self.appendLoadAttribute  (name, at: location)
    case .del:   try self.appendDeleteAttribute(name, at: location)
    }
  }

  public func appendUnaryOperator(_ op: UnaryOperator,
                                  at location: SourceLocation) throws {
    switch op {
    case .invert: try self.appendUnaryInvert(at: location)
    case .not:    try self.appendUnaryNot(at: location)
    case .plus:   try self.appendUnaryPositive(at: location)
    case .minus:  try self.appendUnaryNegative(at: location)
    }
  }

  // swiftlint:disable:next cyclomatic_complexity
  public func appendBinaryOperator(_ op: BinaryOperator,
                                   at location: SourceLocation) throws {
    switch op {
    case .add:        try self.appendBinaryAdd            (at: location)
    case .sub:        try self.appendBinarySubtract       (at: location)
    case .mul:        try self.appendBinaryMultiply       (at: location)
    case .matMul:     try self.appendBinaryMatrixMultiply (at: location)
    case .div:        try self.appendBinaryTrueDivide     (at: location)
    case .modulo:     try self.appendBinaryModulo      (at: location)
    case .pow:        try self.appendBinaryPower       (at: location)
    case .leftShift:  try self.appendBinaryLShift      (at: location)
    case .rightShift: try self.appendBinaryRShift      (at: location)
    case .bitOr:      try self.appendBinaryOr          (at: location)
    case .bitXor:     try self.appendBinaryXor         (at: location)
    case .bitAnd:     try self.appendBinaryAnd         (at: location)
    case .floorDiv:   try self.appendBinaryFloorDivide (at: location)
    }
  }

  // swiftlint:disable:next cyclomatic_complexity
  public func appendInplaceOperator(_ op: BinaryOperator,
                                    at location: SourceLocation) throws {
    switch op {
    case .add:        try self.appendInplaceAdd            (at: location)
    case .sub:        try self.appendInplaceSubtract       (at: location)
    case .mul:        try self.appendInplaceMultiply       (at: location)
    case .matMul:     try self.appendInplaceMatrixMultiply (at: location)
    case .div:        try self.appendInplaceTrueDivide     (at: location)
    case .modulo:     try self.appendInplaceModulo      (at: location)
    case .pow:        try self.appendInplacePower       (at: location)
    case .leftShift:  try self.appendInplaceLShift      (at: location)
    case .rightShift: try self.appendInplaceRShift      (at: location)
    case .bitOr:      try self.appendInplaceOr          (at: location)
    case .bitXor:     try self.appendInplaceXor         (at: location)
    case .bitAnd:     try self.appendInplaceAnd         (at: location)
    case .floorDiv:   try self.appendInplaceFloorDivide (at: location)
    }
  }

  /// Append a `compareOp` instruction to code object.
  public func appendCompareOp(_ op: ComparisonOperator,
                              at location: SourceLocation) throws {
    // swiftlint:disable:next type_name nesting
    typealias O = ComparisonOpcode
    switch op {
    case .equal:        try self.appendCompareOp(O.equal,        at: location)
    case .notEqual:     try self.appendCompareOp(O.notEqual,     at: location)
    case .less:         try self.appendCompareOp(O.less,         at: location)
    case .lessEqual:    try self.appendCompareOp(O.lessEqual,    at: location)
    case .greater:      try self.appendCompareOp(O.greater,      at: location)
    case .greaterEqual: try self.appendCompareOp(O.greaterEqual, at: location)
    case .is:           try self.appendCompareOp(O.is,           at: location)
    case .isNot:        try self.appendCompareOp(O.isNot,        at: location)
    case .in:           try self.appendCompareOp(O.in,           at: location)
    case .notIn:        try self.appendCompareOp(O.notIn,        at: location)
    }
  }
}
