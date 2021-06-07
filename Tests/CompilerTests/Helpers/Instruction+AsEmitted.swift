import Foundation
import VioletCore
import VioletBytecode

// swiftlint:disable file_length

extension CodeObject {

  /// Note that it will not take extended arg into account.
  var emittedInstructions: [EmittedInstruction] {
    return self.instructions.map(self.asEmittedInstruction)
  }

  // swiftlint:disable:next function_body_length
  private func asEmittedInstruction(_ instruction: Instruction) -> EmittedInstruction {
    switch instruction {
    case .nop:
      return EmittedInstruction(.nop)
    case .popTop:
      return EmittedInstruction(.popTop)
    case .rotTwo:
      return EmittedInstruction(.rotTwo)
    case .rotThree:
      return EmittedInstruction(.rotThree)
    case .dupTop:
      return EmittedInstruction(.dupTop)
    case .dupTopTwo:
      return EmittedInstruction(.dupTopTwo)

    case .unaryPositive:
      return EmittedInstruction(.unaryPositive)
    case .unaryNegative:
      return EmittedInstruction(.unaryNegative)
    case .unaryNot:
      return EmittedInstruction(.unaryNot)
    case .unaryInvert:
      return EmittedInstruction(.unaryInvert)

    case .binaryPower:
      return EmittedInstruction(.binaryPower)
    case .binaryMultiply:
      return EmittedInstruction(.binaryMultiply)
    case .binaryMatrixMultiply:
      return EmittedInstruction(.binaryMatrixMultiply)
    case .binaryFloorDivide:
      return EmittedInstruction(.binaryFloorDivide)
    case .binaryTrueDivide:
      return EmittedInstruction(.binaryTrueDivide)
    case .binaryModulo:
      return EmittedInstruction(.binaryModulo)
    case .binaryAdd:
      return EmittedInstruction(.binaryAdd)
    case .binarySubtract:
      return EmittedInstruction(.binarySubtract)
    case .binaryLShift:
      return EmittedInstruction(.binaryLShift)
    case .binaryRShift:
      return EmittedInstruction(.binaryRShift)
    case .binaryAnd:
      return EmittedInstruction(.binaryAnd)
    case .binaryXor:
      return EmittedInstruction(.binaryXor)
    case .binaryOr:
      return EmittedInstruction(.binaryOr)

    case .inPlacePower:
      return EmittedInstruction(.inPlacePower)
    case .inPlaceMultiply:
      return EmittedInstruction(.inPlaceMultiply)
    case .inPlaceMatrixMultiply:
      return EmittedInstruction(.inPlaceMatrixMultiply)
    case .inPlaceFloorDivide:
      return EmittedInstruction(.inPlaceFloorDivide)
    case .inPlaceTrueDivide:
      return EmittedInstruction(.inPlaceTrueDivide)
    case .inPlaceModulo:
      return EmittedInstruction(.inPlaceModulo)
    case .inPlaceAdd:
      return EmittedInstruction(.inPlaceAdd)
    case .inPlaceSubtract:
      return EmittedInstruction(.inPlaceSubtract)
    case .inPlaceLShift:
      return EmittedInstruction(.inPlaceLShift)
    case .inPlaceRShift:
      return EmittedInstruction(.inPlaceRShift)
    case .inPlaceAnd:
      return EmittedInstruction(.inPlaceAnd)
    case .inPlaceXor:
      return EmittedInstruction(.inPlaceXor)
    case .inPlaceOr:
      return EmittedInstruction(.inPlaceOr)

    case let .compareOp(arg):
      return EmittedInstruction(.compareOp, self.toString(arg))

    case .getAwaitable:
      return EmittedInstruction(.getAwaitable)
    case .getAIter:
      return EmittedInstruction(.getAIter)
    case .getANext:
      return EmittedInstruction(.getANext)

    case .yieldValue:
      return EmittedInstruction(.yieldValue)
    case .yieldFrom:
      return EmittedInstruction(.yieldFrom)

    case .printExpr:
      return EmittedInstruction(.printExpr)

    case let .setupLoop(arg):
      return EmittedInstruction(.setupLoop, self.getLabel(arg))
    case let .forIter(arg):
      return EmittedInstruction(.forIter, self.getLabel(arg))
    case .getIter:
      return EmittedInstruction(.getIter)
    case .getYieldFromIter:
      return EmittedInstruction(.getYieldFromIter)

    case .break:
      return EmittedInstruction(.break)
    case let .continue(loopStartLabelIndex: arg):
      return EmittedInstruction(.continue, String(describing: arg))

    case let .buildTuple(elementCount: arg):
      return EmittedInstruction(.buildTuple, String(describing: arg))
    case let .buildList(elementCount: arg):
      return EmittedInstruction(.buildList, String(describing: arg))
    case let .buildSet(elementCount: arg):
      return EmittedInstruction(.buildSet, String(describing: arg))
    case let .buildMap(elementCount: arg):
      return EmittedInstruction(.buildMap, String(describing: arg))
    case let .buildConstKeyMap(elementCount: arg):
      return EmittedInstruction(.buildConstKeyMap, String(describing: arg))

    case let .setAdd(arg):
      return EmittedInstruction(.setAdd, String(describing: arg) + "_NOT_DONE")
    case let .listAppend(arg):
      return EmittedInstruction(.listAppend, String(describing: arg) + "_NOT_DONE")
    case let .mapAdd(arg):
      return EmittedInstruction(.mapAdd, String(describing: arg) + "_NOT_DONE")

    case let .buildTupleUnpack(elementCount: arg):
      return EmittedInstruction(.buildTupleUnpack, String(describing: arg))
    case let .buildTupleUnpackWithCall(elementCount: arg):
      return EmittedInstruction(.buildTupleUnpackWithCall, String(describing: arg))
    case let .buildListUnpack(elementCount: arg):
      return EmittedInstruction(.buildListUnpack, String(describing: arg))
    case let .buildSetUnpack(elementCount: arg):
      return EmittedInstruction(.buildSetUnpack, String(describing: arg))
    case let .buildMapUnpack(elementCount: arg):
      return EmittedInstruction(.buildMapUnpack, String(describing: arg))
    case let .buildMapUnpackWithCall(elementCount: arg):
      return EmittedInstruction(.buildMapUnpackWithCall, String(describing: arg))
    case let .unpackSequence(elementCount: arg):
      return EmittedInstruction(.unpackSequence, String(describing: arg))
    case let .unpackEx(arg: arg):
      return EmittedInstruction(.unpackEx, String(describing: arg))

    case let .loadConst(index: arg):
      return EmittedInstruction(.loadConst, self.getConstant(arg))

    case let .storeName(nameIndex: arg):
      return EmittedInstruction(.storeName, self.getName(arg))
    case let .loadName(nameIndex: arg):
      return EmittedInstruction(.loadName, self.getName(arg))
    case let .deleteName(nameIndex: arg):
      return EmittedInstruction(.deleteName, self.getName(arg))

    case let .storeAttribute(nameIndex: arg):
      return EmittedInstruction(.storeAttribute, self.getName(arg))
    case let .loadAttribute(nameIndex: arg):
      return EmittedInstruction(.loadAttribute, self.getName(arg))
    case let .deleteAttribute(nameIndex: arg):
      return EmittedInstruction(.deleteAttribute, self.getName(arg))

    case .binarySubscript:
      return EmittedInstruction(.binarySubscript)
    case .storeSubscript:
      return EmittedInstruction(.storeSubscript)
    case .deleteSubscript:
      return EmittedInstruction(.deleteSubscript)

    case let .storeGlobal(nameIndex: arg):
      return EmittedInstruction(.storeGlobal, self.getName(arg))
    case let .loadGlobal(nameIndex: arg):
      return EmittedInstruction(.loadGlobal, self.getName(arg))
    case let .deleteGlobal(nameIndex: arg):
      return EmittedInstruction(.deleteGlobal, self.getName(arg))

    case let .loadFast(variableIndex: arg):
      return EmittedInstruction(.loadFast, self.getVariableName(arg))
    case let .storeFast(variableIndex: arg):
      return EmittedInstruction(.storeFast, self.getVariableName(arg))
    case let .deleteFast(variableIndex: arg):
      return EmittedInstruction(.deleteFast, self.getVariableName(arg))

    case let .loadCellOrFree(cellOrFreeIndex: arg):
      return EmittedInstruction(.loadCellOrFree, self.getCellOrFreeName(arg))
    case let .storeCellOrFree(cellOrFreeIndex: arg):
      return EmittedInstruction(.storeCellOrFree, self.getCellOrFreeName(arg))
    case let .deleteCellOrFree(cellOrFreeIndex: arg):
      return EmittedInstruction(.deleteCellOrFree, self.getCellOrFreeName(arg))
    case let .loadClassCell(cellOrFreeIndex: arg):
      return EmittedInstruction(.loadClassCell, self.getCellOrFreeName(arg))

    case let .makeFunction(arg):
      return EmittedInstruction(.makeFunction, String(describing: arg.rawValue))

    case let .callFunction(argumentCount: arg):
      return EmittedInstruction(.callFunction, String(describing: arg))
    case let .callFunctionKw(argumentCount: arg):
      return EmittedInstruction(.callFunctionKw, String(describing: arg))
    case let .callFunctionEx(hasKeywordArguments: hasKeywordArguments):
      let arg = hasKeywordArguments ? "1" : "0"
      return EmittedInstruction(.callFunctionEx, arg)

    case .return:
      return EmittedInstruction(.return)

    case .loadBuildClass:
      return EmittedInstruction(.loadBuildClass)
    case let .loadMethod(nameIndex: arg):
      return EmittedInstruction(.loadMethod, String(describing: arg) + "_NOT_DONE")
    case let .callMethod(argumentCount: arg):
      return EmittedInstruction(.callMethod, String(describing: arg) + "_NOT_DONE")
    case .importStar:
      return EmittedInstruction(.importStar)
    case let .importName(nameIndex: arg):
      return EmittedInstruction(.importName, self.getName(arg))
    case let .importFrom(nameIndex: arg):
      return EmittedInstruction(.importFrom, self.getName(arg))
    case .popExcept:
      return EmittedInstruction(.popExcept)
    case .endFinally:
      return EmittedInstruction(.endFinally)
    case let .setupExcept(arg):
      return EmittedInstruction(.setupExcept, self.getLabel(arg))
    case let .setupFinally(arg):
      return EmittedInstruction(.setupFinally, self.getLabel(arg))
    case let .raiseVarargs(arg):
      return EmittedInstruction(.raiseVarargs, self.toString(arg))
    case let .setupWith(arg):
      return EmittedInstruction(.setupWith, self.getLabel(arg))
    case .withCleanupStart:
      return EmittedInstruction(.withCleanupStart)
    case .withCleanupFinish:
      return EmittedInstruction(.withCleanupFinish)
    case .beforeAsyncWith:
      return EmittedInstruction(.beforeAsyncWith)
    case .setupAsyncWith:
      return EmittedInstruction(.setupAsyncWith)

    case let .jumpAbsolute(labelIndex: arg):
      return EmittedInstruction(.jumpAbsolute, self.getLabel(arg))
    case let .popJumpIfTrue(labelIndex: arg):
      return EmittedInstruction(.popJumpIfTrue, self.getLabel(arg))
    case let .popJumpIfFalse(labelIndex: arg):
      return EmittedInstruction(.popJumpIfFalse, self.getLabel(arg))
    case let .jumpIfTrueOrPop(labelIndex: arg):
      return EmittedInstruction(.jumpIfTrueOrPop, self.getLabel(arg))
    case let .jumpIfFalseOrPop(labelIndex: arg):
      return EmittedInstruction(.jumpIfFalseOrPop, self.getLabel(arg))

    case let .formatValue(conversion: conversion, hasFormat: hasFormat):
      var arg = ""
      if let c = self.toString(conversion) {
        arg += c
      }
      if hasFormat {
        let space = arg.isEmpty ? "" : ", "
        arg += space + "with format"
      }
      return EmittedInstruction(.formatValue, arg)
    case let .buildString(arg):
      return EmittedInstruction(.buildString, String(describing: arg))

    case let .extendedArg(arg):
      return EmittedInstruction(.extendedArg, String(describing: arg) + "_NOT_DONE")

    case .setupAnnotations:
      return EmittedInstruction(.setupAnnotations)
    case .popBlock:
      return EmittedInstruction(.popBlock)
    case let .loadClosure(cellOrFreeIndex: arg):
      return EmittedInstruction(.loadClosure, String(describing: arg) + "_NOT_DONE")
    case let .buildSlice(arg):
      return EmittedInstruction(.buildSlice, self.toString(arg))
    }
  }

