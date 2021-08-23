import XCTest
import VioletCore
@testable import VioletBytecode

// swiftlint:disable file_length

/// String `ariel`
private let ariel = "ariel"
/// `Data` representing 'ariel' in ASCII
private let arielBytes = Data([65, 114, 105])
/// Mangled name with value: `_Mermaid__Ariel`
private let _Mermaid__Ariel = MangledName(className: "Mermaid", name: "__Ariel")
private let tuple: [CodeObject.Constant] = [.true, .false, .string(ariel)]

class CodeObjectFilledInstructionTests: XCTestCase {

  func test_isOurMangledNameCorrect() {
    XCTAssertEqual(_Mermaid__Ariel.value, "_Mermaid__Ariel")
  }

  // MARK: - General

  func test_general() {
    let builder = createBuilder()
    builder.appendNop()
    builder.appendPopTop()
    builder.appendRotTwo()
    builder.appendRotThree()
    builder.appendDupTop()
    builder.appendDupTopTwo()

    // 'nop' will be removed if we use peephole optimizer.
    let code = builder.finalize(usePeepholeOptimizer: false)
    XCTAssertFilledInstructions(code,
                                .nop,
                                .popTop,
                                .rotTwo,
                                .rotThree,
                                .dupTop,
                                .dupTopTwo)
  }

  // MARK: - Operations

  func test_unary() {
    let builder = createBuilder()
    builder.appendUnaryPositive()
    builder.appendUnaryNegative()
    builder.appendUnaryNot()
    builder.appendUnaryInvert()

    let code = builder.finalize()
    XCTAssertFilledInstructions(code,
                                .unaryPositive,
                                .unaryNegative,
                                .unaryNot,
                                .unaryInvert)
  }

  func test_binary() {
    let builder = createBuilder()
    builder.appendBinaryPower()
    builder.appendBinaryMultiply()
    builder.appendBinaryMatrixMultiply()
    builder.appendBinaryFloorDivide()
    builder.appendBinaryTrueDivide()
    builder.appendBinaryModulo()
    builder.appendBinaryAdd()
    builder.appendBinarySubtract()
    builder.appendBinaryLShift()
    builder.appendBinaryRShift()
    builder.appendBinaryAnd()
    builder.appendBinaryXor()
    builder.appendBinaryOr()

    let code = builder.finalize()
    XCTAssertFilledInstructions(code,
                                .binaryPower,
                                .binaryMultiply,
                                .binaryMatrixMultiply,
                                .binaryFloorDivide,
                                .binaryTrueDivide,
                                .binaryModulo,
                                .binaryAdd,
                                .binarySubtract,
                                .binaryLShift,
                                .binaryRShift,
                                .binaryAnd,
                                .binaryXor,
                                .binaryOr)
  }

  func test_inPlace() {
    let builder = createBuilder()
    builder.appendInPlacePower()
    builder.appendInPlaceMultiply()
    builder.appendInPlaceMatrixMultiply()
    builder.appendInPlaceFloorDivide()
    builder.appendInPlaceTrueDivide()
    builder.appendInPlaceModulo()
    builder.appendInPlaceAdd()
    builder.appendInPlaceSubtract()
    builder.appendInPlaceLShift()
    builder.appendInPlaceRShift()
    builder.appendInPlaceAnd()
    builder.appendInPlaceXor()
    builder.appendInPlaceOr()

    let code = builder.finalize()
    XCTAssertFilledInstructions(code,
                                .inPlacePower,
                                .inPlaceMultiply,
                                .inPlaceMatrixMultiply,
                                .inPlaceFloorDivide,
                                .inPlaceTrueDivide,
                                .inPlaceModulo,
                                .inPlaceAdd,
                                .inPlaceSubtract,
                                .inPlaceLShift,
                                .inPlaceRShift,
                                .inPlaceAnd,
                                .inPlaceXor,
                                .inPlaceOr)
  }

