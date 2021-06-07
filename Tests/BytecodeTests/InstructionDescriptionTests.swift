import XCTest
import VioletCore
@testable import VioletBytecode

// swiftlint:disable file_length

private func XCTAssertDescription(_ instruction: Instruction,
                                  _ expected: String,
                                  file: StaticString = #file,
                                  line: UInt = #line) {
  let description = String(describing: instruction)
  XCTAssertEqual(description, expected, file: file, line: line)
}

class InstructionDescriptionTests: XCTestCase {

  func test_general() {
    XCTAssertDescription(.nop, "nop")
    XCTAssertDescription(.popTop, "popTop")
    XCTAssertDescription(.rotTwo, "rotTwo")
    XCTAssertDescription(.rotThree, "rotThree")
    XCTAssertDescription(.dupTop, "dupTop")
    XCTAssertDescription(.dupTopTwo, "dupTopTwo")
  }

  // MARK: - Operations

  func test_unary() {
    XCTAssertDescription(.unaryPositive, "unaryPositive")
    XCTAssertDescription(.unaryNegative, "unaryNegative")
    XCTAssertDescription(.unaryNot, "unaryNot")
    XCTAssertDescription(.unaryInvert, "unaryInvert")
  }

  func test_binary() {
    XCTAssertDescription(.binaryPower, "binaryPower")

    XCTAssertDescription(.binaryMultiply, "binaryMultiply")
    XCTAssertDescription(.binaryMatrixMultiply, "binaryMatrixMultiply")
    XCTAssertDescription(.binaryFloorDivide, "binaryFloorDivide")
    XCTAssertDescription(.binaryTrueDivide, "binaryTrueDivide")
    XCTAssertDescription(.binaryModulo, "binaryModulo")
    XCTAssertDescription(.binaryAdd, "binaryAdd")
    XCTAssertDescription(.binarySubtract, "binarySubtract")

    XCTAssertDescription(.binaryLShift, "binaryLShift")
    XCTAssertDescription(.binaryRShift, "binaryRShift")

    XCTAssertDescription(.binaryAnd, "binaryAnd")
    XCTAssertDescription(.binaryXor, "binaryXor")
    XCTAssertDescription(.binaryOr, "binaryOr")
  }

  func test_inPlace() {
    XCTAssertDescription(.inPlacePower, "inPlacePower")

    XCTAssertDescription(.inPlaceMultiply, "inPlaceMultiply")
    XCTAssertDescription(.inPlaceMatrixMultiply, "inPlaceMatrixMultiply")
    XCTAssertDescription(.inPlaceFloorDivide, "inPlaceFloorDivide")
    XCTAssertDescription(.inPlaceTrueDivide, "inPlaceTrueDivide")
    XCTAssertDescription(.inPlaceModulo, "inPlaceModulo")
    XCTAssertDescription(.inPlaceAdd, "inPlaceAdd")
    XCTAssertDescription(.inPlaceSubtract, "inPlaceSubtract")

    XCTAssertDescription(.inPlaceLShift, "inPlaceLShift")
    XCTAssertDescription(.inPlaceRShift, "inPlaceRShift")

    XCTAssertDescription(.inPlaceAnd, "inPlaceAnd")
    XCTAssertDescription(.inPlaceXor, "inPlaceXor")
    XCTAssertDescription(.inPlaceOr, "inPlaceOr")
  }

  func test_compare() {
    XCTAssertDescription(.compareOp(type: .equal), "compareOp(type: ==)")
    XCTAssertDescription(.compareOp(type: .notEqual), "compareOp(type: !=)")
    XCTAssertDescription(.compareOp(type: .less), "compareOp(type: <)")
    XCTAssertDescription(.compareOp(type: .lessEqual), "compareOp(type: <=)")
    XCTAssertDescription(.compareOp(type: .greater), "compareOp(type: >)")
    XCTAssertDescription(.compareOp(type: .greaterEqual), "compareOp(type: >=)")

    XCTAssertDescription(.compareOp(type: .`is`), "compareOp(type: is)")
    XCTAssertDescription(.compareOp(type: .isNot), "compareOp(type: isNot)")

    XCTAssertDescription(.compareOp(type: .`in`), "compareOp(type: in)")
    XCTAssertDescription(.compareOp(type: .notIn), "compareOp(type: notIn)")

    XCTAssertDescription(
      .compareOp(type: .exceptionMatch),
      "compareOp(type: exceptionMatch)"
    )
  }