  private func getConstant(_ index: UInt8) -> String {
    precondition(index < self.constants.count)
    let constant = self.constants[Int(index)]
    return self.toString(constant)
  }

  private func toString(_ c: Constant) -> String {
    switch c {
    case .true: return "true"
    case .false: return "false"
    case .none: return "none"
    case .ellipsis: return "ellipsis"

    case let .integer(value):
      return String(describing: value)
    case let .float(value):
      return String(describing: value)
    case let .complex(real, imag):
      return "\(real)+\(imag)j"

    case let .bytes(bytes):
      let s = String(data: bytes, encoding: .ascii) ?? "?"
      return "b'\(s)'"
    case let .string(s):
      return "'" + s + "'"

    case let .code(c):
      return "<code object \(c.qualifiedName)>"

    case let .tuple(es):
      let ss = es.map { self.toString($0) }.joined(separator: ", ")
      return "(" + ss + ")"
    }
  }

  private func getName(_ index: UInt8) -> String {
    precondition(index < self.names.count)
    return self.names[Int(index)]
  }

  private func getVariableName(_ index: UInt8) -> String {
    precondition(index < self.variableNames.count)
    return self.variableNames[Int(index)].value
  }

  private func getLabel(_ index: UInt8) -> String {
    precondition(index < self.labels.count)
    let label = self.labels[Int(index)]
    let address = Instruction.byteSize * label.jumpAddress
    return String(describing: address)
  }