  func test_compare() {
    let values: [Instruction.CompareType] = [
      .equal, .notEqual,
      .less, .lessEqual,
      .greater, .greaterEqual,
      .is, .isNot,
      .in, .notIn,
      .exceptionMatch
    ]

    for v in values {
      let builder = createBuilder()
      builder.appendCompareOp(type: v)

      let code = builder.finalize()
      XCTAssertFilledInstructions(code, .compareOp(type: v))
    }
  }

  // MARK: - Await/yield

  func test_coroutines() {
    let builder = createBuilder()
    builder.appendGetAwaitable()
    builder.appendGetAIter()
    builder.appendGetANext()

    let code = builder.finalize()
    XCTAssertFilledInstructions(code, .getAwaitable, .getAIter, .getANext)
  }

  func test_generators() {
    let builder = createBuilder()
    builder.appendYieldValue()
    builder.appendYieldFrom()

    let code = builder.finalize()
    XCTAssertFilledInstructions(code, .yieldValue, .yieldFrom)
  }

  // MARK: - Print

  func test_print() {
    let builder = createBuilder()
    builder.appendPrintExpr()

    let code = builder.finalize()
    XCTAssertFilledInstructions(code, .printExpr)
  }

  // MARK: - Loops and collections

  func test_loops() {
    let builder = createBuilder()

    let setupLoopLabel = builder.createLabel()
    builder.appendSetupLoop(loopEnd: setupLoopLabel)
    builder.setLabel(setupLoopLabel) // 1

    let forIterLabel = builder.createLabel()
    builder.appendForIter(ifEmpty: forIterLabel)
    builder.setLabel(forIterLabel) // 2

    builder.appendGetIter() // 3
    builder.appendGetYieldFromIter() // 4
    builder.appendBreak() // 5

    let continueLabel = builder.createLabel()
    builder.appendContinue(loopStartLabel: continueLabel)
    builder.setLabel(continueLabel) // 6
    builder.appendTrue() // just so that label has valid jump target

    let code = builder.finalize()

    XCTAssertLabelTargets(code, 1, 2, 6)
    guard code.labels.count == 3 else { return }

    XCTAssertFilledInstructions(code,
                                .setupLoop(loopEndLabel: code.labels[0]),
                                .forIter(ifEmptyLabel: code.labels[1]),
                                .getIter,
                                .getYieldFromIter,
                                .break,
                                .continue(loopStartLabel: code.labels[2]),
                                .loadConst(.true))
  }

  func test_collections() {
    let builder = createBuilder()
    builder.appendBuildTuple(elementCount: 42)
    builder.appendBuildList(elementCount: 43)
    builder.appendBuildSet(elementCount: 44)
    builder.appendBuildMap(elementCount: 45)
    builder.appendBuildConstKeyMap(elementCount: 46)
    builder.appendSetAdd(relativeStackIndex: 47)
    builder.appendListAppend(relativeStackIndex: 48)
    builder.appendMapAdd(relativeStackIndex: 49)

    let code = builder.finalize()
    XCTAssertFilledInstructions(code,
                                .buildTuple(elementCount: 42),
                                .buildList(elementCount: 43),
                                .buildSet(elementCount: 44),
                                .buildMap(elementCount: 45),
                                .buildConstKeyMap(elementCount: 46),
                                .setAdd(relativeStackIndex: 47),
                                .listAppend(relativeStackIndex: 48),
                                .mapAdd(relativeStackIndex: 49))
  }

  func test_unpack() {
    let unpackArg = Instruction.UnpackExArg(countBefore: 49, countAfter: 50)

    let builder = createBuilder()
    builder.appendBuildTupleUnpack(elementCount: 42)
    builder.appendBuildTupleUnpackWithCall(elementCount: 43)
    builder.appendBuildListUnpack(elementCount: 44)
    builder.appendBuildSetUnpack(elementCount: 45)
    builder.appendBuildMapUnpack(elementCount: 46)
    builder.appendBuildMapUnpackWithCall(elementCount: 47)
    builder.appendUnpackSequence(elementCount: 48)
    builder.appendUnpackEx(countBefore: unpackArg.countBefore,
                           countAfter: unpackArg.countAfter)

    let code = builder.finalize()
    XCTAssertFilledInstructions(code,
                                .buildTupleUnpack(elementCount: 42),
                                .buildTupleUnpackWithCall(elementCount: 43),
                                .buildListUnpack(elementCount: 44),
                                .buildSetUnpack(elementCount: 45),
                                .buildMapUnpack(elementCount: 46),
                                .buildMapUnpackWithCall(elementCount: 47),
                                .unpackSequence(elementCount: 48),
                                .unpackEx(arg: unpackArg))
  }

