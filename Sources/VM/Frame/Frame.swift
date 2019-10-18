import Foundation
import Bytecode
import Objects

// In CPython:
// Python -> ceval.c

// swiftlint:disable file_length

internal class Frame {

  /// Code to run.
  internal let code: CodeObject

  /// Python state.
  internal let context: PyContext

  /// The main data frame of the stack machine.
  internal var stack = ObjectStack()

  /// Local symbol table.
  internal var locals = [String: PyObject]()
  /// Global symbol table.
  internal var globals = [String: PyObject]()
  /// Builtin symbol table.
  internal var builtins = [String: PyObject]()
  /// Free variables.
  internal var free = [String: PyObject]()

  internal var standardOutput: FileHandle {
    return FileHandle.standardOutput
  }

  /// Index of the next instruction to run.
  internal var nextInstructionIndex = 0

  internal init(code: CodeObject, context: PyContext) {
    self.code = code
    self.context = context
  }

  // MARK: - Run

  internal func run() throws {
    while self.nextInstructionIndex != self.code.instructions.endIndex {
      try self.executeInstruction()
   }
  }

  internal func unimplemented() {}

  private func fetchInstruction() -> Instruction {
    assert(self.nextInstructionIndex >= 0)
    assert(self.nextInstructionIndex < self.code.instructions.count)

    let instr = self.code.instructions[self.nextInstructionIndex]
    self.nextInstructionIndex += 1
    return instr
  }

