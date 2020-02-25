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
  /// Instruction requested stack unwind (`return`, `exception` etc.).
  case unwind(UnwindReason)
}

// MARK: - Frame

internal final class Frame {

  /// Code to run.
  internal let code: CodeObject
  /// Parent frame.
  internal let parent: Frame?

  /// Stack of `PyObjects`.
  internal var stack = ObjectStack()
  /// Stack of blocks (for loops, exception handlers etc.).
  internal var blocks = BlockStack()
  /// Stack of exceptions.
  internal var exceptions = ExceptionStack()

  /// Local variables.
  internal var localSymbols: PyDict
  /// Global variables.
  internal var globalSymbols: PyDict
  /// Builtin symbols (most of the time it would be `Py.builtinsModule.__dict__`).
  internal var builtinSymbols: PyDict
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
                                             count: code.variableNames.count)

  /// Index of the next instruction to run (program counter).
  internal var nextInstructionIndex = 0

  /// PyFrameObject* _Py_HOT_FUNCTION
  /// _PyFrame_New_NoTrack(PyThreadState *tstate, PyCodeObject *code,
  internal init(code: CodeObject,
                locals: PyDict,
                globals: PyDict,
                parent: Frame?) {
    self.code = code
    self.parent = parent
    self.localSymbols = locals
    self.globalSymbols = globals
    self.builtinSymbols = Frame.getBuiltins(globals: globals, parent: parent)
  }

  private static func getBuiltins(globals: PyDict,
                                  parent: Frame?) -> PyDict {
    if parent == nil || parent?.globalSymbols !== globals {
      if let module = globals.getItem(id: .__builtins__) as? PyModule {
        return module.getDict()
      }
    }

    // If we share the globals, we share the builtins.
    // Saves a lookup and a call.
    return Py.builtinsModule.getDict()
  }

  // MARK: - Helpers

  internal var stackLevel: Int {
    return self.stack.count
  }

  // MARK: - Code object getters

  internal func getName(index: Int) -> PyString {
    // TODO: If we store 'PyStrings' in code object we will improve performance
    // But since 'Objects' have reference to 'Bytecode' we can't add reference
    // from 'Bytecode' to 'Objects'.

    assert(0 <= index && index < self.code.names.count)
    let value = self.code.names[index]
    return Py.getInterned(value)
  }

  internal func getConstant(index: Int) -> Constant {
    assert(0 <= index && index < self.code.constants.count)
    return self.code.constants[index]
  }

  internal func getLabel(index: Int) -> Int {
    // In all of the dumps/prints we multiply by 'Instruction.byteSize'.
    // We don't have to it here because 'index' is already instruction index.

    assert(0 <= index && index < self.code.labels.count)
    return self.code.labels[index]
  }

  // MARK: - Run

  internal func run() -> PyResult<PyObject> {
    while true {
      switch self.executeInstruction() {
      case .ok:
        break // go to next instruction
      case .unwind(let reason):
        self.addExceptionContextIfNeeded(reason)
        self.unwind(reason: reason)

        // If we still have some blocks then continue loop.
        // It may happen for break/except/finally blocks
        // (they would just jump to other part of the code and continue execution).
        if self.blocks.any {
          break // continue loop
        }

        // No blocks! (kinda 'yay', kinda scarry)
        assert(self.blocks.isEmpty)
        switch reason {
        case .return(let object):
          return .value(object)
        case .break:
          // We popped top level loop, we can continue execution
          break
        case .continue,
             .exception,
             .yield,
             .silenced:
          let pc = Swift.max(self.nextInstructionIndex - 1, 0)
          let line = self.code.instructionLines[pc]

          print()
          print("===")
          print("Popped all blocks, but this still remains: '\(reason)'")
          print("Instruction:", pc)
          print("Line:", line)
          exit(1)
        }
      }
    }
  }

  /// Context - another exception during whose handling this exception was raised.
  private func addExceptionContextIfNeeded(_ reason: UnwindReason) {
    guard case let UnwindReason.exception(exception) = reason else {
      return
    }

    let currentContext = exception.getContext()
    let isCurrentContextNilOrNone = currentContext?.isNone ?? true
    guard isCurrentContextNilOrNone else {
      return
    }

    guard let currentException = self.exceptions.current else {
      return
    }

    exception.setContext(currentException)
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
    Debug.stack(stack: self.stack)
    Debug.stack(stack: self.blocks)
    let instruction = self.fetchInstruction()
    Debug.instruction(code: self.code,
                      instruction: instruction,
                      extendedArg: extendedArg)

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
    case let .continue(loopStartLabel):
      let extended = self.extend(base: extendedArg, arg: loopStartLabel)
      return self.doContinue(loopStartLabelIndex: extended)
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
    case let .unpackEx(arg):
      let extended = self.extend(base: extendedArg, arg: arg)
      let decoded = UnpackExArg(value: extended)
      return self.unpackEx(arg: decoded)
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