  // MARK: - Store, load, delete

  func test_storeLoadDelete_constant() {
    let builder = createBuilder()
    builder.appendTrue()
    builder.appendFalse()
    builder.appendNone()
    builder.appendEllipsis()
    builder.appendInteger(42)
    builder.appendFloat(42.3)
    builder.appendComplex(real: 42.3, imag: 45.6)
    builder.appendString(ariel)
    builder.appendBytes(arielBytes)
    // We are NOT doing CodeObject (too much work)!
    builder.appendTuple(tuple)

    let code = builder.finalize()
    XCTAssertFilledInstructions(code,
                                .loadConst(.true),
                                .loadConst(.false),
                                .loadConst(.none),
                                .loadConst(.ellipsis),
                                .loadConst(.integer(42)),
                                .loadConst(.float(42.3)),
                                .loadConst(.complex(real: 42.3, imag: 45.6)),
                                .loadConst(.string(ariel)),
                                .loadConst(.bytes(arielBytes)),
                                .loadConst(.tuple(tuple)))
  }

  func test_storeLoadDelete_name() {
    let builder = createBuilder()
    builder.appendStoreName(ariel)
    builder.appendLoadName(ariel)
    builder.appendDeleteName(ariel)

    let code = builder.finalize()
    XCTAssertFilledInstructions(code,
                                .storeName(name: ariel),
                                .loadName(name: ariel),
                                .deleteName(name: ariel))
  }

  func test_storeLoadDelete_attribute() {
    let builder = createBuilder()
    builder.appendStoreAttribute(ariel)
    builder.appendLoadAttribute(ariel)
    builder.appendDeleteAttribute(ariel)

    let code = builder.finalize()
    XCTAssertFilledInstructions(code,
                                .storeAttribute(name: ariel),
                                .loadAttribute(name: ariel),
                                .deleteAttribute(name: ariel))
  }

  func test_storeLoadDelete_subscript() {
    let builder = createBuilder()
    builder.appendBinarySubscript()
    builder.appendStoreSubscript()
    builder.appendDeleteSubscript()

    let code = builder.finalize()
    XCTAssertFilledInstructions(code,
                                .binarySubscript,
                                .storeSubscript,
                                .deleteSubscript)
  }

  func test_storeLoadDelete_global() {
    let builder = createBuilder()
    builder.appendStoreGlobal(ariel)
    builder.appendLoadGlobal(ariel)
    builder.appendDeleteGlobal(ariel)

    let code = builder.finalize()
    XCTAssertFilledInstructions(code,
                                .storeGlobal(name: ariel),
                                .loadGlobal(name: ariel),
                                .deleteGlobal(name: ariel))
  }

  func test_storeLoadDelete_fast() {
    let builder = createBuilder(variableNames: [_Mermaid__Ariel])
    builder.appendLoadFast(_Mermaid__Ariel)
    builder.appendStoreFast(_Mermaid__Ariel)
    builder.appendDeleteFast(_Mermaid__Ariel)

    let code = builder.finalize()
    XCTAssertFilledInstructions(code,
                                .loadFast(variable: _Mermaid__Ariel),
                                .storeFast(variable: _Mermaid__Ariel),
                                .deleteFast(variable: _Mermaid__Ariel))
  }

  func test_storeLoadDelete_free() {
    let builder = createBuilder(freeVariableNames: [_Mermaid__Ariel])
    builder.appendLoadFree(_Mermaid__Ariel)
    builder.appendStoreFree(_Mermaid__Ariel)
    builder.appendDeleteFree(_Mermaid__Ariel)
    builder.appendLoadClassFree(_Mermaid__Ariel)

    let code = builder.finalize()
    XCTAssertFilledInstructions(code,
                                .loadFree(free: _Mermaid__Ariel),
                                .storeFree(free: _Mermaid__Ariel),
                                .deleteFree(free: _Mermaid__Ariel),
                                .loadClassFree(free: _Mermaid__Ariel))
  }

