import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable cyclomatic_complexity

extension Compiler {

  // MARK: - Base

  /// compiler_addop(struct compiler *c, int opcode)
  internal func emit(_ instruction: Instruction, line: SourceLine) throws {
    self.currentBlock.instructions.append(instruction)
    self.currentBlock.instructionLines.append(line)

    assert(self.currentBlock.instructions.count ==
           self.currentBlock.instructionLines.count)
  }

  // MARK: - Constants

  /// compiler_addop_o(struct compiler *c, int opcode, PyObject *dict, PyObject *o)
  /// compiler_addop_i(struct compiler *c, int opcode, Py_ssize_t oparg)
  internal func emitConstant(_ c: Constant, line: SourceLine) throws {
    // TODO: check if this value was already added
    let constantIndex = self.currentBlock.constants.endIndex
    self.currentBlock.constants.append(c)

    let index = try self.emitExtendedArgIfNeeded(constantIndex, line: line)
    try self.emit(.loadConst(index: index), line: line)
  }

  // MARK: - Operators

  /// unaryop(unaryop_ty op)
  internal func emitUnaryOperator(_ op: UnaryOperator,
                                  line: SourceLine) throws {
    switch op {
    case .invert: try self.emit(.unaryInvert, line: line)
    case .not:    try self.emit(.unaryNot,    line: line)
    case .plus:   try self.emit(.unaryPositive, line: line)
    case .minus:  try self.emit(.unaryNegative, line: line)
    }
  }

  /// binop(struct compiler *c, operator_ty op)
  internal func emitBinaryOperator(_ op: BinaryOperator,
                                   line: SourceLine) throws {
    switch op {
    case .add:        try self.emit(.binaryAdd,            line: line)
    case .sub:        try self.emit(.binarySubtract,       line: line)
    case .mul:        try self.emit(.binaryMultiply,       line: line)
    case .matMul:     try self.emit(.binaryMatrixMultiply, line: line)
    case .div:        try self.emit(.binaryTrueDivide,     line: line)
    case .modulo:     try self.emit(.binaryModulo,      line: line)
    case .pow:        try self.emit(.binaryPower,       line: line)
    case .leftShift:  try self.emit(.binaryLShift,      line: line)
    case .rightShift: try self.emit(.binaryRShift,      line: line)
    case .bitOr:      try self.emit(.binaryOr,          line: line)
    case .bitXor:     try self.emit(.binaryXor,         line: line)
    case .bitAnd:     try self.emit(.binaryAnd,         line: line)
    case .floorDiv:   try self.emit(.binaryFloorDivide, line: line)
    }
  }

  /// cmpop(cmpop_ty op)
  internal func emitComparisonOperator(_ op: ComparisonOperator,
                                       line: SourceLine) throws {
    switch op {
    case .equal:        try self.emit(.compareOp(.equal),        line: line)
    case .notEqual:     try self.emit(.compareOp(.notEqual),     line: line)
    case .less:         try self.emit(.compareOp(.less),         line: line)
    case .lessEqual:    try self.emit(.compareOp(.lessEqual),    line: line)
    case .greater:      try self.emit(.compareOp(.greater),      line: line)
    case .greaterEqual: try self.emit(.compareOp(.greaterEqual), line: line)
    case .is:           try self.emit(.compareOp(.is),           line: line)
    case .isNot:        try self.emit(.compareOp(.isNot),        line: line)
    case .in:           try self.emit(.compareOp(.in),           line: line)
    case .notIn:        try self.emit(.compareOp(.notIn),        line: line)
    }
  }

  // MARK: - Jump

  @available(*, unavailable, message: "Use 'self.emitJumpAbsolute' instead.")
  internal func emitJumpForward(delta: Label, line: SourceLine) throws {
    fatalError("Unavailable 'emitJumpForward', use 'emitJumpAbsolute' instead.")
  }

  internal func emitJumpAbsolute(to label: Label, line: SourceLine) throws {
    let index = try self.emitExtendedArgIfNeeded(label.index, line: line)
    try self.emit(.jumpAbsolute(labelIndex: index), line: line)
  }

  internal func emitPopJumpIfTrue(to label: Label, line: SourceLine) throws {
    let index = try self.emitExtendedArgIfNeeded(label.index, line: line)
    try self.emit(.popJumpIfTrue(labelIndex: index), line: line)
  }

  internal func emitPopJumpIfFalse(to label: Label, line: SourceLine) throws {
    let index = try self.emitExtendedArgIfNeeded(label.index, line: line)
    try self.emit(.popJumpIfFalse(labelIndex: index), line: line)
  }

  internal func emitJumpIfTrueOrPop(to label: Label, line: SourceLine) throws {
    let index = try self.emitExtendedArgIfNeeded(label.index, line: line)
    try self.emit(.jumpIfTrueOrPop(labelIndex: index), line: line)
  }

  internal func emitJumpIfFalseOrPop(to label: Label, line: SourceLine) throws {
    let index = try self.emitExtendedArgIfNeeded(label.index, line: line)
    try self.emit(.jumpIfFalseOrPop(labelIndex: index), line: line)
  }

  // MARK: - Helpers

  /// If the arg is `>255` then it can't be stored directly in instruction.
  /// In this case we have to emit `extendedArg` before it.
  /// - Returns:
  /// Value that should be used in instruction.
  private func emitExtendedArgIfNeeded(_ arg: Int,
                                       line: SourceLine) throws -> UInt8 {
    // TODO: Test this
    // We will use following masks:
    // 0xff000000 <- extended 1
    // 0x00ff0000 <- extended 2
    // 0x0000ff00 <- extended 3
    // 0x000000ff <- instruction arg (our return value)

    assert(arg > 0)
    if arg > 0xffff_ffff {
      fatalError()
    }

    let ffMask = 0xff

    var shift = 24
    var mask = ffMask << shift
    var value = UInt8((arg & mask) >> shift)

    let emit1 = value > 0
    if emit1 {
      try self.emit(.extendedArg(value), line: line)
    }

    shift = 16
    mask = ffMask << shift
    value = UInt8((arg & mask) >> shift)

    let emit2 = emit1 || value > 0
    if emit2 {
      try self.emit(.extendedArg(value), line: line)
    }

    shift = 8
    mask = ffMask << shift
    value = UInt8((arg & mask) >> shift)

    let emit3 = emit2 || value > 0
    if emit3 {
      try self.emit(.extendedArg(value), line: line)
    }

    return UInt8((arg & ffMask) >> shift)
  }
}
