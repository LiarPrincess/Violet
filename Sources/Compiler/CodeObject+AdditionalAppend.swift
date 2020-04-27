import VioletCore
import VioletBytecode
import VioletParser

extension CodeObjectBuilder {

  // MARK: - Variables

  internal func appendName<S: ConstantString>(name: S, context: ExpressionContext) {
    switch context {
    case .store: self.appendStoreName(name)
    case .load:  self.appendLoadName(name)
    case .del:   self.appendDeleteName(name)
    }
  }

  internal func appendFast(name: MangledName, context: ExpressionContext) {
    switch context {
    case .store: self.appendStoreFast(name)
    case .load:  self.appendLoadFast(name)
    case .del:   self.appendDeleteFast(name)
    }
  }

  internal func appendGlobal<S: ConstantString>(name: S, context: ExpressionContext) {
    switch context {
    case .store: self.appendStoreGlobal(name)
    case .load:  self.appendLoadGlobal(name)
    case .del:   self.appendDeleteGlobal(name)
    }
  }

  // MARK: - Operators

  internal func appendUnaryOperator(_ op: UnaryOperator) {
    switch op {
    case .invert: self.appendUnaryInvert()
    case .not:    self.appendUnaryNot()
    case .plus:   self.appendUnaryPositive()
    case .minus:  self.appendUnaryNegative()
    }
  }

  internal func appendBinaryOperator(_ op: BinaryOperator) {
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

  internal func appendInplaceOperator(_ op: BinaryOperator) {
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
  internal func appendCompareOp(operator: ComparisonOperator) {
    switch `operator` {
    case .equal:        self.appendCompareOp(type: .equal)
    case .notEqual:     self.appendCompareOp(type: .notEqual)
    case .less:         self.appendCompareOp(type: .less)
    case .lessEqual:    self.appendCompareOp(type: .lessEqual)
    case .greater:      self.appendCompareOp(type: .greater)
    case .greaterEqual: self.appendCompareOp(type: .greaterEqual)
    case .is:           self.appendCompareOp(type: .is)
    case .isNot:        self.appendCompareOp(type: .isNot)
    case .in:           self.appendCompareOp(type: .in)
    case .notIn:        self.appendCompareOp(type: .notIn)
    }
  }
}