  // MARK: - Await/yield

  func test_coroutines() {
    XCTAssertDescription(.getAwaitable, "getAwaitable")
    XCTAssertDescription(.getAIter, "getAIter")
    XCTAssertDescription(.getANext, "getANext")
  }

  func test_generators() {
    XCTAssertDescription(.yieldValue, "yieldValue")
    XCTAssertDescription(.yieldFrom, "yieldFrom")
  }

  // MARK: - Print

  func test_print() {
    XCTAssertDescription(.printExpr, "printExpr")
  }

  // MARK: - Loops and collections

  func test_loops() {
    XCTAssertDescription(
      .setupLoop(loopEndLabelIndex: 0x42),
      "setupLoop(loopEndLabelIndex: 0x42)"
    )
    XCTAssertDescription(
      .forIter(ifEmptyLabelIndex: 0x42),
      "forIter(ifEmptyLabelIndex: 0x42)"
    )
    XCTAssertDescription(
      .getIter,
      "getIter"
    )
    XCTAssertDescription(
      .getYieldFromIter,
      "getYieldFromIter"
    )
    XCTAssertDescription(
      .`break`,
      "break"
    )
    XCTAssertDescription(
      .`continue`(loopStartLabelIndex: 0x42),
      "continue(loopStartLabelIndex: 0x42)"
    )
  }

  func test_collections() {
    XCTAssertDescription(
      .buildTuple(elementCount: 0x42),
      "buildTuple(elementCount: 0x42)"
    )
    XCTAssertDescription(
      .buildList(elementCount: 0x42),
      "buildList(elementCount: 0x42)"
    )
    XCTAssertDescription(
      .buildSet(elementCount: 0x42),
      "buildSet(elementCount: 0x42)"
    )
    XCTAssertDescription(
      .buildMap(elementCount: 0x42),
      "buildMap(elementCount: 0x42)"
    )
    XCTAssertDescription(
      .buildConstKeyMap(elementCount: 0x42),
      "buildConstKeyMap(elementCount: 0x42)"
    )
    XCTAssertDescription(
      .setAdd(relativeStackIndex: 0x42),
      "setAdd(relativeStackIndex: 0x42)"
    )
    XCTAssertDescription(
      .listAppend(relativeStackIndex: 0x42),
      "listAppend(relativeStackIndex: 0x42)"
    )
    XCTAssertDescription(
      .mapAdd(relativeStackIndex: 0x42),
      "mapAdd(relativeStackIndex: 0x42)"
    )
  }

  func test_unpack() {
    XCTAssertDescription(
      .buildTupleUnpack(elementCount: 0x42),
      "buildTupleUnpack(elementCount: 0x42)"
    )
    XCTAssertDescription(
      .buildTupleUnpackWithCall(elementCount: 0x42),
      "buildTupleUnpackWithCall(elementCount: 0x42)"
    )
    XCTAssertDescription(
      .buildListUnpack(elementCount: 0x42),
      "buildListUnpack(elementCount: 0x42)"
    )
    XCTAssertDescription(
      .buildSetUnpack(elementCount: 0x42),
      "buildSetUnpack(elementCount: 0x42)"
    )
    XCTAssertDescription(
      .buildMapUnpack(elementCount: 0x42),
      "buildMapUnpack(elementCount: 0x42)"
    )
    XCTAssertDescription(
      .buildMapUnpackWithCall(elementCount: 0x42),
      "buildMapUnpackWithCall(elementCount: 0x42)"
    )
    XCTAssertDescription(
      .unpackSequence(elementCount: 0x42),
      "unpackSequence(elementCount: 0x42)"
    )
    XCTAssertDescription(
      .unpackEx(arg: 0x42),
      "unpackEx(arg: 0x42)"
    )
  }

  // MARK: - Store, load, delete

  func test_storeLoadDelete_constant() {
    XCTAssertDescription(
      .loadConst(index: 0x42),
      "loadConst(index: 0x42)"
    )
  }

  func test_storeLoadDelete_name() {
    XCTAssertDescription(
      .storeName(nameIndex: 0x42),
      "storeName(nameIndex: 0x42)"
    )
    XCTAssertDescription(
      .loadName(nameIndex: 0x42),
      "loadName(nameIndex: 0x42)"
    )
    XCTAssertDescription(
      .deleteName(nameIndex: 0x42),
      "deleteName(nameIndex: 0x42)"
    )
  }

