import Core
import Bytecode
import Parser

extension CodeObjectBuilder {

  public func appendName<S: ConstantString>(name: S,
                                            context:  ExpressionContext) throws {
    switch context {
    case .store: try self.appendStoreName(name)
    case .load:  try self.appendLoadName(name)
    case .del:   try self.appendDeleteName(name)
    }
  }

  public func appendFast<S: ConstantString>(name: S,
                                            context:  ExpressionContext) throws {
    switch context {
    case .store: try self.appendStoreFast(name)
    case .load:  try self.appendLoadFast(name)
    case .del:   try self.appendDeleteFast(name)
    }
  }

  public func appendGlobal<S: ConstantString>(name: S,
                                              context:  ExpressionContext) throws {
    switch context {
    case .store: try self.appendStoreGlobal(name)
    case .load:  try self.appendLoadGlobal(name)
    case .del:   try self.appendDeleteGlobal(name)
    }
  }

  public func appendUnaryOperator(_ op: UnaryOperator) throws {
    switch op {
    case .invert: try self.appendUnaryInvert()
    case .not:    try self.appendUnaryNot()
    case .plus:   try self.appendUnaryPositive()
    case .minus:  try self.appendUnaryNegative()
    }
  }

  // swiftlint:disable:next cyclomatic_complexity
  public func appendBinaryOperator(_ op: BinaryOperator) throws {
    switch op {
    case .add:        try self.appendBinaryAdd()
    case .sub:        try self.appendBinarySubtract()
    case .mul:        try self.appendBinaryMultiply()
    case .matMul:     try self.appendBinaryMatrixMultiply()
    case .div:        try self.appendBinaryTrueDivide()
    case .modulo:     try self.appendBinaryModulo()
    case .pow:        try self.appendBinaryPower()
    case .leftShift:  try self.appendBinaryLShift()
    case .rightShift: try self.appendBinaryRShift()
    case .bitOr:      try self.appendBinaryOr()
    case .bitXor:     try self.appendBinaryXor()
    case .bitAnd:     try self.appendBinaryAnd()
    case .floorDiv:   try self.appendBinaryFloorDivide()
    }
  }

  // swiftlint:disable:next cyclomatic_complexity
  public func appendInplaceOperator(_ op: BinaryOperator) throws {
    switch op {
    case .add:        try self.appendInplaceAdd()
    case .sub:        try self.appendInplaceSubtract()
    case .mul:        try self.appendInplaceMultiply()
    case .matMul:     try self.appendInplaceMatrixMultiply()
    case .div:        try self.appendInplaceTrueDivide()
    case .modulo:     try self.appendInplaceModulo()
    case .pow:        try self.appendInplacePower()
    case .leftShift:  try self.appendInplaceLShift()
    case .rightShift: try self.appendInplaceRShift()
    case .bitOr:      try self.appendInplaceOr()
    case .bitXor:     try self.appendInplaceXor()
    case .bitAnd:     try self.appendInplaceAnd()
    case .floorDiv:   try self.appendInplaceFloorDivide()
    }
  }

  /// Append a `compareOp` instruction to code object.
  public func appendCompareOp(_ op: ComparisonOperator) throws {
    switch op {
    case .equal:        try self.appendCompareOp(ComparisonOpcode.equal)
    case .notEqual:     try self.appendCompareOp(ComparisonOpcode.notEqual)
    case .less:         try self.appendCompareOp(ComparisonOpcode.less)
    case .lessEqual:    try self.appendCompareOp(ComparisonOpcode.lessEqual)
    case .greater:      try self.appendCompareOp(ComparisonOpcode.greater)
    case .greaterEqual: try self.appendCompareOp(ComparisonOpcode.greaterEqual)
    case .is:           try self.appendCompareOp(ComparisonOpcode.is)
    case .isNot:        try self.appendCompareOp(ComparisonOpcode.isNot)
    case .in:           try self.appendCompareOp(ComparisonOpcode.in)
    case .notIn:        try self.appendCompareOp(ComparisonOpcode.notIn)
    }
  }
}
