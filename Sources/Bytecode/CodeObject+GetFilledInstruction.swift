// This file is basically a one giant 'switch' on every instruction.
// swiftlint:disable function_body_length

extension CodeObject {

  public struct FilledInstruction: CustomStringConvertible {
    public let instruction: Instruction.Filled
    public let nextInstructionIndex: Int?

    public var description: String {
      return String(describing: self.instruction)
    }
  }

  /// Get instruction with proper typed argument.
  ///
  /// Can be used for utility functionality (like printing),
  /// but the performance is not adequate for `VM` use.
  public func getFilledInstruction(index: Int) -> FilledInstruction {
    return self.getFilledInstruction(index: index, extendedArg: 0)
  }

  private func getFilledInstruction(index: Int,
                                    extendedArg: Int) -> FilledInstruction {
    func wrap(_ value: Instruction.Filled) -> FilledInstruction {
      let nextIndex = index + 1
      let validNextIndex = nextIndex == self.instructions.count ? nil : nextIndex
      return FilledInstruction(instruction: value, nextInstructionIndex: validNextIndex)
    }

    let instruction = self.instructions[index]
    switch instruction {
    case .nop:
      return wrap(.nop)

    case .popTop:
      return wrap(.popTop)
    case .rotTwo:
      return wrap(.rotTwo)
    case .rotThree:
      return wrap(.rotThree)
    case .dupTop:
      return wrap(.dupTop)
    case .dupTopTwo:
      return wrap(.dupTopTwo)

    case .unaryPositive:
      return wrap(.unaryPositive)
    case .unaryNegative:
      return wrap(.unaryNegative)
    case .unaryNot:
      return wrap(.unaryNot)
    case .unaryInvert:
      return wrap(.unaryInvert)

    case .binaryPower:
      return wrap(.binaryPower)
    case .binaryMultiply:
      return wrap(.binaryMultiply)
    case .binaryMatrixMultiply:
      return wrap(.binaryMatrixMultiply)
    case .binaryFloorDivide:
      return wrap(.binaryFloorDivide)
    case .binaryTrueDivide:
      return wrap(.binaryTrueDivide)
    case .binaryModulo:
      return wrap(.binaryModulo)
    case .binaryAdd:
      return wrap(.binaryAdd)
    case .binarySubtract:
      return wrap(.binarySubtract)
    case .binaryLShift:
      return wrap(.binaryLShift)
    case .binaryRShift:
      return wrap(.binaryRShift)
    case .binaryAnd:
      return wrap(.binaryAnd)
    case .binaryXor:
      return wrap(.binaryXor)
    case .binaryOr:
      return wrap(.binaryOr)

    case .inPlacePower:
      return wrap(.inPlacePower)
    case .inPlaceMultiply:
      return wrap(.inPlaceMultiply)
    case .inPlaceMatrixMultiply:
      return wrap(.inPlaceMatrixMultiply)
    case .inPlaceFloorDivide:
      return wrap(.inPlaceFloorDivide)
    case .inPlaceTrueDivide:
      return wrap(.inPlaceTrueDivide)
    case .inPlaceModulo:
      return wrap(.inPlaceModulo)
    case .inPlaceAdd:
      return wrap(.inPlaceAdd)
    case .inPlaceSubtract:
      return wrap(.inPlaceSubtract)
    case .inPlaceLShift:
      return wrap(.inPlaceLShift)
    case .inPlaceRShift:
      return wrap(.inPlaceRShift)
    case .inPlaceAnd:
      return wrap(.inPlaceAnd)
    case .inPlaceXor:
      return wrap(.inPlaceXor)
    case .inPlaceOr:
      return wrap(.inPlaceOr)

    case let .compareOp(type: type):
      assert(extendedArg == 0)
      return wrap(.compareOp(type: type))

    case .getAwaitable:
      return wrap(.getAwaitable)
    case .getAIter:
      return wrap(.getAIter)
    case .getANext:
      return wrap(.getANext)
    case .yieldValue:
      return wrap(.yieldValue)
    case .yieldFrom:
      return wrap(.yieldFrom)

    case .printExpr:
      return wrap(.printExpr)

    case let .setupLoop(loopEndLabelIndex: arg):
      let label = self.getLabel(extendedArg: extendedArg, arg: arg)
      return wrap(.setupLoop(loopEndLabel: label))
    case let .forIter(ifEmptyLabelIndex: arg):
      let label = self.getLabel(extendedArg: extendedArg, arg: arg)
      return wrap(.forIter(ifEmptyLabel: label))
    case .getIter:
      return wrap(.getIter)
    case .getYieldFromIter:
      return wrap(.getYieldFromIter)
    case .break:
      return wrap(.break)
    case let .continue(loopStartLabelIndex: arg):
      let label = self.getLabel(extendedArg: extendedArg, arg: arg)
      return wrap(.continue(loopStartLabel: label))

    case let .buildTuple(elementCount: arg):
      let extended = self.extend(base: extendedArg, arg: arg)
      return wrap(.buildTuple(elementCount: extended))
    case let .buildList(elementCount: arg):
      let extended = self.extend(base: extendedArg, arg: arg)
      return wrap(.buildList(elementCount: extended))
    case let .buildSet(elementCount: arg):
      let extended = self.extend(base: extendedArg, arg: arg)
      return wrap(.buildSet(elementCount: extended))
    case let .buildMap(elementCount: arg):
      let extended = self.extend(base: extendedArg, arg: arg)
      return wrap(.buildMap(elementCount: extended))
    case let .buildConstKeyMap(elementCount: arg):
      let extended = self.extend(base: extendedArg, arg: arg)
      return wrap(.buildConstKeyMap(elementCount: extended))

    case let .setAdd(relativeStackIndex: arg):
      let index = self.extend(base: extendedArg, arg: arg)
      return wrap(.setAdd(relativeStackIndex: index))
    case let .listAppend(relativeStackIndex: arg):
      let index = self.extend(base: extendedArg, arg: arg)
      return wrap(.listAppend(relativeStackIndex: index))
    case let .mapAdd(relativeStackIndex: arg):
      let index = self.extend(base: extendedArg, arg: arg)
      return wrap(.mapAdd(relativeStackIndex: index))

    case let .buildTupleUnpack(elementCount: arg):
      let count = self.extend(base: extendedArg, arg: arg)
      return wrap(.buildTupleUnpack(elementCount: count))
    case let .buildTupleUnpackWithCall(elementCount: arg):
      let count = self.extend(base: extendedArg, arg: arg)
      return wrap(.buildTupleUnpackWithCall(elementCount: count))
    case let .buildListUnpack(elementCount: arg):
      let count = self.extend(base: extendedArg, arg: arg)
      return wrap(.buildListUnpack(elementCount: count))
    case let .buildSetUnpack(elementCount: arg):
      let count = self.extend(base: extendedArg, arg: arg)
      return wrap(.buildSetUnpack(elementCount: count))
    case let .buildMapUnpack(elementCount: arg):
      let count = self.extend(base: extendedArg, arg: arg)
      return wrap(.buildMapUnpack(elementCount: count))
    case let .buildMapUnpackWithCall(elementCount: arg):
      let count = self.extend(base: extendedArg, arg: arg)
      return wrap(.buildMapUnpackWithCall(elementCount: count))
    case let .unpackSequence(elementCount: arg):
      let count = self.extend(base: extendedArg, arg: arg)
      return wrap(.unpackSequence(elementCount: count))
    case let .unpackEx(arg: arg):
      let extended = self.extend(base: extendedArg, arg: arg)
      let decoded = Instruction.UnpackExArg(value: extended)
      return wrap(.unpackEx(arg: decoded))

    case let .loadConst(index: arg):
      let constant = self.getConstant(extendedArg: extendedArg, arg: arg)
      return wrap(.loadConst(constant))

    case let .storeName(nameIndex: arg):
      let name = self.getName(extendedArg: extendedArg, arg: arg)
      return wrap(.storeName(name: name))
    case let .loadName(nameIndex: arg):
      let name = self.getName(extendedArg: extendedArg, arg: arg)
      return wrap(.loadName(name: name))
    case let .deleteName(nameIndex: arg):
      let name = self.getName(extendedArg: extendedArg, arg: arg)
      return wrap(.deleteName(name: name))

    case let .storeAttribute(nameIndex: arg):
      let name = self.getName(extendedArg: extendedArg, arg: arg)
      return wrap(.storeAttribute(name: name))
    case let .loadAttribute(nameIndex: arg):
      let name = self.getName(extendedArg: extendedArg, arg: arg)
      return wrap(.loadAttribute(name: name))
    case let .deleteAttribute(nameIndex: arg):
      let name = self.getName(extendedArg: extendedArg, arg: arg)
      return wrap(.deleteAttribute(name: name))

    case .binarySubscript:
      return wrap(.binarySubscript)
    case .storeSubscript:
      return wrap(.storeSubscript)
    case .deleteSubscript:
      return wrap(.deleteSubscript)

    case let .storeGlobal(nameIndex: arg):
      let name = self.getName(extendedArg: extendedArg, arg: arg)
      return wrap(.storeGlobal(name: name))
    case let .loadGlobal(nameIndex: arg):
      let name = self.getName(extendedArg: extendedArg, arg: arg)
      return wrap(.loadGlobal(name: name))
    case let .deleteGlobal(nameIndex: arg):
      let name = self.getName(extendedArg: extendedArg, arg: arg)
      return wrap(.deleteGlobal(name: name))

    case let .loadFast(variableIndex: arg):
      let name = self.getVariable(extendedArg: extendedArg, arg: arg)
      return wrap(.loadFast(variable: name))
    case let .storeFast(variableIndex: arg):
      let name = self.getVariable(extendedArg: extendedArg, arg: arg)
      return wrap(.storeFast(variable: name))
    case let .deleteFast(variableIndex: arg):
      let name = self.getVariable(extendedArg: extendedArg, arg: arg)
      return wrap(.deleteFast(variable: name))

    case let .loadCell(cellIndex: arg):
      let name = self.getCell(extendedArg: extendedArg, arg: arg)
      return wrap(.loadCell(cell: name))
    case let .storeCell(cellIndex: arg):
      let name = self.getCell(extendedArg: extendedArg, arg: arg)
      return wrap(.storeCell(cell: name))
    case let .deleteCell(cellIndex: arg):
      let name = self.getCell(extendedArg: extendedArg, arg: arg)
      return wrap(.deleteCell(cell: name))

    case let .loadFree(freeIndex: arg):
      let name = self.getFree(extendedArg: extendedArg, arg: arg)
      return wrap(.loadFree(free: name))
    case let .storeFree(freeIndex: arg):
      let name = self.getFree(extendedArg: extendedArg, arg: arg)
      return wrap(.storeFree(free: name))
    case let .deleteFree(freeIndex: arg):
      let name = self.getFree(extendedArg: extendedArg, arg: arg)
      return wrap(.deleteFree(free: name))
    case let .loadClassFree(freeIndex: arg):
      let name = self.getFree(extendedArg: extendedArg, arg: arg)
      return wrap(.loadClassFree(free: name))

    case let .loadClosure(cellOrFreeIndex: arg):
      let name = self.getCellOrFree(extendedArg: extendedArg, arg: arg)
      return wrap(.loadClosure(cellOrFree: name))

    case let .makeFunction(flags: flags):
      assert(extendedArg == 0)
      return wrap(.makeFunction(flags: flags))
    case let .callFunction(argumentCount):
      let extended = self.extend(base: extendedArg, arg: argumentCount)
      return wrap(.callFunction(argumentCount: extended))
    case let .callFunctionKw(argumentCount):
      let extended = self.extend(base: extendedArg, arg: argumentCount)
      return wrap(.callFunctionKw(argumentCount: extended))
    case let .callFunctionEx(hasKeywordArguments):
      assert(extendedArg == 0)
      return wrap(.callFunctionEx(hasKeywordArguments: hasKeywordArguments))

    case .return:
      return wrap(.return)

    case .loadBuildClass:
      return wrap(.loadBuildClass)

    case let .loadMethod(nameIndex: arg):
      let name = self.getName(extendedArg: extendedArg, arg: arg)
      return wrap(.loadMethod(name: name))
    case let .callMethod(argumentCount: arg):
      let count = self.extend(base: extendedArg, arg: arg)
      return wrap(.callMethod(argumentCount: count))

    case .importStar:
      return wrap(.importStar)
    case let .importName(nameIndex: arg):
      let name = self.getName(extendedArg: extendedArg, arg: arg)
      return wrap(.importName(name: name))
    case let .importFrom(nameIndex: arg):
      let name = self.getName(extendedArg: extendedArg, arg: arg)
      return wrap(.importFrom(name: name))

    case .popExcept:
      return wrap(.popExcept)
    case .endFinally:
      return wrap(.endFinally)
    case let .setupExcept(firstExceptLabelIndex: arg):
      let label = self.getLabel(extendedArg: extendedArg, arg: arg)
      return wrap(.setupExcept(firstExceptLabel: label))
    case let .setupFinally(finallyStartLabelIndex: arg):
      let label = self.getLabel(extendedArg: extendedArg, arg: arg)
      return wrap(.setupFinally(finallyStartLabel: label))

    case let .raiseVarargs(type: arg):
      assert(extendedArg == 0)
      return wrap(.raiseVarargs(type: arg))

    case let .setupWith(afterBodyLabelIndex: arg):
      let label = self.getLabel(extendedArg: extendedArg, arg: arg)
      return wrap(.setupWith(afterBodyLabel: label))
    case .withCleanupStart:
      return wrap(.withCleanupStart)
    case .withCleanupFinish:
      return wrap(.withCleanupFinish)
    case .beforeAsyncWith:
      return wrap(.beforeAsyncWith)
    case .setupAsyncWith:
      return wrap(.setupAsyncWith)

    case let .jumpAbsolute(labelIndex: arg):
      let label = self.getLabel(extendedArg: extendedArg, arg: arg)
      return wrap(.jumpAbsolute(label: label))

    case let .popJumpIfTrue(labelIndex: arg):
      let label = self.getLabel(extendedArg: extendedArg, arg: arg)
      return wrap(.popJumpIfTrue(label: label))
    case let .popJumpIfFalse(labelIndex: arg):
      let label = self.getLabel(extendedArg: extendedArg, arg: arg)
      return wrap(.popJumpIfFalse(label: label))
    case let .jumpIfTrueOrPop(labelIndex: arg):
      let label = self.getLabel(extendedArg: extendedArg, arg: arg)
      return wrap(.jumpIfTrueOrPop(label: label))
    case let .jumpIfFalseOrPop(labelIndex: arg):
      let label = self.getLabel(extendedArg: extendedArg, arg: arg)
      return wrap(.jumpIfFalseOrPop(label: label))

    case let .formatValue(conversion, hasFormat):
      assert(extendedArg == 0)
      return wrap(.formatValue(conversion: conversion, hasFormat: hasFormat))

    case let .buildString(elementCount: arg):
      let count = self.extend(base: extendedArg, arg: arg)
      return wrap(.buildString(elementCount: count))

    case let .extendedArg(value):
      let extended = self.extend(base: extendedArg, arg: value)
      return self.getFilledInstruction(index: index + 1, extendedArg: extended)

    case .setupAnnotations:
      return wrap(.setupAnnotations)
    case .popBlock:
      return wrap(.popBlock)
    case let .buildSlice(type: arg):
      assert(extendedArg == 0)
      return wrap(.buildSlice(type: arg))
    }
  }