  func test_storeLoadDelete_attribute() {
    XCTAssertDescription(
      .storeAttribute(nameIndex: 0x42),
      "storeAttribute(nameIndex: 0x42)"
    )
    XCTAssertDescription(
      .loadAttribute(nameIndex: 0x42),
      "loadAttribute(nameIndex: 0x42)"
    )
    XCTAssertDescription(
      .deleteAttribute(nameIndex: 0x42),
      "deleteAttribute(nameIndex: 0x42)"
    )
  }

  func test_storeLoadDelete_subscript() {
    XCTAssertDescription(
      .binarySubscript,
      "binarySubscript"
    )
    XCTAssertDescription(
      .storeSubscript,
      "storeSubscript"
    )
    XCTAssertDescription(
      .deleteSubscript,
      "deleteSubscript"
    )
  }

  func test_storeLoadDelete_global() {
    XCTAssertDescription(
      .storeGlobal(nameIndex: 0x42),
      "storeGlobal(nameIndex: 0x42)"
    )
    XCTAssertDescription(
      .loadGlobal(nameIndex: 0x42),
      "loadGlobal(nameIndex: 0x42)"
    )
    XCTAssertDescription(
      .deleteGlobal(nameIndex: 0x42),
      "deleteGlobal(nameIndex: 0x42)"
    )
  }

  func test_storeLoadDelete_fast() {
    XCTAssertDescription(
      .loadFast(variableIndex: 0x42),
      "loadFast(variableIndex: 0x42)"
    )
    XCTAssertDescription(
      .storeFast(variableIndex: 0x42),
      "storeFast(variableIndex: 0x42)"
    )
    XCTAssertDescription(
      .deleteFast(variableIndex: 0x42),
      "deleteFast(variableIndex: 0x42)"
    )
  }

  func test_storeLoadDelete_cellOrFree() {
    XCTAssertDescription(
      .loadCellOrFree(cellOrFreeIndex: 0x42),
      "loadCellOrFree(cellOrFreeIndex: 0x42)"
    )
    XCTAssertDescription(
      .storeCellOrFree(cellOrFreeIndex: 0x42),
      "storeCellOrFree(cellOrFreeIndex: 0x42)"
    )
    XCTAssertDescription(
      .deleteCellOrFree(cellOrFreeIndex: 0x42),
      "deleteCellOrFree(cellOrFreeIndex: 0x42)"
    )
    XCTAssertDescription(
      .loadClassCell(cellOrFreeIndex: 0x42),
      "loadClassCell(cellOrFreeIndex: 0x42)"
    )
  }

  // MARK: - Function

  func test_function() {
    let flags: Instruction.FunctionFlags = [
      .hasPositionalArgDefaults,
      .hasKwOnlyArgDefaults,
      .hasAnnotations,
      .hasFreeVariables
    ]

    XCTAssertDescription(
      .makeFunction(flags: flags),
      "makeFunction(flags: FunctionFlags(hasPositionalArgDefaults, hasKwOnlyArgDefaults, hasAnnotations, hasFreeVariables))"
      // swiftlint:disable:previous line_length
    )
    XCTAssertDescription(
      .callFunction(argumentCount: 0x42),
      "callFunction(argumentCount: 0x42)"
    )
    XCTAssertDescription(
      .callFunctionKw(argumentCount: 0x42),
      "callFunctionKw(argumentCount: 0x42)"
    )
    XCTAssertDescription(
      .callFunctionEx(hasKeywordArguments: false),
      "callFunctionEx(hasKeywordArguments: false)"
    )
    XCTAssertDescription(
      .`return`,
      "return"
    )
    XCTAssertDescription(
      .loadMethod(nameIndex: 0x42),
      "loadMethod(nameIndex: 0x42)"
    )
    XCTAssertDescription(
      .callMethod(argumentCount: 0x42),
      "callMethod(argumentCount: 0x42)"
    )
  }

  // MARK: - Class

  func test_class() {
    XCTAssertDescription(.loadBuildClass, "loadBuildClass")
  }

  // MARK: - Import

