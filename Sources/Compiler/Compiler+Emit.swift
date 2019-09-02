import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

// swiftlint:disable cyclomatic_complexity
// swiftlint:disable file_length

extension Compiler {

  // MARK: - Base

  /// compiler_addop(struct compiler *c, int opcode)
  internal func emit(_ instruction: Instruction,
                     location: SourceLocation) throws {

    self.currentCodeObject.instructions.append(instruction)
    self.currentCodeObject.instructionLines.append(location.line)

    assert(self.currentCodeObject.instructions.count ==
           self.currentCodeObject.instructionLines.count)
  }

  // MARK: - Constants

  /// compiler_addop_o(struct compiler *c, int opcode, PyObject *dict, PyObject *o)
  /// compiler_addop_i(struct compiler *c, int opcode, Py_ssize_t oparg)
  internal func emitConstant(_ c: Constant, location: SourceLocation) throws {
    // TODO: check if this value was already added
    let constantIndex = self.currentCodeObject.constants.endIndex
    self.currentCodeObject.constants.append(c)

    let index = try self.emitExtendedArgIfNeeded(constantIndex, location: location)
    try self.emit(.loadConst(index: index), location: location)
  }

  // MARK: - Store, load, delete

  internal func emitName(name: MangledName,
                         context: ExpressionContext,
                         location: SourceLocation) throws {

    let index =
      try self.addNameWithExtendedArgIfNeeded(name: name, location: location)

    switch context {
    case .store:
      try self.emit(.storeName(nameIndex: index), location: location)
    case .load:
      try self.emit(.loadName(nameIndex: index), location: location)
    case .del:
      try self.emit(.deleteName(nameIndex: index), location: location)
    }
  }

  internal func emitAttribute(name: MangledName,
                              context: ExpressionContext,
                              location: SourceLocation) throws {

    let index =
      try self.addNameWithExtendedArgIfNeeded(name: name, location: location)

    switch context {
    case .store:
      try self.emit(.storeAttr(nameIndex: index), location: location)
    case .load:
      try self.emit(.loadAttr(nameIndex: index), location: location)
    case .del:
      try self.emit(.deleteAttr(nameIndex: index), location: location)
    }
  }

  internal func emitSubscript(context: ExpressionContext,
                              location: SourceLocation) throws {
    switch context {
    case .store:
      try self.emit(.storeSubscr, location: location)
    case .load:
      try self.emit(.binarySubscr, location: location)
    case .del:
      try self.emit(.deleteSubscr, location: location)
    }
  }

  internal func emitGlobal(name: MangledName,
                           context: ExpressionContext,
                           location: SourceLocation) throws {

    let index =
      try self.addNameWithExtendedArgIfNeeded(name: name, location: location)

    switch context {
    case .store:
      try self.emit(.storeGlobal(nameIndex: index), location: location)
    case .load:
      try self.emit(.loadGlobal(nameIndex: index), location: location)
    case .del:
      try self.emit(.deleteGlobal(nameIndex: index), location: location)
    }
  }

  internal func emitFast(name: MangledName,
                         context: ExpressionContext,
                         location: SourceLocation) throws {
    // TODO: fill this
  }

  internal enum DerefContext {
    case store
    case load
    case loadClass
    case del
  }

  internal func emitDeref(name: MangledName,
                          context: DerefContext,
                          location: SourceLocation) throws {
    // TODO: fill this
  }

  private func addNameWithExtendedArgIfNeeded(
    name: MangledName,
    location: SourceLocation) throws -> UInt8 {

    let rawIndex = self.currentCodeObject.names.endIndex
    let index = try self.emitExtendedArgIfNeeded(rawIndex, location: location)
    self.currentCodeObject.names.append(name)
    return index
  }

  // MARK: - Operators

  /// unaryop(unaryop_ty op)
  internal func emitUnaryOperator(_ op: UnaryOperator,
                                  location: SourceLocation) throws {
    switch op {
    case .invert: try self.emit(.unaryInvert, location: location)
    case .not:    try self.emit(.unaryNot,    location: location)
    case .plus:   try self.emit(.unaryPositive, location: location)
    case .minus:  try self.emit(.unaryNegative, location: location)
    }
  }

