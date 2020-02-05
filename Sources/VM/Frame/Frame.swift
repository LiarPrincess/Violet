import Core
import Foundation
import Bytecode
import Objects

// In CPython:
// Python -> ceval.c

// swiftlint:disable file_length

// MARK: - Instruction result

/// Result of running of a single instruction.
internal enum InstructionResult {
  /// Instruction executed succesfully.
  case ok
  /// Instruction requested a `break`.
  /// We will unwind stopping at nearest loop.
  case `break`
  /// Instruction requested a `return` from a current frame.
  /// We will unwind and the return `value`.
  case `return`(PyObject)
  /// Instruction raised an error.
  /// We will unwind trying to handle it.
  case error(PyBaseException)
}

// MARK: - Frame

internal final class Frame {

  /// Code to run.
  internal let code: CodeObject
  /// Parent frame.
  internal let parent: Frame?

  /// Stack of `PyObjects`.
  internal var stack = ObjectStack()
  /// Stack of blocks.
  internal var blocks = BlockStack()
  /// Stack of exceptions.
  internal var exceptions = ExceptionStack()

  /// Local variables.
  internal var localSymbols: Attributes
  /// Global variables.
  internal var globalSymbols: Attributes
  /// Builtin symbols (most of the time it would be `Py.builtinsModule.__dict__`).
  internal var builtinSymbols: Attributes
  /// Free variables (variables from upper scopes).
  internal lazy var freeVariables = [String: PyObject]()
  /// Function args and local variables.
  ///
  /// We could use `self.localSymbols` but that would be `O(1)` with
  /// massive constants.
  /// We use array which is like dictionary, but with lower constants.
  /// We could also put them at the bottom of our stack (like in other languages),
  /// but as 'the hipster trash that we are' (quote from @bestdressed)
  /// we won't do this.
  internal lazy var fastLocals = [PyObject?](repeating: nil,
                                             count: code.varNames.count)

  /// Index of the next instruction to run (program counter).
  internal var nextInstructionIndex = 0

  /// PyFrameObject* _Py_HOT_FUNCTION
  /// _PyFrame_New_NoTrack(PyThreadState *tstate, PyCodeObject *code,
  internal init(code: CodeObject,
                locals: Attributes,
                globals: Attributes,
                parent: Frame?) {
    self.code = code
    self.parent = parent
    self.localSymbols = locals
    self.globalSymbols = globals
    self.builtinSymbols = Frame.getBuiltins(globals: globals, parent: parent)
  }

  private static func getBuiltins(globals: Attributes,
                                  parent: Frame?) -> Attributes {

    if parent == nil || parent?.globalSymbols !== globals {
      if let module = globals.get(key: "__builtins__") as? PyModule {
        return module.getDict()
      }
    }

    return Py.builtinsModule.getDict()
  }

  // MARK: - Helpers

  internal var stackLevel: Int {
    return self.stack.count
  }

  internal func getLabel(index: Int) -> Int {
    assert(0 <= index && index < self.code.labels.count)
    return self.code.labels[index]
  }

  // MARK: - Run

  internal func run() -> PyResult<PyObject> {
    // TODO: When we 'case .error(let e):' unwind remaining blocks?
    while self.nextInstructionIndex != self.code.instructions.endIndex {
      switch self.executeInstruction() {
      case .ok:
        // Just go to next instruction
        break
      case .break:
        // Ok -> go to next instruction;
        switch self.unwind(reason: .break) {
        case .ok: break
        case .error(let e): return .error(e)
        }
      case .return(let value):
        // Unwind will unwind all blocks -> then just return
        switch self.unwind(reason: .return(value)) {
        case .ok: return .value(value)
        case .error(let e): return .error(e)
        }
      case .error(let e):
        switch self.unwind(reason: .exception(e)) {
        case .ok: break
        case .error(let e): return .error(e)
        }
      }
    }

    return .value(Py.none)
  }

  private func fetchInstruction() -> Instruction {
    assert(self.nextInstructionIndex >= 0)
    assert(self.nextInstructionIndex < self.code.instructions.count)

    let instr = self.code.instructions[self.nextInstructionIndex]
    self.nextInstructionIndex += 1
    return instr
  }