  // swiftlint:disable:next function_body_length
  private func executeInstruction(extendedArg: Int = 0) throws {
    let instruction = self.fetchInstruction()

    // According to CPython doing single switch will trash our jump prediction
    // (unles you have the same opcode multiple times in a row)
    // we don't care about this (for now).
    switch instruction {
    case .nop:
      break
    case .popTop:
      try self.popTop()
    case .rotTwo:
      try self.rotTwo()
    case .rotThree:
      try self.rotThree()
    case .dupTop:
      try self.dupTop()
    case .dupTopTwo:
      try self.dupTopTwo()
    case .unaryPositive:
      try self.unaryPositive()
    case .unaryNegative:
      try self.unaryNegative()
    case .unaryNot:
      try self.unaryNot()
    case .unaryInvert:
      try self.unaryInvert()
    case .binaryPower:
      try self.binaryPower()
    case .binaryMultiply:
      try self.binaryMultiply()
    case .binaryMatrixMultiply:
      try self.binaryMatrixMultiply()
    case .binaryFloorDivide:
      try self.binaryFloorDivide()
    case .binaryTrueDivide:
      try self.binaryTrueDivide()
    case .binaryModulo:
      try self.binaryModulo()
    case .binaryAdd:
      try self.binaryAdd()
    case .binarySubtract:
      try self.binarySubtract()
    case .binaryLShift:
      try self.binaryLShift()
    case .binaryRShift:
      try self.binaryRShift()
    case .binaryAnd:
      try self.binaryAnd()
    case .binaryXor:
      try self.binaryXor()
    case .binaryOr:
      try self.binaryOr()
    case .inplacePower:
      try self.inplacePower()
    case .inplaceMultiply:
      try self.inplaceMultiply()
    case .inplaceMatrixMultiply:
      try self.inplaceMatrixMultiply()
    case .inplaceFloorDivide:
      try self.inplaceFloorDivide()
    case .inplaceTrueDivide:
      try self.inplaceTrueDivide()
    case .inplaceModulo:
      try self.inplaceModulo()
    case .inplaceAdd:
      try self.inplaceAdd()
    case .inplaceSubtract:
      try self.inplaceSubtract()
    case .inplaceLShift:
      try self.inplaceLShift()
    case .inplaceRShift:
      try self.inplaceRShift()
    case .inplaceAnd:
      try self.inplaceAnd()
    case .inplaceXor:
      try self.inplaceXor()
    case .inplaceOr:
      try self.inplaceOr()
    case let .compareOp(comparison):
      assert(extendedArg == 0)
      try self.compareOp(comparison: comparison)
    case .getAwaitable:
      try self.getAwaitable()
    case .getAIter:
      try self.getAIter()
    case .getANext:
      try self.getANext()
    case .yieldValue:
      try self.yieldValue()
    case .yieldFrom:
      try self.yieldFrom()
    case .printExpr:
      try self.printExpr()
    case let .setupLoop(loopEndLabel):
      try self.setupLoop(loopEndLabel: extendedArg + Int(loopEndLabel))
    case let .forIter(ifEmptyLabel):
      try self.forIter(ifEmptyLabel: extendedArg + Int(ifEmptyLabel))
    case .getIter:
      try self.getIter()
    case .getYieldFromIter:
      try self.getYieldFromIter()
    case .`break`:
      try self.doBreak()
    case let .buildTuple(elementCount):
      try self.buildTuple(elementCount: extendedArg + Int(elementCount))
    case let .buildList(elementCount):
      try self.buildList(elementCount: extendedArg + Int(elementCount))
    case let .buildSet(elementCount):
      try self.buildSet(elementCount: extendedArg + Int(elementCount))
    case let .buildMap(elementCount):
      try self.buildMap(elementCount: extendedArg + Int(elementCount))
    case let .buildConstKeyMap(elementCount):
      try self.buildConstKeyMap(elementCount: extendedArg + Int(elementCount))
    case let .setAdd(value):
      try self.setAdd(value: extendedArg + Int(value))
    case let .listAppend(value):
      try self.listAppend(value: extendedArg + Int(value))
    case let .mapAdd(value):
      try self.mapAdd(value: extendedArg + Int(value))
    case let .buildTupleUnpack(elementCount):
      try self.buildTupleUnpack(elementCount: extendedArg + Int(elementCount))
    case let .buildTupleUnpackWithCall(elementCount):
      try self.buildTupleUnpackWithCall(elementCount: extendedArg + Int(elementCount))
    case let .buildListUnpack(elementCount):
      try self.buildListUnpack(elementCount: extendedArg + Int(elementCount))
    case let .buildSetUnpack(elementCount):
      try self.buildSetUnpack(elementCount: extendedArg + Int(elementCount))
    case let .buildMapUnpack(elementCount):
      try self.buildMapUnpack(elementCount: extendedArg + Int(elementCount))
    case let .buildMapUnpackWithCall(elementCount):
      try self.buildMapUnpackWithCall(elementCount: extendedArg + Int(elementCount))
    case let .unpackSequence(elementCount):
      try self.unpackSequence(elementCount: extendedArg + Int(elementCount))
    case let .unpackEx(elementCountBefore):
      try self.unpackEx(elementCountBefore: extendedArg + Int(elementCountBefore))
    case let .loadConst(index):
      try self.loadConst(index: extendedArg + Int(index))
    case let .storeName(nameIndex):
      try self.storeName(nameIndex: extendedArg + Int(nameIndex))
    case let .loadName(nameIndex):
      try self.loadName(nameIndex: extendedArg + Int(nameIndex))
    case let .deleteName(nameIndex):
      try self.deleteName(nameIndex: extendedArg + Int(nameIndex))
    case let .storeAttribute(nameIndex):
      try self.storeAttribute(nameIndex: extendedArg + Int(nameIndex))
    case let .loadAttribute(nameIndex):
      try self.loadAttribute(nameIndex: extendedArg + Int(nameIndex))
    case let .deleteAttribute(nameIndex):
      try self.deleteAttribute(nameIndex: extendedArg + Int(nameIndex))
    case .binarySubscript:
      try self.binarySubscript()
    case .storeSubscript:
      try self.storeSubscript()
    case .deleteSubscript:
      try self.deleteSubscript()
    case let .storeGlobal(nameIndex):
      try self.storeGlobal(nameIndex: extendedArg + Int(nameIndex))
    case let .loadGlobal(nameIndex):
      try self.loadGlobal(nameIndex: extendedArg + Int(nameIndex))
    case let .deleteGlobal(nameIndex):
      try self.deleteGlobal(nameIndex: extendedArg + Int(nameIndex))
    case let .loadFast(nameIndex):
      try self.loadFast(nameIndex: extendedArg + Int(nameIndex))
    case let .storeFast(nameIndex):
      try self.storeFast(nameIndex: extendedArg + Int(nameIndex))
    case let .deleteFast(nameIndex):
      try self.deleteFast(nameIndex: extendedArg + Int(nameIndex))
    case let .loadDeref(nameIndex):
      try self.loadDeref(nameIndex: extendedArg + Int(nameIndex))
    case let .storeDeref(nameIndex):
      try self.storeDeref(nameIndex: extendedArg + Int(nameIndex))
    case let .deleteDeref(nameIndex):
      try self.deleteDeref(nameIndex: extendedArg + Int(nameIndex))
    case let .loadClassDeref(nameIndex):
      try self.loadClassDeref(nameIndex: extendedArg + Int(nameIndex))
    case let .makeFunction(flags):
      assert(extendedArg == 0)
      try self.makeFunction(flags: flags)
    case let .callFunction(argumentCount):
      try self.callFunction(argumentCount: extendedArg + Int(argumentCount))
    case let .callFunctionKw(argumentCount):
      try self.callFunctionKw(argumentCount: extendedArg + Int(argumentCount))
    case let .callFunctionEx(hasKeywordArguments):
      assert(extendedArg == 0)
      try self.callFunctionEx(hasKeywordArguments: hasKeywordArguments)
    case .`return`:
      try self.doReturn()
    case .loadBuildClass:
      try self.loadBuildClass()
    case let .loadMethod(nameIndex):
      try self.loadMethod(nameIndex: extendedArg + Int(nameIndex))
    case let .callMethod(argumentCount):
      try self.callMethod(argumentCount: extendedArg + Int(argumentCount))
    case .importStar:
      try self.importStar()
    case let .importName(nameIndex):
      try self.importName(nameIndex: extendedArg + Int(nameIndex))
    case let .importFrom(nameIndex):
      try self.importFrom(nameIndex: extendedArg + Int(nameIndex))
    case .popExcept:
      try self.popExcept()
    case .endFinally:
      try self.endFinally()
    case let .setupExcept(firstExceptLabel):
      try self.setupExcept(firstExceptLabel: extendedArg + Int(firstExceptLabel))
    case let .setupFinally(finallyStartLabel):
      try self.setupFinally(finallyStartLabel: extendedArg + Int(finallyStartLabel))
    case let .raiseVarargs(arg):
      assert(extendedArg == 0)
      try self.raiseVarargs(arg: arg)
    case let .setupWith(afterBodyLabel):
      try self.setupWith(afterBodyLabel: extendedArg + Int(afterBodyLabel))
    case .withCleanupStart:
      try self.withCleanupStart()
    case .withCleanupFinish:
      try self.withCleanupFinish()
    case .beforeAsyncWith:
      try self.beforeAsyncWith()
    case .setupAsyncWith:
      try self.setupAsyncWith()
    case let .jumpAbsolute(labelIndex):
      try self.jumpAbsolute(labelIndex: extendedArg + Int(labelIndex))
    case let .popJumpIfTrue(labelIndex):
      try self.popJumpIfTrue(labelIndex: extendedArg + Int(labelIndex))
    case let .popJumpIfFalse(labelIndex):
      try self.popJumpIfFalse(labelIndex: extendedArg + Int(labelIndex))
    case let .jumpIfTrueOrPop(labelIndex):
      try self.jumpIfTrueOrPop(labelIndex: extendedArg + Int(labelIndex))
    case let .jumpIfFalseOrPop(labelIndex):
      try self.jumpIfFalseOrPop(labelIndex: extendedArg + Int(labelIndex))
    case let .formatValue(conversion, hasFormat):
      assert(extendedArg == 0)
      try self.formatValue(conversion: conversion, hasFormat: hasFormat)
    case let .buildString(value):
      try self.buildString(count: extendedArg + Int(value))
    case let .extendedArg(value):
      let arg = extendedArg << 8 | Int(value)
      try self.executeInstruction(extendedArg: arg)
    case .setupAnnotations:
      try self.setupAnnotations()
    case .popBlock:
      try self.popBlock()
    case let .loadClosure(cellOrFreeIndex):
      try self.loadClosure(cellOrFreeIndex: extendedArg + Int(cellOrFreeIndex))
    case let .buildSlice(arg):
      try self.buildSlice(arg: arg)
    }
  }
}
