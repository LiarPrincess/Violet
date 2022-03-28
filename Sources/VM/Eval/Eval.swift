import Foundation
import VioletCore
import VioletBytecode
import VioletObjects

// swiftlint:disable weak_delegate
// swiftlint:disable file_length
// cSpell:ignore ceval localsplus

// In CPython:
// Python -> ceval.c

/// This type is a dummy namespace for `eval` function, just so we don't pollute
/// `VM/PyDelegate` with all that nonsense (but don't worry, we use them as a
/// 'catch them all' for all of the code that does not fit anywhere else,
/// so it is still a mess).
///
/// But wait a sec, it gets even worse:
/// It will hold a strong reference to `PyDelegate`!
/// So… just do not store `Eval` as property on `PyDelegate`.
internal struct Eval {

  // MARK: - Properties

  internal let py: Py
  /// Only here so that we can manage `currentlyHandledException`
  private let delegate: PyDelegate
  /// You know… the thing that we are evaluating…
  internal let frame: PyFrame
  /// Code to run.
  internal var code: PyCode

  /// Local variables.
  internal let locals: PyDict
  /// Global variables.
  internal let globals: PyDict
  /// Builtin symbols (most of the time it would be `self.py.builtinsModule.__dict__`).
  internal let builtins: PyDict

  /// Stack of `PyObjects` to be manipulated when executing code.
  internal let stack: PyFrame.ObjectStackProxy
  /// Stack of blocks (`for` loops, `exception` handlers etc.).
  internal let blockStack: PyFrame.BlockStackProxy
  /// Function args and local variables.
  ///
  /// CPython: `f_localsplus`.
  internal let fastLocals: PyFrame.FastLocalsProxy
  /// Cell variables (variables from upper scopes).
  ///
  /// Btw. `Cell` = source for `free` variable.
  /// CPython: `f_lasti`.
  internal let cellVariables: PyFrame.CellVariablesProxy
  /// Free variables (variables from upper scopes).
  ///
  /// Btw. `Free` = cell from upper scope.
  internal let freeVariables: PyFrame.FreeVariablesProxy

  internal var currentlyHandledException: PyBaseException? {
    get { self.delegate.currentlyHandledException }
    nonmutating set { self.delegate.currentlyHandledException = newValue }
  }

  // MARK: - Init

  internal init(_ py: Py, delegate: PyDelegate, frame: PyFrame) {
    self.py = py
    self.delegate = delegate
    self.frame = frame
    self.code = frame.code

    self.locals = frame.locals
    self.globals = frame.globals
    self.builtins = frame.builtins

    self.stack = frame.objectStack
    self.blockStack = frame.blockStack
    self.fastLocals = frame.fastLocals
    self.cellVariables = frame.cellVariables
    self.freeVariables = frame.freeVariables
  }

  // MARK: - Run

  internal func run() -> PyResult {
    defer { self.updatePredictedNextRunStackCount() }

    while true {
      switch self.executeInstruction(extendedArg: 0) {
      case .ok:
        break // go to next instruction

      case .unwind(let reason):
        if case let .exception(exception, fillTracebackEtc) = reason, fillTracebackEtc {
          self.fillContextAndTraceback(exception: exception)
        }

        switch self.unwind(reason: reason) {
        case .continueCodeExecution:
          break
        case .return(let value):
          return PyResult(value)
        case .reportExceptionToParentFrame(let e):
          // 'FromUnwind' means not the one from 'case .unwind(let reason):'
          self.fillContextAndTracebackIfNotExceptionFromUnwind(
            exception: e,
            unwindReason: reason
          )

          let eTraceback = self.py.getTraceback(exception: e)
          let eFrame = eTraceback.map(self.py.getFrame(traceback:))
          assert(eFrame === self.frame)
          return .error(e)
        }
      }
    }
  }