  // swiftlint:disable:next function_body_length
  private func executeInstruction(extendedArg: Int = 0) -> InstructionResult {
    let instruction = self.fetchInstruction()
    self.instructionDebug(instruction: instruction, extendedArg: extendedArg)

    // According to CPython doing single switch will trash our jump prediction
    // (unles you have the same opcode multiple times in a row).
    // It is a valid concern, but we don't care about this (for now).
    switch instruction {
    case .nop:
      return .ok
    case .popTop:
      return self.popTop()
    case .rotTwo:
      return self.rotTwo()
    case .rotThree:
      return self.rotThree()
    case .dupTop:
      return self.dupTop()
    case .dupTopTwo:
      return self.dupTopTwo()
    case .unaryPositive:
      return self.unaryPositive()
    case .unaryNegative:
      return self.unaryNegative()
    case .unaryNot:
      return self.unaryNot()
    case .unaryInvert:
      return self.unaryInvert()
    case .binaryPower:
      return self.binaryPower()
    case .binaryMultiply:
      return self.binaryMultiply()
    case .binaryMatrixMultiply:
      return self.binaryMatrixMultiply()
    case .binaryFloorDivide:
      return self.binaryFloorDivide()
    case .binaryTrueDivide:
      return self.binaryTrueDivide()
    case .binaryModulo:
      return self.binaryModulo()
    case .binaryAdd:
      return self.binaryAdd()
    case .binarySubtract:
      return self.binarySubtract()
    case .binaryLShift:
      return self.binaryLShift()
    case .binaryRShift:
      return self.binaryRShift()
    case .binaryAnd:
      return self.binaryAnd()
    case .binaryXor:
      return self.binaryXor()
    case .binaryOr:
      return self.binaryOr()
    case .inplacePower:
      return self.inplacePower()
    case .inplaceMultiply:
      return self.inplaceMultiply()
    case .inplaceMatrixMultiply:
      return self.inplaceMatrixMultiply()
    case .inplaceFloorDivide:
      return self.inplaceFloorDivide()
    case .inplaceTrueDivide:
      return self.inplaceTrueDivide()
    case .inplaceModulo:
      return self.inplaceModulo()
    case .inplaceAdd:
      return self.inplaceAdd()
    case .inplaceSubtract:
      return self.inplaceSubtract()
    case .inplaceLShift:
      return self.inplaceLShift()
    case .inplaceRShift:
      return self.inplaceRShift()
    case .inplaceAnd:
      return self.inplaceAnd()
    case .inplaceXor:
      return self.inplaceXor()
    case .inplaceOr:
      return self.inplaceOr()
    case let .compareOp(comparison):
      assert(extendedArg == 0)
      return self.compareOp(comparison: comparison)
    case .getAwaitable:
      return self.getAwaitable()
    case .getAIter:
      return self.getAIter()
    case .getANext:
      return self.getANext()
    case .yieldValue:
      return self.yieldValue()
    case .yieldFrom:
      return self.yieldFrom()
    case .printExpr:
      return self.printExpr()
    case let .setupLoop(loopEndLabel):
      let extended = self.extend(base: extendedArg, arg: loopEndLabel)
      return self.setupLoop(loopEndLabelIndex: extended)
    case let .forIter(ifEmptyLabel):
      let extended = self.extend(base: extendedArg, arg: ifEmptyLabel)
      return self.forIter(ifEmptyLabelIndex: extended)
    case .getIter:
      return self.getIter()
    case .getYieldFromIter:
      return self.getYieldFromIter()
    case .`break`:
      return self.doBreak()
    case let .buildTuple(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.buildTuple(elementCount: extended)
    case let .buildList(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.buildList(elementCount: extended)
    case let .buildSet(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.buildSet(elementCount: extended)
    case let .buildMap(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.buildMap(elementCount: extended)
    case let .buildConstKeyMap(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.buildConstKeyMap(elementCount: extended)
    case let .setAdd(value):
      let extended = self.extend(base: extendedArg, arg: value)
      return self.setAdd(value: extended)
    case let .listAppend(value):
      let extended = self.extend(base: extendedArg, arg: value)
      return self.listAdd(value: extended)
    case let .mapAdd(value):
      let extended = self.extend(base: extendedArg, arg: value)
      return self.mapAdd(value: extended)
    case let .buildTupleUnpack(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.buildTupleUnpack(elementCount: extended)
    case let .buildTupleUnpackWithCall(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.buildTupleUnpackWithCall(elementCount: extended)
    case let .buildListUnpack(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.buildListUnpack(elementCount: extended)
    case let .buildSetUnpack(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.buildSetUnpack(elementCount: extended)
    case let .buildMapUnpack(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.buildMapUnpack(elementCount: extended)
    case let .buildMapUnpackWithCall(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.buildMapUnpackWithCall(elementCount: extended)
    case let .unpackSequence(elementCount):
      let extended = self.extend(base: extendedArg, arg: elementCount)
      return self.unpackSequence(elementCount: extended)
    case let .unpackEx(elementCountBefore):
      let extended = self.extend(base: extendedArg, arg: elementCountBefore)
      return self.unpackEx(elementCountBefore: extended)
    case let .loadConst(index):
      let extended = self.extend(base: extendedArg, arg: index)
      return self.loadConst(index: extended)
    case let .storeName(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.storeName(nameIndex: extended)
    case let .loadName(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.loadName(nameIndex: extended)
    case let .deleteName(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.deleteName(nameIndex: extended)
    case let .storeAttribute(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.storeAttribute(nameIndex: extended)
    case let .loadAttribute(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.loadAttribute(nameIndex: extended)
    case let .deleteAttribute(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.deleteAttribute(nameIndex: extended)
    case .binarySubscript:
      return self.binarySubscript()
    case .storeSubscript:
      return self.storeSubscript()
    case .deleteSubscript:
      return self.deleteSubscript()
    case let .storeGlobal(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.storeGlobal(nameIndex: extended)
    case let .loadGlobal(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.loadGlobal(nameIndex: extended)
    case let .deleteGlobal(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.deleteGlobal(nameIndex: extended)
    case let .loadFast(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.loadFast(index: extended)
    case let .storeFast(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.storeFast(index: extended)
    case let .deleteFast(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.deleteFast(index: extended)
    case let .loadDeref(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.loadDeref(nameIndex: extended)
    case let .storeDeref(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.storeDeref(nameIndex: extended)
    case let .deleteDeref(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.deleteDeref(nameIndex: extended)
    case let .loadClassDeref(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.loadClassDeref(nameIndex: extended)
    case let .makeFunction(flags):
      assert(extendedArg == 0)
      return self.makeFunction(flags: flags)
    case let .callFunction(argumentCount):
      let extended = self.extend(base: extendedArg, arg: argumentCount)
      return self.callFunction(argumentCount: extended)
    case let .callFunctionKw(argumentCount):
      let extended = self.extend(base: extendedArg, arg: argumentCount)
      return self.callFunctionKw(argumentCount: extended)
    case let .callFunctionEx(hasKeywordArguments):
      assert(extendedArg == 0)
      return self.callFunctionEx(hasKeywordArguments: hasKeywordArguments)
    case .`return`:
      return self.doReturn()
    case .loadBuildClass:
      return self.loadBuildClass()
    case let .loadMethod(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.loadMethod(nameIndex: extended)
    case let .callMethod(argumentCount):
      let extended = self.extend(base: extendedArg, arg: argumentCount)
      return self.callMethod(argumentCount: extended)
    case .importStar:
      return self.importStar()
    case let .importName(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.importName(nameIndex: extended)
    case let .importFrom(nameIndex):
      let extended = self.extend(base: extendedArg, arg: nameIndex)
      return self.importFrom(nameIndex: extended)
    case .popExcept:
      return self.popExcept()
    case .endFinally:
      return self.endFinally()
    case let .setupExcept(firstExceptLabel):
      let extended = self.extend(base: extendedArg, arg: firstExceptLabel)
      return self.setupExcept(firstExceptLabelIndex: extended)
    case let .setupFinally(finallyStartLabel):
      let extended = self.extend(base: extendedArg, arg: finallyStartLabel)
      return self.setupFinally(finallyStartLabelIndex: extended)
    case let .raiseVarargs(arg):
      assert(extendedArg == 0)
      return self.raiseVarargs(arg: arg)
    case let .setupWith(afterBodyLabel):
      let extended = self.extend(base: extendedArg, arg: afterBodyLabel)
      return self.setupWith(afterBodyLabelIndex: extended)
    case .withCleanupStart:
      return self.withCleanupStart()
    case .withCleanupFinish:
      return self.withCleanupFinish()
    case .beforeAsyncWith:
      return self.beforeAsyncWith()
    case .setupAsyncWith:
      return self.setupAsyncWith()
    case let .jumpAbsolute(labelIndex):
      let extended = self.extend(base: extendedArg, arg: labelIndex)
      return self.jumpAbsolute(labelIndex: extended)
    case let .popJumpIfTrue(labelIndex):
      let extended = self.extend(base: extendedArg, arg: labelIndex)
      return self.popJumpIfTrue(labelIndex: extended)
    case let .popJumpIfFalse(labelIndex):
      let extended = self.extend(base: extendedArg, arg: labelIndex)
      return self.popJumpIfFalse(labelIndex: extended)
    case let .jumpIfTrueOrPop(labelIndex):
      let extended = self.extend(base: extendedArg, arg: labelIndex)
      return self.jumpIfTrueOrPop(labelIndex: extended)
    case let .jumpIfFalseOrPop(labelIndex):
      let extended = self.extend(base: extendedArg, arg: labelIndex)
      return self.jumpIfFalseOrPop(labelIndex: extended)
    case let .formatValue(conversion, hasFormat):
      assert(extendedArg == 0)
      return self.formatValue(conversion: conversion, hasFormat: hasFormat)
    case let .buildString(arg):
      let extended = self.extend(base: extendedArg, arg: arg)
      return self.buildString(count: extended)
    case let .extendedArg(value):
      let extended = self.extend(base: extendedArg, arg: value)
      return self.executeInstruction(extendedArg: extended)
    case .setupAnnotations:
      return self.setupAnnotations()
    case .popBlock:
      return self.popBlock()
    case let .loadClosure(cellOrFreeIndex):
      let extended = self.extend(base: extendedArg, arg: cellOrFreeIndex)
      return self.loadClosure(cellOrFreeIndex: extended)
    case let .buildSlice(arg):
      return self.buildSlice(arg: arg)
    }
  }

  private func extend(base: Int, arg: UInt8) -> Int {
    return base << 8 | Int(arg)
  }
}
