import Core
import Bytecode
import Parser

public enum DerefContext {
  case store
  case load
  case loadClass
  case del
}

extension CodeObject {

  /// Append a `loadConst` instruction to code object.
  public func emitString(_ mangled: MangledName, location: SourceLocation) throws {
    try self.emitConstant(.string(mangled.value), location: location)
  }

  public func emitName<S: ConstantString>(name: S,
                                          context:  ExpressionContext,
                                          location: SourceLocation) throws {
    switch context {
    case .store: try self.emitStoreName (name: name, location: location)
    case .load:  try self.emitLoadName  (name: name, location: location)
    case .del:   try self.emitDeleteName(name: name, location: location)
    }
  }

  public func emitDeref<S: ConstantString>(name: S,
                                           context: DerefContext,
                                           location: SourceLocation) throws {
    switch context {
    case .store: try self.emitStoreDeref (name: name, location: location)
    case .load:  try self.emitLoadDeref  (name: name, location: location)
    case .del:   try self.emitDeleteDeref(name: name, location: location)
    case .loadClass: try self.emitLoadClassDeref(name: name, location: location)
    }
  }

  public func emitFast<S: ConstantString>(name: S,
                                          context:  ExpressionContext,
                                          location: SourceLocation) throws {
    switch context {
    case .store: try self.emitStoreFast (name: name, location: location)
    case .load:  try self.emitLoadFast  (name: name, location: location)
    case .del:   try self.emitDeleteFast(name: name, location: location)
    }
  }

  public func emitGlobal<S: ConstantString>(name: S,
                                            context:  ExpressionContext,
                                            location: SourceLocation) throws {
    switch context {
    case .store: try self.emitStoreGlobal (name: name, location: location)
    case .load:  try self.emitLoadGlobal  (name: name, location: location)
    case .del:   try self.emitDeleteGlobal(name: name, location: location)
    }
  }

  public func emitSubscript(context: ExpressionContext,
                            location: SourceLocation) throws {
    switch context {
    case .store: try self.emitStoreSubscr (location: location)
    case .load:  try self.emitBinarySubscr(location: location)
    case .del:   try self.emitDeleteSubscr(location: location)
    }
  }

  public func emitAttribute<S: ConstantString>(name: S,
                                               context:  ExpressionContext,
                                               location: SourceLocation) throws {
    switch context {
    case .store: try self.emitStoreAttribute (name: name, location: location)
    case .load:  try self.emitLoadAttribute  (name: name, location: location)
    case .del:   try self.emitDeleteAttribute(name: name, location: location)
    }
  }

  public func emitUnaryOperator(_ op: UnaryOperator,
                                location: SourceLocation) throws {
    switch op {
    case .invert: try self.emitUnaryInvert(location: location)
    case .not:    try self.emitUnaryNot(location: location)
    case .plus:   try self.emitUnaryPositive(location: location)
    case .minus:  try self.emitUnaryNegative(location: location)
    }
  }

  // swiftlint:disable:next cyclomatic_complexity
  public func emitBinaryOperator(_ op: BinaryOperator,
                                 location: SourceLocation) throws {
    switch op {
    case .add:        try self.emitBinaryAdd            (location: location)
    case .sub:        try self.emitBinarySubtract       (location: location)
    case .mul:        try self.emitBinaryMultiply       (location: location)
    case .matMul:     try self.emitBinaryMatrixMultiply (location: location)
    case .div:        try self.emitBinaryTrueDivide     (location: location)
    case .modulo:     try self.emitBinaryModulo      (location: location)
    case .pow:        try self.emitBinaryPower       (location: location)
    case .leftShift:  try self.emitBinaryLShift      (location: location)
    case .rightShift: try self.emitBinaryRShift      (location: location)
    case .bitOr:      try self.emitBinaryOr          (location: location)
    case .bitXor:     try self.emitBinaryXor         (location: location)
    case .bitAnd:     try self.emitBinaryAnd         (location: location)
    case .floorDiv:   try self.emitBinaryFloorDivide (location: location)
    }
  }

  // swiftlint:disable:next cyclomatic_complexity
  public func emitInplaceOperator(_ op: BinaryOperator,
                                  location: SourceLocation) throws {
    switch op {
    case .add:        try self.emitInplaceAdd            (location: location)
    case .sub:        try self.emitInplaceSubtract       (location: location)
    case .mul:        try self.emitInplaceMultiply       (location: location)
    case .matMul:     try self.emitInplaceMatrixMultiply (location: location)
    case .div:        try self.emitInplaceTrueDivide     (location: location)
    case .modulo:     try self.emitInplaceModulo      (location: location)
    case .pow:        try self.emitInplacePower       (location: location)
    case .leftShift:  try self.emitInplaceLShift      (location: location)
    case .rightShift: try self.emitInplaceRShift      (location: location)
    case .bitOr:      try self.emitInplaceOr          (location: location)
    case .bitXor:     try self.emitInplaceXor         (location: location)
    case .bitAnd:     try self.emitInplaceAnd         (location: location)
    case .floorDiv:   try self.emitInplaceFloorDivide (location: location)
    }
  }

  /// Append a `compareOp` instruction to code object.
  public func emitCompareOp(_ op: ComparisonOperator,
                            location: SourceLocation) throws {
    // swiftlint:disable:next type_name nesting
    typealias O = ComparisonOpcode
    switch op {
    case .equal:        try self.emitCompareOp(O.equal,        location: location)
    case .notEqual:     try self.emitCompareOp(O.notEqual,     location: location)
    case .less:         try self.emitCompareOp(O.less,         location: location)
    case .lessEqual:    try self.emitCompareOp(O.lessEqual,    location: location)
    case .greater:      try self.emitCompareOp(O.greater,      location: location)
    case .greaterEqual: try self.emitCompareOp(O.greaterEqual, location: location)
    case .is:           try self.emitCompareOp(O.is,           location: location)
    case .isNot:        try self.emitCompareOp(O.isNot,        location: location)
    case .in:           try self.emitCompareOp(O.in,           location: location)
    case .notIn:        try self.emitCompareOp(O.notIn,        location: location)
    }
  }
}