  /// binop(struct compiler *c, operator_ty op)
  internal func emitBinaryOperator(_ op: BinaryOperator,
                                   location: SourceLocation) throws {
    switch op {
    case .add:        try self.emit(.binaryAdd,            location: location)
    case .sub:        try self.emit(.binarySubtract,       location: location)
    case .mul:        try self.emit(.binaryMultiply,       location: location)
    case .matMul:     try self.emit(.binaryMatrixMultiply, location: location)
    case .div:        try self.emit(.binaryTrueDivide,     location: location)
    case .modulo:     try self.emit(.binaryModulo,      location: location)
    case .pow:        try self.emit(.binaryPower,       location: location)
    case .leftShift:  try self.emit(.binaryLShift,      location: location)
    case .rightShift: try self.emit(.binaryRShift,      location: location)
    case .bitOr:      try self.emit(.binaryOr,          location: location)
    case .bitXor:     try self.emit(.binaryXor,         location: location)
    case .bitAnd:     try self.emit(.binaryAnd,         location: location)
    case .floorDiv:   try self.emit(.binaryFloorDivide, location: location)
    }
  }

  /// cmpop(cmpop_ty op)
  internal func emitComparisonOperator(_ op: ComparisonOperator,
                                       location: SourceLocation) throws {
    switch op {
    case .equal:        try self.emit(.compareOp(.equal),        location: location)
    case .notEqual:     try self.emit(.compareOp(.notEqual),     location: location)
    case .less:         try self.emit(.compareOp(.less),         location: location)
    case .lessEqual:    try self.emit(.compareOp(.lessEqual),    location: location)
    case .greater:      try self.emit(.compareOp(.greater),      location: location)
    case .greaterEqual: try self.emit(.compareOp(.greaterEqual), location: location)
    case .is:           try self.emit(.compareOp(.is),           location: location)
    case .isNot:        try self.emit(.compareOp(.isNot),        location: location)
    case .in:           try self.emit(.compareOp(.in),           location: location)
    case .notIn:        try self.emit(.compareOp(.notIn),        location: location)
    }
  }

  // MARK: - Jump

  internal func emitJumpAbsolute(to label: Label,
                                 location: SourceLocation) throws {
    let index = try self.emitExtendedArgIfNeeded(label.index, location: location)
    try self.emit(.jumpAbsolute(labelIndex: index), location: location)
  }

  internal func emitPopJumpIfTrue(to label: Label,
                                  location: SourceLocation) throws {
    let index = try self.emitExtendedArgIfNeeded(label.index, location: location)
    try self.emit(.popJumpIfTrue(labelIndex: index), location: location)
  }

  internal func emitPopJumpIfFalse(to label: Label,
                                   location: SourceLocation) throws {
    let index = try self.emitExtendedArgIfNeeded(label.index, location: location)
    try self.emit(.popJumpIfFalse(labelIndex: index), location: location)
  }

  internal func emitJumpIfTrueOrPop(to label: Label,
                                    location: SourceLocation) throws {
    let index = try self.emitExtendedArgIfNeeded(label.index, location: location)
    try self.emit(.jumpIfTrueOrPop(labelIndex: index), location: location)
  }

  internal func emitJumpIfFalseOrPop(to label: Label,
                                     location: SourceLocation) throws {
    let index = try self.emitExtendedArgIfNeeded(label.index, location: location)
    try self.emit(.jumpIfFalseOrPop(labelIndex: index), location: location)
  }

  // MARK: - Collection

  internal func emitBuildTuple(elementCount: Int,
                               location: SourceLocation) throws {
    // let index = try self.emitExtendedArgIfNeeded(label.index, location: location)
    // try self.emit(.jumpIfFalseOrPop(labelIndex: index), location: location)
  }

  internal func emitBuildList(elementCount: Int,
                              location: SourceLocation) throws {
    // let index = try self.emitExtendedArgIfNeeded(label.index, location: location)
    // try self.emit(.jumpIfFalseOrPop(labelIndex: index), location: location)
  }

  internal func emitBuildSet(elementCount: Int,
                             location: SourceLocation) throws {
    // let index = try self.emitExtendedArgIfNeeded(label.index, location: location)
    // try self.emit(.jumpIfFalseOrPop(labelIndex: index), location: location)
  }

  internal func emitBuildMap(elementCount: Int,
                             location: SourceLocation) throws {
    // let index = try self.emitExtendedArgIfNeeded(label.index, location: location)
    // try self.emit(.jumpIfFalseOrPop(labelIndex: index), location: location)
  }

