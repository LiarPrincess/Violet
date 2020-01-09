import Core

// swiftlint:disable file_length

extension CodeObject {

  // MARK: - Dump

  public func dump() -> String {
    var result = """
      Name: \(self.name)
      QualifiedName: \(self.qualifiedName)
      Filename: \(self.filename)
      Type: \(self.dumpType())

      Instructions (line, byte, instruction):

      """

    var extendedArg = 0
    let linesColumnWidth = self.getLinesColumnWidth()

    for (index, instruction) in self.instructions.enumerated() {
      let line = self.instructionLines[index]
      let lineString = self.pad(value: line, to: linesColumnWidth)

      let byte = index * Instruction.byteSize
      let byteString = self.pad(value: byte, to: linesColumnWidth)

      let instructionString = self.dumpInstruction(instruction,
                                                   extendedArg: extendedArg)

      result.append("\(lineString) \(byteString) \(instructionString)\n")

      if case let Instruction.extendedArg(arg) = instruction {
        extendedArg = extendedArg << 8 | Int(arg)
      } else {
        extendedArg = 0
      }
    }

    return result
  }

  // MARK: - Type

  private func dumpType() -> String {
    switch self.type {
    case .module: return "Module"
    case .`class`: return "Class"
    case .function: return "Function"
    case .asyncFunction: return "Async function"
    case .lambda: return "Lambda"
    case .comprehension: return "Comprehension"
    }
  }

  // MARK: - Line

  private func getLinesColumnWidth() -> Int {
    let minWidth = 4

    guard let maxLine = self.instructionLines.last else {
      return minWidth
    }

    let string = String(maxLine)
    return Swift.max(minWidth, string.count)
  }

  private func pad(value: SourceLine, to width: Int) -> String {
    return self.pad(value: Int(value), to: width)
  }

  private func pad(value: Int, to width: Int) -> String {
    // There is 'string.padding(toLength:, withPad:, startingAt:)'
    // but it tends to trap on invalid input.

    let string = String(value)
    let stringCount = string.count

    let paddingCount = width - stringCount
    guard paddingCount > 0 else {
      return string
    }

    let padding = String(repeating: " ", count: paddingCount)
    return padding + string
  }

  // MARK: - Dump instruction