  // MARK: - Helpers

  private func getLabel(extendedArg: Int, arg: UInt8) -> Label {
    let index = self.extend(base: extendedArg, arg: arg)
    return self.labels[index]
  }

  private func getConstant(extendedArg: Int, arg: UInt8) -> Constant {
    let index = self.extend(base: extendedArg, arg: arg)
    return self.constants[index]
  }

  private func getName(extendedArg: Int, arg: UInt8) -> String {
    let index = self.extend(base: extendedArg, arg: arg)
    return self.names[index]
  }

  private func getVariable(extendedArg: Int, arg: UInt8) -> MangledName {
    let index = self.extend(base: extendedArg, arg: arg)
    return self.variableNames[index]
  }

  private func getCell(extendedArg: Int, arg: UInt8) -> MangledName {
    let index = self.extend(base: extendedArg, arg: arg)
    return self.cellVariableNames[index]
  }

  private func getFree(extendedArg: Int, arg: UInt8) -> MangledName {
    let index = self.extend(base: extendedArg, arg: arg)
    return self.freeVariableNames[index]
  }

  private func getCellOrFree(extendedArg: Int, arg: UInt8) -> MangledName {
    let index = self.extend(base: extendedArg, arg: arg)
    let cellCount = self.cellVariableNames.count

    // In `VM.Frame.cellsAndFreeVariables` we store `cells` first and then `free`.
    return index < cellCount ?
      self.cellVariableNames[index] :
      self.freeVariableNames[index - cellCount]
  }

  private func extend(base: Int, arg: UInt8) -> Int {
    return Instruction.extend(base: base, arg: arg)
  }
}