  internal func emitBuildConstKeyMap(elementCount: Int,
                                     location: SourceLocation) throws {
    // let index = try self.emitExtendedArgIfNeeded(label.index, location: location)
    // try self.emit(.jumpIfFalseOrPop(labelIndex: index), location: location)
  }

  // MARK: - Unpack

  internal func emitBuildTupleUnpack(elementCount: Int,
                                     location: SourceLocation) throws {
    // let index = try self.emitExtendedArgIfNeeded(label.index, location: location)
    // try self.emit(.jumpIfFalseOrPop(labelIndex: index), location: location)
  }

  internal func emitBuildTupleUnpackWithCall(elementCount: Int,
                                             location: SourceLocation) throws {
    // let index = try self.emitExtendedArgIfNeeded(label.index, location: location)
    // try self.emit(.jumpIfFalseOrPop(labelIndex: index), location: location)
  }

  internal func emitBuildListUnpack(elementCount: Int,
                                    location: SourceLocation) throws {
    // let index = try self.emitExtendedArgIfNeeded(label.index, location: location)
    // try self.emit(.jumpIfFalseOrPop(labelIndex: index), location: location)
  }

  internal func emitBuildSetUnpack(elementCount: Int,
                                   location: SourceLocation) throws {
    // let index = try self.emitExtendedArgIfNeeded(label.index, location: location)
    // try self.emit(.jumpIfFalseOrPop(labelIndex: index), location: location)
  }

  internal func emitBuildMapUnpack(elementCount: Int,
                                   location: SourceLocation) throws {
    // let index = try self.emitExtendedArgIfNeeded(label.index, location: location)
    // try self.emit(.jumpIfFalseOrPop(labelIndex: index), location: location)
  }

  internal func emitBuildMapUnpackWithCall(elementCount: Int,
                                           location: SourceLocation) throws {
    // let index = try self.emitExtendedArgIfNeeded(label.index, location: location)
    // try self.emit(.jumpIfFalseOrPop(labelIndex: index), location: location)
  }

  internal func emitUnpackSequence(count: Int, location: SourceLocation) throws {
  }

  /// Implements assignment with a starred target.
  ///
  /// Unpacks an iterable in TOS into individual values, where the total number
  /// of values can be smaller than the number of items in the iterable:
  /// one of the new values will be a list of all leftover items.
  ///
  /// The low byte of counts is the number of values before the list value,
  /// the high byte of counts the number of values after it.
  /// The resulting values are put onto the stack right-to-left.
  internal func emitUnpackEx(countBefore: Int,
                             countAfter:  Int,
                             location:    SourceLocation) throws {
    assert(countBefore <= 0xff)
    assert(countAfter  <= 0xffff_ff)

//    let rawValue = countAfter << 8 | countBefore
  }

  // MARK: - Other

  internal func emitBuildSlice(n: UInt8, location: SourceLocation) throws {
    assert(n == 2 || n == 3)
    try self.emit(.buildSlice(n), location: location)
  }

  // MARK: - Helpers

  /// If the arg is `>255` then it can't be stored directly in instruction.
  /// In this case we have to emit `extendedArg` before it.
  /// - Returns:
  /// Value that should be used in instruction.
  private func emitExtendedArgIfNeeded(_ arg: Int,
                                       location: SourceLocation) throws -> UInt8 {
    // TODO: Test this
    // We will use following masks:
    // 0xff000000 <- extended 1
    // 0x00ff0000 <- extended 2
    // 0x0000ff00 <- extended 3
    // 0x000000ff <- instruction arg (our return value)

    assert(arg > 0)
    if arg > Instruction.maxArgument {
      fatalError()
    }

    let ffMask = 0xff

    var shift = 24
    var mask = ffMask << shift
    var value = UInt8((arg & mask) >> shift)

    let emit1 = value > 0
    if emit1 {
      try self.emit(.extendedArg(value), location: location)
    }

    shift = 16
    mask = ffMask << shift
    value = UInt8((arg & mask) >> shift)

    let emit2 = emit1 || value > 0
    if emit2 {
      try self.emit(.extendedArg(value), location: location)
    }

    shift = 8
    mask = ffMask << shift
    value = UInt8((arg & mask) >> shift)

    let emit3 = emit2 || value > 0
    if emit3 {
      try self.emit(.extendedArg(value), location: location)
    }

    return UInt8((arg & ffMask) >> shift)
  }
}