  func test_storeLoadDelete_cell() {
    let builder = createBuilder(cellVariableNames: [_Mermaid__Ariel])
    builder.appendLoadCell(_Mermaid__Ariel)
    builder.appendStoreCell(_Mermaid__Ariel)
    builder.appendDeleteCell(_Mermaid__Ariel)

    let code = builder.finalize()
    XCTAssertFilledInstructions(code,
                                .loadCell(cell: _Mermaid__Ariel),
                                .storeCell(cell: _Mermaid__Ariel),
                                .deleteCell(cell: _Mermaid__Ariel))
  }

  // MARK: - Function

  func test_function() {
    let flags: Instruction.FunctionFlags = [
      .hasPositionalArgDefaults,
      .hasKwOnlyArgDefaults,
      .hasAnnotations,
      .hasFreeVariables
    ]

    let builder = createBuilder()
    builder.appendMakeFunction(flags: flags)
    builder.appendCallFunction(argumentCount: 42)
    builder.appendCallFunctionKw(argumentCount: 42)
    builder.appendCallFunctionEx(hasKeywordArguments: false)
    builder.appendLoadMethod(name: ariel)
    builder.appendCallMethod(argumentCount: 42)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertFilledInstructions(code,
                                .makeFunction(flags: flags),
                                .callFunction(argumentCount: 42),
                                .callFunctionKw(argumentCount: 42),
                                .callFunctionEx(hasKeywordArguments: false),
                                .loadMethod(name: ariel),
                                .callMethod(argumentCount: 42),
                                .return)
  }

  // MARK: - Class

  func test_class() {
    let builder = createBuilder()
    builder.appendLoadBuildClass()

    let code = builder.finalize()
    XCTAssertFilledInstructions(code, .loadBuildClass)
  }

  // MARK: - Import

  func test_import() {
    let builder = createBuilder()
    builder.appendImportStar()
    builder.appendImportName(name: ariel)
    builder.appendImportFrom(name: ariel)

    let code = builder.finalize()
    XCTAssertFilledInstructions(code,
                                .importStar,
                                .importName(name: ariel),
                                .importFrom(name: ariel))
  }

  // MARK: - Try/catch

  func test_try_catch() {
    let builder = createBuilder()
    builder.appendPopExcept() // 1
    builder.appendEndFinally() // 2

    let setupExceptLabel = builder.createLabel()
    builder.appendSetupExcept(firstExcept: setupExceptLabel) // 3
    builder.setLabel(setupExceptLabel)

    let setupFinallyLabel = builder.createLabel()
    builder.appendSetupFinally(finallyStart: setupFinallyLabel) // 4
    builder.setLabel(setupFinallyLabel)

    builder.appendRaiseVarargs(arg: .reRaise)
    builder.appendRaiseVarargs(arg: .exceptionOnly)
    builder.appendRaiseVarargs(arg: .exceptionAndCause)

    let code = builder.finalize()

    XCTAssertLabelTargets(code, 3, 4)
    guard code.labels.count == 2 else { return }

    XCTAssertFilledInstructions(code,
                                .popExcept,
                                .endFinally,
                                .setupExcept(firstExceptLabel: code.labels[0]),
                                .setupFinally(finallyStartLabel: code.labels[1]),
                                .raiseVarargs(type: .reRaise),
                                .raiseVarargs(type: .exceptionOnly),
                                .raiseVarargs(type: .exceptionAndCause))
  }

  // MARK: - With