  // swiftlint:disable:next function_body_length
  private func dumpInstruction(_ instruction: Instruction,
                               extendedArg: Int) -> String {
    switch instruction {
    case .nop: return "nop"
    case .popTop: return "popTop"
    case .rotTwo: return "rotTwo"
    case .rotThree: return "rotThree"
    case .dupTop: return "dupTop"
    case .dupTopTwo: return "dupTopTwo"

    case .unaryPositive: return "unaryPositive"
    case .unaryNegative: return "unaryNegative"
    case .unaryNot: return "unaryNot"
    case .unaryInvert: return "unaryInvert"

    case .binaryPower: return "binaryPower"
    case .binaryMultiply: return "binaryMultiply"
    case .binaryMatrixMultiply: return "binaryMatrixMultiply"
    case .binaryFloorDivide: return "binaryFloorDivide"
    case .binaryTrueDivide: return "binaryTrueDivide"
    case .binaryModulo: return "binaryModulo"
    case .binaryAdd: return "binaryAdd"
    case .binarySubtract: return "binarySubtract"
    case .binaryLShift: return "binaryLShift"
    case .binaryRShift: return "binaryRShift"
    case .binaryAnd: return "binaryAnd"
    case .binaryXor: return "binaryXor"
    case .binaryOr: return "binaryOr"

    case .inplacePower: return "inplacePower"
    case .inplaceMultiply: return "inplaceMultiply"
    case .inplaceMatrixMultiply: return "inplaceMatrixMultiply"
    case .inplaceFloorDivide: return "inplaceFloorDivide"
    case .inplaceTrueDivide: return "inplaceTrueDivide"
    case .inplaceModulo: return "inplaceModulo"
    case .inplaceAdd: return "inplaceAdd"
    case .inplaceSubtract: return "inplaceSubtract"
    case .inplaceLShift: return "inplaceLShift"
    case .inplaceRShift: return "inplaceRShift"
    case .inplaceAnd: return "inplaceAnd"
    case .inplaceXor: return "inplaceXor"
    case .inplaceOr: return "inplaceOr"

    case let .compareOp(arg):
      return "compareOp: \(self.toString(arg))"

    case .getAwaitable: return "getAwaitable"
    case .getAIter: return "getAIter"
    case .getANext: return "getANext"

    case .yieldValue: return "yieldValue"
    case .yieldFrom: return "yieldFrom"

    case .printExpr: return "printExpr"

    case let .setupLoop(arg):
      return "setupLoop; label: \(self.getLabel(extendedArg + Int(arg)))"
    case let .forIter(arg):
      return "forIter; label: \(self.getLabel(extendedArg + Int(arg)))"
    case .getIter:
      return "getIter"
    case .getYieldFromIter:
      return "getYieldFromIter"

    case .`break`: return "break"

    case let .buildTuple(elementCount: arg):
      return "buildTuple; elementCount: \(extendedArg + Int(arg)))"
    case let .buildList(elementCount: arg):
      return "buildList; elementCount: \(extendedArg + Int(arg)))"
    case let .buildSet(elementCount: arg):
      return "buildSet; elementCount: \(extendedArg + Int(arg)))"
    case let .buildMap(elementCount: arg):
      return "buildMap; elementCount: \(extendedArg + Int(arg)))"
    case let .buildConstKeyMap(elementCount: arg):
      return "buildConstKeyMap; elementCount: \(extendedArg + Int(arg)))"

    case let .setAdd(arg):
      return "setAdd \(extendedArg + Int(arg))"
    case let .listAppend(arg):
      return "listAppend \(extendedArg + Int(arg))"
    case let .mapAdd(arg):
      return "mapAdd \(extendedArg + Int(arg))"

    case let .buildTupleUnpack(elementCount: arg):
      return "buildTupleUnpack; elementCount: \(extendedArg + Int(arg)))"
    case let .buildTupleUnpackWithCall(elementCount: arg):
      return "buildTupleUnpackWithCall; elementCount: \(extendedArg + Int(arg)))"
    case let .buildListUnpack(elementCount: arg):
      return "buildListUnpack; elementCount: \(extendedArg + Int(arg)))"
    case let .buildSetUnpack(elementCount: arg):
      return "buildSetUnpack; elementCount: \(extendedArg + Int(arg)))"
    case let .buildMapUnpack(elementCount: arg):
      return "buildMapUnpack; elementCount: \(extendedArg + Int(arg)))"
    case let .buildMapUnpackWithCall(elementCount: arg):
      return "buildMapUnpackWithCall; elementCount: \(extendedArg + Int(arg)))"
    case let .unpackSequence(elementCount: arg):
      return "unpackSequence; elementCount: \(extendedArg + Int(arg)))"
    case let .unpackEx(elementCountBefore: arg):
      return "unpackEx \(extendedArg + Int(arg)))"

    case let .loadConst(index: arg):
      return "loadConst \(self.getConstant(extendedArg + Int(arg)))"

    case let .storeName(nameIndex: arg):
      return "storeName \(self.getName(extendedArg + Int(arg)))"
    case let .loadName(nameIndex: arg):
      return "loadName \(self.getName(extendedArg + Int(arg)))"
    case let .deleteName(nameIndex: arg):
      return "deleteName \(self.getName(extendedArg + Int(arg)))"

    case let .storeAttribute(nameIndex: arg):
      return ".storeAttribute \(self.getName(extendedArg + Int(arg)))"
    case let .loadAttribute(nameIndex: arg):
      return ".loadAttribute \(self.getName(extendedArg + Int(arg)))"
    case let .deleteAttribute(nameIndex: arg):
      return ".deleteAttribute \(self.getName(extendedArg + Int(arg)))"

    case .binarySubscript:
      return "binarySubscript"
    case .storeSubscript:
      return "storeSubscript"
    case .deleteSubscript:
      return "deleteSubscript"

    case let .storeGlobal(nameIndex: arg):
      return "storeGlobal \(self.getName(extendedArg + Int(arg)))"
    case let .loadGlobal(nameIndex: arg):
      return "loadGlobal \(self.getName(extendedArg + Int(arg)))"
    case let .deleteGlobal(nameIndex: arg):
      return "deleteGlobal \(self.getName(extendedArg + Int(arg)))"

    case let .loadFast(nameIndex: arg):
      return "loadFast \(self.getName(extendedArg + Int(arg)))"
    case let .storeFast(nameIndex: arg):
      return "storeFast \(self.getName(extendedArg + Int(arg)))"
    case let .deleteFast(nameIndex: arg):
      return "deleteFast \(self.getName(extendedArg + Int(arg)))"

    case let .loadDeref(nameIndex: arg):
      return "loadDeref; \(self.getName(extendedArg + Int(arg)))"
    case let .storeDeref(nameIndex: arg):
      return "storeDeref; \(self.getName(extendedArg + Int(arg)))"
    case let .deleteDeref(nameIndex: arg):
      return "deleteDeref; \(self.getName(extendedArg + Int(arg)))"
    case let .loadClassDeref(nameIndex: arg):
      return "loadClassDeref; \(self.getName(extendedArg + Int(arg)))"

    case let .makeFunction(arg):
      var a = [String]()
      if arg.contains(.hasPositionalArgDefaults) { a.append("hasPositionalArgDefaults") }
      if arg.contains(.hasKwOnlyArgDefaults) { a.append("hasKwOnlyArgDefaults") }
      if arg.contains(.hasAnnotations) { a.append("hasAnnotations") }
      if arg.contains(.hasFreeVariables) { a.append("hasFreeVariables") }

      let bin = String(arg.rawValue, radix: 2, uppercase: false)
      return "makeFunction; \(bin) (\(a.joined(separator: ", ")))"

//    case let .callFunction(argumentCount: arg):
//      return EmittedInstruction(.callFunction, String(describing: arg))
//    case let .callFunctionKw(argumentCount: arg):
//      return EmittedInstruction(.callFunctionKw, String(describing: arg))
//    case let .callFunctionEx(hasKeywordArguments: hasKeywordArguments):
//      let arg = hasKeywordArguments ? "1" : "0"
//      return EmittedInstruction(.callFunctionEx, arg)

    case .`return`:
      return "return"

    case .loadBuildClass:
      return "loadBuildClass"
    case let .loadMethod(nameIndex: arg):
      return "loadMethod  \(self.getName(extendedArg + Int(arg)))"
    case let .callMethod(argumentCount: arg):
      return "callMethod  \(self.getName(extendedArg + Int(arg)))"
    case .importStar:
      return "importStar"
    case let .importName(nameIndex: arg):
      return "importName \(self.getName(extendedArg + Int(arg)))"
    case let .importFrom(nameIndex: arg):
      return "importFrom \(self.getName(extendedArg + Int(arg)))"
    case .popExcept:
      return "popExcept"
    case .endFinally:
      return "endFinally"
    case let .setupExcept(arg):
      return "setupExcept \(self.getLabel(extendedArg + Int(arg)))"
    case let .setupFinally(arg):
      return "setupFinally \(self.getLabel(extendedArg + Int(arg)))"
    case let .raiseVarargs(arg):
      return "raiseVarargs \(self.toString(arg))"
    case let .setupWith(arg):
      return "setupWith \(self.getLabel(extendedArg + Int(arg)))"
    case .withCleanupStart:
      return "withCleanupStart"
    case .withCleanupFinish:
      return "withCleanupFinish"
    case .beforeAsyncWith:
      return "beforeAsyncWith"
    case .setupAsyncWith:
      return "setupAsyncWith"

    case let .jumpAbsolute(labelIndex: arg):
      return "jumpAbsolute; label: \(self.getLabel(extendedArg + Int(arg)))"
    case let .popJumpIfTrue(labelIndex: arg):
      return "popJumpIfTrue; label: \(self.getLabel(extendedArg + Int(arg)))"
    case let .popJumpIfFalse(labelIndex: arg):
      return "popJumpIfFalse; label: \(self.getLabel(extendedArg + Int(arg)))"
    case let .jumpIfTrueOrPop(labelIndex: arg):
      return "jumpIfTrueOrPop; label: \(self.getLabel(extendedArg + Int(arg)))"
    case let .jumpIfFalseOrPop(labelIndex: arg):
      return "jumpIfFalseOrPop; label: \(self.getLabel(extendedArg + Int(arg)))"

    case let .formatValue(conversion: conversion, hasFormat: hasFormat):
      var arg = ""
      if let c = self.toString(conversion) {
        arg += c
      }
      if hasFormat {
        let space = arg.isEmpty ? "" : ", "
        arg += space + "with format"
      }
      return "formatValue \(arg)"
    case let .buildString(arg):
      return "buildString; count: \(arg)"

    case let .extendedArg(arg):
      let total = extendedArg << 8 | Int(arg)
      return "extendedArg; \(arg) (total: \(total))"

    case .setupAnnotations:
      return "setupAnnotations"
    case .popBlock:
      return "popBlock"
//    case let .loadClosure(cellOrFreeIndex: arg):
//      return EmittedInstruction(.loadClosure, String(describing: arg) + "_INVALID")
    case let .buildSlice(arg):
      return "buildSlice; \(self.toString(arg))"

    default:
      fatalError()
    }
  }