  private func fillContextAndTraceback(exception: PyBaseException) {
    // Context - another exception during whose handling this exception was raised.
    self.py.setContextUsingCurrentlyHandledExceptionFromDelegate(
      on: exception,
      overrideCurrent: false
    )

    // Traceback - stack trace, call stack etc.
    self.py.addTraceback(to: exception, frame: self.frame)
  }

  private func fillContextAndTracebackIfNotExceptionFromUnwind(
    exception: PyBaseException,
    unwindReason: UnwindReason
  ) {
    // Is the same exception as in unwind reason?
    //
    // DO NOT base this check on 'self.frame' and 'current line' being last
    // entries in error traceback! We can raise the same error in a loop:
    // e = BaseException('elsa')
    // for i in range(0, 25):
    //   try:
    //     raise e // will append this frame/line multiple times
    //   except BaseException as ee:
    //     pass

    if case let .exception(e, _) = unwindReason, exception === e {
      return
    }

    self.fillContextAndTraceback(exception: exception)
  }

  private func updatePredictedNextRunStackCount() {
    let stack = self.stack.predictedNextRunCount
    let code = self.code.predictedObjectStackCount
    self.code.predictedObjectStackCount = Swift.max(stack, code)
  }

  // MARK: - Helpers

  internal func getName(function: PyObject) -> String? {
    if let pyName = self.py.getName(function: function) {
      return self.py.strString(pyName)
    }

    return nil
  }

  internal func newTypeError(message: String) -> PyBaseException {
    let error = self.py.newTypeError(message: message)
    return error.asBaseException
  }

  internal func newValueError(message: String) -> PyBaseException {
    let error = self.py.newValueError(message: message)
    return error.asBaseException
  }

  internal func newSystemError(message: String) -> PyBaseException {
    let error = self.py.newSystemError(message: message)
    return error.asBaseException
  }

  // MARK: - Execute instruction

  /// Fetch instruction at `self.frame.instructionIndex`.
  /// Will also increment `PC`
  /// (just as the name… does not suggest, but as is customary).
  private func fetchInstruction() -> Instruction {
    let index = self.frame.nextInstructionIndex
    assert(0 <= index && index < self.code.instructions.count)

    let result = self.code.instructions[index]
    self.frame.currentInstructionIndex = index // for error location etc.
    self.frame.nextInstructionIndex += 1 // pc increment
    return result
  }