  func test_import() {
    XCTAssertDescription(
      .importStar,
      "importStar"
    )
    XCTAssertDescription(
      .importName(nameIndex: 0x42),
      "importName(nameIndex: 0x42)"
    )
    XCTAssertDescription(
      .importFrom(nameIndex: 0x42),
      "importFrom(nameIndex: 0x42)"
    )
  }

  // MARK: - Try/catch

  func test_try_catch() {
    XCTAssertDescription(
      .popExcept,
      "popExcept"
    )
    XCTAssertDescription(
      .endFinally,
      "endFinally"
    )
    XCTAssertDescription(
      .setupExcept(firstExceptLabelIndex: 0x42),
      "setupExcept(firstExceptLabelIndex: 0x42)"
    )
    XCTAssertDescription(
      .setupFinally(finallyStartLabelIndex: 0x42),
      "setupFinally(finallyStartLabelIndex: 0x42)"
    )

    XCTAssertDescription(
      .raiseVarargs(type: .reRaise),
      "raiseVarargs(type: reRaise)"
    )
    XCTAssertDescription(
      .raiseVarargs(type: .exceptionOnly),
      "raiseVarargs(type: exceptionOnly)"
    )
    XCTAssertDescription(
      .raiseVarargs(type: .exceptionAndCause),
      "raiseVarargs(type: exceptionAndCause)"
    )
  }

  // MARK: - With

  func test_with() {
    XCTAssertDescription(
      .setupWith(afterBodyLabelIndex: 0x42),
      "setupWith(afterBodyLabelIndex: 0x42)"
    )
    XCTAssertDescription(
      .withCleanupStart,
      "withCleanupStart"
    )
    XCTAssertDescription(
      .withCleanupFinish,
      "withCleanupFinish"
    )
    XCTAssertDescription(
      .beforeAsyncWith,
      "beforeAsyncWith"
    )
    XCTAssertDescription(
      .setupAsyncWith,
      "setupAsyncWith"
    )
  }

  // MARK: - Jumps

  func test_jumps() {
    XCTAssertDescription(
      .jumpAbsolute(labelIndex: 0x42),
      "jumpAbsolute(labelIndex: 0x42)"
    )
    XCTAssertDescription(
      .popJumpIfTrue(labelIndex: 0x42),
      "popJumpIfTrue(labelIndex: 0x42)"
    )
    XCTAssertDescription(
      .popJumpIfFalse(labelIndex: 0x42),
      "popJumpIfFalse(labelIndex: 0x42)"
    )
    XCTAssertDescription(
      .jumpIfTrueOrPop(labelIndex: 0x42),
      "jumpIfTrueOrPop(labelIndex: 0x42)"
    )
    XCTAssertDescription(
      .jumpIfFalseOrPop(labelIndex: 0x42),
      "jumpIfFalseOrPop(labelIndex: 0x42)"
    )
  }

  // MARK: - String

  func test_string() {
    XCTAssertDescription(
      .formatValue(conversion: .none, hasFormat: true),
      "formatValue(conversion: none, hasFormat: true)"
    )
    XCTAssertDescription(
      .formatValue(conversion: .str, hasFormat: false),
      "formatValue(conversion: str, hasFormat: false)"
    )
    XCTAssertDescription(
      .formatValue(conversion: .repr, hasFormat: true),
      "formatValue(conversion: repr, hasFormat: true)"
    )
    XCTAssertDescription(
      .formatValue(conversion: .ascii, hasFormat: false),
      "formatValue(conversion: ascii, hasFormat: false)"
    )

    XCTAssertDescription(
    .buildString(elementCount: 0x42),
    "buildString(elementCount: 0x42)"
    )
  }

  // MARK: - Extended

  func test_extended() {
    XCTAssertDescription(.extendedArg(0x42), "extendedArg(0x42)")
  }

  // MARK: - Other

  func test_other() {
    XCTAssertDescription(
      .setupAnnotations,
      "setupAnnotations"
    )
    XCTAssertDescription(
      .popBlock,
      "popBlock"
    )
    XCTAssertDescription(
      .loadClosure(cellOrFreeIndex: 0x42),
      "loadClosure(cellOrFreeIndex: 0x42)"
    )

    XCTAssertDescription(
      .buildSlice(type: .lowerUpper),
      "buildSlice(type: lowerUpper)"
    )
    XCTAssertDescription(
      .buildSlice(type: .lowerUpperStep),
      "buildSlice(type: lowerUpperStep)"
    )
  }
}
