import Core
import Bytecode
import Parser

extension CodeObjectBuilder {

  // MARK: - Variables

  public func appendName<S: ConstantString>(name: S, context: ExpressionContext) {
    switch context {
    case .store: self.appendStoreName(name)
    case .load:  self.appendLoadName(name)
    case .del:   self.appendDeleteName(name)
    }
  }

  public func appendFast(name: MangledName, context: ExpressionContext) {
    switch context {
    case .store: self.appendStoreFast(name)
    case .load:  self.appendLoadFast(name)
    case .del:   self.appendDeleteFast(name)
    }
  }

  public func appendGlobal<S: ConstantString>(name: S, context: ExpressionContext) {
    switch context {
    case .store: self.appendStoreGlobal(name)
    case .load:  self.appendLoadGlobal(name)
    case .del:   self.appendDeleteGlobal(name)
    }
  }

  // MARK: - Operators

  public func appendUnaryOperator(_ op: UnaryOperator) {
    switch op {
    case .invert: self.appendUnaryInvert()
    case .not:    self.appendUnaryNot()
    case .plus:   self.appendUnaryPositive()
    case .minus:  self.appendUnaryNegative()
    }
  }

  public func appendBinaryOperator(_ op: BinaryOperator) {
    switch op {
    case .add:        self.appendBinaryAdd()
    case .sub:        self.appendBinarySubtract()
    case .mul:        self.appendBinaryMultiply()
    case .matMul:     self.appendBinaryMatrixMultiply()
    case .div:        self.appendBinaryTrueDivide()
    case .modulo:     self.appendBinaryModulo()
    case .pow:        self.appendBinaryPower()
    case .leftShift:  self.appendBinaryLShift()
    case .rightShift: self.appendBinaryRShift()
    case .bitOr:      self.appendBinaryOr()
    case .bitXor:     self.appendBinaryXor()
    case .bitAnd:     self.appendBinaryAnd()
    case .floorDiv:   self.appendBinaryFloorDivide()
    }
  }

  public func appendInplaceOperator(_ op: BinaryOperator) {
    switch op {
    case .add:        self.appendInplaceAdd()
    case .sub:        self.appendInplaceSubtract()
    case .mul:        self.appendInplaceMultiply()
    case .matMul:     self.appendInplaceMatrixMultiply()
    case .div:        self.appendInplaceTrueDivide()
    case .modulo:     self.appendInplaceModulo()
    case .pow:        self.appendInplacePower()
    case .leftShift:  self.appendInplaceLShift()
    case .rightShift: self.appendInplaceRShift()
    case .bitOr:      self.appendInplaceOr()
    case .bitXor:     self.appendInplaceXor()
    case .bitAnd:     self.appendInplaceAnd()
    case .floorDiv:   self.appendInplaceFloorDivide()
    }
  }

  // MARK: - Compare

  /// Append a `compareOp` instruction to code object.
  public func appendCompareOp(_ op: ComparisonOperator) {
    switch op {
    case .equal:        self.appendCompareOp(ComparisonOpcode.equal)
    case .notEqual:     self.appendCompareOp(ComparisonOpcode.notEqual)
    case .less:         self.appendCompareOp(ComparisonOpcode.less)
    case .lessEqual:    self.appendCompareOp(ComparisonOpcode.lessEqual)
    case .greater:      self.appendCompareOp(ComparisonOpcode.greater)
    case .greaterEqual: self.appendCompareOp(ComparisonOpcode.greaterEqual)
    case .is:           self.appendCompareOp(ComparisonOpcode.is)
    case .isNot:        self.appendCompareOp(ComparisonOpcode.isNot)
    case .in:           self.appendCompareOp(ComparisonOpcode.in)
    case .notIn:        self.appendCompareOp(ComparisonOpcode.notIn)
    }
  }
}