  // swiftlint:disable:next function_body_length
  private func executeInstruction(extendedArg: Int) -> InstructionResult {
    Debug.stack(stack: self.stack)
    Debug.stack(stack: self.blockStack)
    Debug.instruction(code: self.code, index: self.frame.nextInstructionIndex)

    if self.delegate.hasKeyboardInterrupt {
      self.delegate.hasKeyboardInterrupt = false // Reset flag, very important!
      let error = self.py.newKeyboardInterrupt()
      return .exception(error.asBaseException)
    }

    let instruction = self.fetchInstruction()

    // According to CPython doing single switch will trash our jump prediction
    // (unless you have the same opcode multiple times in a row).
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

    case .inPlacePower:
      return self.inPlacePower()
    case .inPlaceMultiply:
      return self.inPlaceMultiply()
    case .inPlaceMatrixMultiply:
      return self.inPlaceMatrixMultiply()
    case .inPlaceFloorDivide:
      return self.inPlaceFloorDivide()
    case .inPlaceTrueDivide:
      return self.inPlaceTrueDivide()
    case .inPlaceModulo:
      return self.inPlaceModulo()
    case .inPlaceAdd:
      return self.inPlaceAdd()
    case .inPlaceSubtract:
      return self.inPlaceSubtract()
    case .inPlaceLShift:
      return self.inPlaceLShift()
    case .inPlaceRShift:
      return self.inPlaceRShift()
    case .inPlaceAnd:
      return self.inPlaceAnd()
    case .inPlaceXor:
      return self.inPlaceXor()
    case .inPlaceOr:
      return self.inPlaceOr()

    case let .compareOp(type: type):
      assert(extendedArg == 0)
      return self.compareOp(type: type)

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

    case let .setupLoop(loopEndLabelIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.setupLoop(loopEndLabelIndex: index)
    case let .forIter(ifEmptyLabelIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.forIter(ifEmptyLabelIndex: index)
    case .getIter:
      return self.getIter()
    case .getYieldFromIter:
      return self.getYieldFromIter()
    case .break:
      return self.doBreak()
    case let .continue(loopStartLabelIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.doContinue(loopStartLabelIndex: index)

    case let .buildTuple(elementCount: arg):
      let count = Instruction.extend(base: extendedArg, arg: arg)
      return self.buildTuple(elementCount: count)
    case let .buildList(elementCount: arg):
      let count = Instruction.extend(base: extendedArg, arg: arg)
      return self.buildList(elementCount: count)
    case let .buildSet(elementCount: arg):
      let count = Instruction.extend(base: extendedArg, arg: arg)
      return self.buildSet(elementCount: count)
    case let .buildMap(elementCount: arg):
      let count = Instruction.extend(base: extendedArg, arg: arg)
      return self.buildMap(elementCount: count)
    case let .buildConstKeyMap(elementCount: arg):
      let count = Instruction.extend(base: extendedArg, arg: arg)
      return self.buildConstKeyMap(elementCount: count)

    case let .setAdd(relativeStackIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.setAdd(stackIndex: index)
    case let .listAppend(relativeStackIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.listAdd(stackIndex: index)
    case let .mapAdd(relativeStackIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.mapAdd(stackIndex: index)

    case let .buildTupleUnpack(elementCount: arg):
      let count = Instruction.extend(base: extendedArg, arg: arg)
      return self.buildTupleUnpack(elementCount: count)
    case let .buildTupleUnpackWithCall(elementCount: arg):
      let count = Instruction.extend(base: extendedArg, arg: arg)
      return self.buildTupleUnpackWithCall(elementCount: count)
    case let .buildListUnpack(elementCount: arg):
      let count = Instruction.extend(base: extendedArg, arg: arg)
      return self.buildListUnpack(elementCount: count)
    case let .buildSetUnpack(elementCount: arg):
      let count = Instruction.extend(base: extendedArg, arg: arg)
      return self.buildSetUnpack(elementCount: count)
    case let .buildMapUnpack(elementCount: arg):
      let count = Instruction.extend(base: extendedArg, arg: arg)
      return self.buildMapUnpack(elementCount: count)
    case let .buildMapUnpackWithCall(elementCount: arg):
      let count = Instruction.extend(base: extendedArg, arg: arg)
      return self.buildMapUnpackWithCall(elementCount: count)
    case let .unpackSequence(elementCount: arg):
      let count = Instruction.extend(base: extendedArg, arg: arg)
      return self.unpackSequence(elementCount: count)
    case let .unpackEx(arg: arg):
      let extended = Instruction.extend(base: extendedArg, arg: arg)
      let decoded = Instruction.UnpackExArg(value: extended)
      return self.unpackEx(arg: decoded)

    case let .loadConst(index: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.loadConst(index: index)

    case let .storeName(nameIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.storeName(nameIndex: index)
    case let .loadName(nameIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.loadName(nameIndex: index)
    case let .deleteName(nameIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.deleteName(nameIndex: index)

    case let .storeAttribute(nameIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.storeAttribute(nameIndex: index)
    case let .loadAttribute(nameIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.loadAttribute(nameIndex: index)
    case let .deleteAttribute(nameIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.deleteAttribute(nameIndex: index)

    case .binarySubscript:
      return self.binarySubscript()
    case .storeSubscript:
      return self.storeSubscript()
    case .deleteSubscript:
      return self.deleteSubscript()

    case let .storeGlobal(nameIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.storeGlobal(nameIndex: index)
    case let .loadGlobal(nameIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.loadGlobal(nameIndex: index)
    case let .deleteGlobal(nameIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.deleteGlobal(nameIndex: index)

    case let .loadFast(variableIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.loadFast(index: index)
    case let .storeFast(variableIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.storeFast(index: index)
    case let .deleteFast(variableIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.deleteFast(index: index)

    case let .loadCell(cellIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.loadCell(index: index)
    case let .storeCell(cellIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.storeCell(index: index)
    case let .deleteCell(cellIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.deleteCell(index: index)

    case let .loadFree(freeIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.loadFree(index: index)
    case let .storeFree(freeIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.storeFree(index: index)
    case let .deleteFree(freeIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.deleteFree(index: index)
    case let .loadClassFree(freeIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.loadClassFree(index: index)

    case let .loadClosure(cellOrFreeIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.loadClosure(cellOrFreeIndex: index)

    case let .makeFunction(flags: flags):
      assert(extendedArg == 0)
      return self.makeFunction(flags: flags)
    case let .callFunction(argumentCount: arg):
      let argCount = Instruction.extend(base: extendedArg, arg: arg)
      return self.callFunction(argumentCount: argCount)
    case let .callFunctionKw(argumentCount: arg):
      let argCount = Instruction.extend(base: extendedArg, arg: arg)
      return self.callFunctionKw(argumentCount: argCount)
    case let .callFunctionEx(hasKeywordArguments: hasKeywordArguments):
      assert(extendedArg == 0)
      return self.callFunctionEx(hasKeywordArguments: hasKeywordArguments)

    case .return:
      return self.doReturn()

    case .loadBuildClass:
      return self.loadBuildClass()

    case let .loadMethod(nameIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.loadMethod(nameIndex: index)
    case let .callMethod(argumentCount: arg):
      let argCount = Instruction.extend(base: extendedArg, arg: arg)
      return self.callMethod(argumentCount: argCount)

    case .importStar:
      return self.importStar()
    case let .importName(nameIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.importName(nameIndex: index)
    case let .importFrom(nameIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.importFrom(nameIndex: index)

    case .popExcept:
      return self.popExcept()
    case .endFinally:
      return self.endFinally()
    case let .setupExcept(firstExceptLabelIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.setupExcept(firstExceptLabelIndex: index)
    case let .setupFinally(finallyStartLabelIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.setupFinally(finallyStartLabelIndex: index)

    case let .raiseVarargs(type: arg):
      assert(extendedArg == 0)
      return self.raiseVarargs(arg: arg)

    case let .setupWith(afterBodyLabelIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.setupWith(afterBodyLabelIndex: index)
    case .withCleanupStart:
      return self.withCleanupStart()
    case .withCleanupFinish:
      return self.withCleanupFinish()
    case .beforeAsyncWith:
      return self.beforeAsyncWith()
    case .setupAsyncWith:
      return self.setupAsyncWith()

    case let .jumpAbsolute(labelIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.jumpAbsolute(labelIndex: index)

    case let .popJumpIfTrue(labelIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.popJumpIfTrue(labelIndex: index)
    case let .popJumpIfFalse(labelIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.popJumpIfFalse(labelIndex: index)
    case let .jumpIfTrueOrPop(labelIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.jumpIfTrueOrPop(labelIndex: index)
    case let .jumpIfFalseOrPop(labelIndex: arg):
      let index = Instruction.extend(base: extendedArg, arg: arg)
      return self.jumpIfFalseOrPop(labelIndex: index)

    case let .formatValue(conversion: conversion, hasFormat: hasFormat):
      assert(extendedArg == 0)
      return self.formatValue(conversion: conversion, hasFormat: hasFormat)

    case let .buildString(elementCount: arg):
      let count = Instruction.extend(base: extendedArg, arg: arg)
      return self.buildString(count: count)

    case let .extendedArg(arg):
      let extended = Instruction.extend(base: extendedArg, arg: arg)
      return self.executeInstruction(extendedArg: extended)

    case .setupAnnotations:
      return self.setupAnnotations()
    case .popBlock:
      return self.popBlockInstruction()
    case let .buildSlice(type: arg):
      return self.buildSlice(arg: arg)
    }
  }
}