  func test_with() {
    let builder = createBuilder()

    let setupWithLabel = builder.createLabel()
    builder.appendSetupWith(afterBody: setupWithLabel)
    builder.setLabel(setupWithLabel)

    builder.appendWithCleanupStart()
    builder.appendWithCleanupFinish()
    builder.appendBeforeAsyncWith()
    builder.appendSetupAsyncWith()

    let code = builder.finalize()

    XCTAssertLabelTargets(code, 1)
    guard code.labels.count == 1 else { return }

    XCTAssertFilledInstructions(code,
                                .setupWith(afterBodyLabel: code.labels[0]),
                                .withCleanupStart,
                                .withCleanupFinish,
                                .beforeAsyncWith,
                                .setupAsyncWith)
  }

  // MARK: - Jumps

  func test_jumps() {
    let builder = createBuilder()

    let jumpAbsoluteLabel = builder.createLabel()
    builder.appendJumpAbsolute(to: jumpAbsoluteLabel) // 1
    builder.setLabel(jumpAbsoluteLabel)

    let popJumpIfTrueLabel = builder.createLabel()
    builder.appendPopJumpIfTrue(to: popJumpIfTrueLabel) // 2
    builder.setLabel(popJumpIfTrueLabel)

    let popJumpIfFalseLabel = builder.createLabel()
    builder.appendPopJumpIfFalse(to: popJumpIfFalseLabel) // 3
    builder.setLabel(popJumpIfFalseLabel)

    let jumpIfTrueOrPopLabel = builder.createLabel()
    builder.appendJumpIfTrueOrPop(to: jumpIfTrueOrPopLabel) // 4
    builder.setLabel(jumpIfTrueOrPopLabel)

    let jumpIfFalseOrPopLabel = builder.createLabel()
    builder.appendJumpIfFalseOrPop(to: jumpIfFalseOrPopLabel) // 5
    builder.setLabel(jumpIfFalseOrPopLabel)
    builder.appendTrue() // just so that label has valid jump target

    // 'PeepholeOptimizer' would optimize out jumps.
    let code = builder.finalize(usePeepholeOptimizer: false)

    XCTAssertLabelTargets(code, 1, 2, 3, 4, 5)
    guard code.labels.count == 5 else { return }

    XCTAssertFilledInstructions(code,
                                .jumpAbsolute(label: code.labels[0]),
                                .popJumpIfTrue(label: code.labels[1]),
                                .popJumpIfFalse(label: code.labels[2]),
                                .jumpIfTrueOrPop(label: code.labels[3]),
                                .jumpIfFalseOrPop(label: code.labels[4]),
                                .loadConst(.true))
  }

  // MARK: - String

  func test_string() {
    let builder = createBuilder()
    builder.appendFormatValue(conversion: .none, hasFormat: true)
    builder.appendFormatValue(conversion: .str, hasFormat: false)
    builder.appendFormatValue(conversion: .repr, hasFormat: true)
    builder.appendFormatValue(conversion: .ascii, hasFormat: false)
    builder.appendBuildString(count: 42)

    let code = builder.finalize()
    XCTAssertFilledInstructions(code,
                                .formatValue(conversion: .none, hasFormat: true),
                                .formatValue(conversion: .str, hasFormat: false),
                                .formatValue(conversion: .repr, hasFormat: true),
                                .formatValue(conversion: .ascii, hasFormat: false),
                                .buildString(elementCount: 42))
  }

  // MARK: - Other

  func test_other() {
    let builder = createBuilder(freeVariableNames: [_Mermaid__Ariel],
                                cellVariableNames: [_Mermaid__Ariel])

    builder.appendSetupAnnotations()
    builder.appendPopBlock()
    builder.appendLoadClosureCell(name: _Mermaid__Ariel)
    builder.appendLoadClosureFree(name: _Mermaid__Ariel)
    builder.appendBuildSlice(arg: .lowerUpper)
    builder.appendBuildSlice(arg: .lowerUpperStep)

    let code = builder.finalize()
    XCTAssertFilledInstructions(code,
                                .setupAnnotations,
                                .popBlock,
                                .loadClosure(cellOrFree: _Mermaid__Ariel),
                                .loadClosure(cellOrFree: _Mermaid__Ariel),
                                .buildSlice(type: .lowerUpper),
                                .buildSlice(type: .lowerUpperStep))
  }
}