  private func getCellOrFreeName(_ index: UInt8) -> String {
    let mangled = index < self.cellVariableNames.count ?
      self.cellVariableNames[Int(index)] :
      self.freeVariableNames[Int(index)]

    return mangled.value
  }

  private func toString(_ opcode: Instruction.CompareType) -> String {
    switch opcode {
    case .equal: return "=="
    case .notEqual: return "!="
    case .less: return "<"
    case .lessEqual: return "<="
    case .greater: return ">"
    case .greaterEqual: return ">="
    case .is: return "is"
    case .isNot: return "is not"
    case .in: return "in"
    case .notIn: return "not in"
    case .exceptionMatch: return "exception match"
    }
  }

  private func toString(_ slice: Instruction.SliceArg) -> String {
    switch slice {
    case .lowerUpper: return "2"
    case .lowerUpperStep: return "3"
    }
  }

  private func toString(_ conversion: Instruction.StringConversion) -> String? {
    switch conversion {
    case .none: return nil
    case .str: return "str"
    case .repr: return "repr"
    case .ascii: return "ascii"
    }
  }

  private func toString(_ arg: Instruction.RaiseArg) -> String {
    switch arg {
    case .reRaise: return "reRaise"
    case .exceptionOnly: return "exception"
    case .exceptionAndCause: return "exception, cause"
    }
  }
}
