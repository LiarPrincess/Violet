import VioletCore
import VioletParser
import VioletBytecode

extension CodeObjectBuilder {

  // MARK: - Variables

  internal func appendName(name: MangledName, context: ExpressionContext) {
    switch context {
    case .store: self.appendStoreName(name)
    case .load: self.appendLoadName(name)
    case .del: self.appendDeleteName(name)
    }
  }

  internal func appendGlobal(name: String, context: ExpressionContext) {
    switch context {
    case .store: self.appendStoreGlobal(name)
    case .load: self.appendLoadGlobal(name)
    case .del: self.appendDeleteGlobal(name)
    }
  }

  internal func appendGlobal(name: MangledName, context: ExpressionContext) {
    switch context {
    case .store: self.appendStoreGlobal(name)
    case .load: self.appendLoadGlobal(name)
    case .del: self.appendDeleteGlobal(name)
    }
  }

  internal func appendFast(name: MangledName, context: ExpressionContext) {
    switch context {
    case .store: self.appendStoreFast(name)
    case .load: self.appendLoadFast(name)
    case .del: self.appendDeleteFast(name)
    }
  }

  internal func appendCell(name: MangledName, context: ExpressionContext) {
    switch context {
    case .store: self.appendStoreCell(name)
    case .load: self.appendLoadCell(name)
    case .del: self.appendDeleteCell(name)
    }
  }

  internal func appendFree(name: MangledName, context: ExpressionContext) {
    switch context {
    case .store: self.appendStoreFree(name)
    case .load: self.appendLoadFree(name)
    case .del: self.appendDeleteFree(name)
    }
  }

  // MARK: - Operators

  internal func appendUnaryOperator(_ op: UnaryOpExpr.Operator) {
    switch op {
    case .invert: self.appendUnaryInvert()
    case .not: self.appendUnaryNot()
    case .plus: self.appendUnaryPositive()
    case .minus: self.appendUnaryNegative()
    }
  }

  internal func appendBinaryOperator(_ op: BinaryOpExpr.Operator) {
    switch op {
    case .add: self.appendBinaryAdd()
    case .sub: self.appendBinarySubtract()
    case .mul: self.appendBinaryMultiply()
    case .matMul: self.appendBinaryMatrixMultiply()
    case .div: self.appendBinaryTrueDivide()
    case .modulo: self.appendBinaryModulo()
    case .pow: self.appendBinaryPower()
    case .leftShift: self.appendBinaryLShift()
    case .rightShift: self.appendBinaryRShift()
    case .bitOr: self.appendBinaryOr()
    case .bitXor: self.appendBinaryXor()
    case .bitAnd: self.appendBinaryAnd()
    case .floorDiv: self.appendBinaryFloorDivide()
    }
  }

  internal func appendInPlaceOperator(_ op: BinaryOpExpr.Operator) {
    switch op {
    case .add: self.appendInPlaceAdd()
    case .sub: self.appendInPlaceSubtract()
    case .mul: self.appendInPlaceMultiply()
    case .matMul: self.appendInPlaceMatrixMultiply()
    case .div: self.appendInPlaceTrueDivide()
    case .modulo: self.appendInPlaceModulo()
    case .pow: self.appendInPlacePower()
    case .leftShift: self.appendInPlaceLShift()
    case .rightShift: self.appendInPlaceRShift()
    case .bitOr: self.appendInPlaceOr()
    case .bitXor: self.appendInPlaceXor()
    case .bitAnd: self.appendInPlaceAnd()
    case .floorDiv: self.appendInPlaceFloorDivide()
    }
  }

  // MARK: - Compare

  /// Append a `compareOp` instruction to code object.
  internal func appendCompareOp(operator: CompareExpr.Operator) {
    switch `operator` {
    case .equal: self.appendCompareOp(type: .equal)
    case .notEqual: self.appendCompareOp(type: .notEqual)
    case .less: self.appendCompareOp(type: .less)
    case .lessEqual: self.appendCompareOp(type: .lessEqual)
    case .greater: self.appendCompareOp(type: .greater)
    case .greaterEqual: self.appendCompareOp(type: .greaterEqual)
    case .is: self.appendCompareOp(type: .is)
    case .isNot: self.appendCompareOp(type: .isNot)
    case .in: self.appendCompareOp(type: .in)
    case .notIn: self.appendCompareOp(type: .notIn)
    }
  }
}