  // MARK: - Helpers - get

  private func getConstant(_ index: Int) -> String {
    guard index < self.constants.count else {
      return "INDEX_OUT_OF_RANGE: \(index)"
    }

    let constant = self.constants[index]
    return self.toString(constant)
  }

  private func getName(_ index: Int) -> String {
    guard index < self.name.count else {
      return "INDEX_OUT_OF_RANGE: \(index)"
    }

    return self.names[index]
  }

  private func getLabel(_ index: Int) -> String {
    guard index < self.labels.count else {
      return "INDEX_OUT_OF_RANGE: \(index)"
    }

    let address = Instruction.byteSize * self.labels[Int(index)]
    return String(describing: address)
  }

  // MARK: - Helpers - toString

  private func toString(_ c: Constant) -> String {
    switch c {
    case .true:  return "true"
    case .false: return "false"
    case .none:     return "none"
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

  private func toString(_ opcode: ComparisonOpcode) -> String {
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

  private func toString(_ slice: SliceArg) -> String {
    switch slice {
    case .lowerUpper: return "2 (lower and upper)"
    case .lowerUpperStep: return "3 (lower, upper and step)"
    }
  }

  private func toString(_ conversion: StringConversion) -> String? {
    switch conversion {
    case .none: return nil
    case .str: return "str"
    case .repr: return "repr"
    case .ascii: return "ascii"
    }
  }

  private func toString(_ arg: RaiseArg) -> String {
    switch arg {
    case .reRaise: return "reRaise"
    case .exceptionOnly: return "exception"
    case .exceptionAndCause: return "exception, cause"
    }
  }
}
