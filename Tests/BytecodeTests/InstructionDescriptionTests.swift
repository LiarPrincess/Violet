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

  // MARK: - General

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

    XCTAssertDescription(.compareOp(type: .is), "compareOp(type: is)")
    XCTAssertDescription(.compareOp(type: .isNot), "compareOp(type: isNot)")

    XCTAssertDescription(.compareOp(type: .in), "compareOp(type: in)")
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
      .setupLoop(loopEndLabelIndex: 42),
      "setupLoop(loopEndLabelIndex: 42)"
    )
    XCTAssertDescription(
      .forIter(ifEmptyLabelIndex: 42),
      "forIter(ifEmptyLabelIndex: 42)"
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
      .break,
      "break"
    )
    XCTAssertDescription(
      .continue(loopStartLabelIndex: 42),
      "continue(loopStartLabelIndex: 42)"
    )
  }

  func test_collections() {
    XCTAssertDescription(
      .buildTuple(elementCount: 42),
      "buildTuple(elementCount: 42)"
    )
    XCTAssertDescription(
      .buildList(elementCount: 42),
      "buildList(elementCount: 42)"
    )
    XCTAssertDescription(
      .buildSet(elementCount: 42),
      "buildSet(elementCount: 42)"
    )
    XCTAssertDescription(
      .buildMap(elementCount: 42),
      "buildMap(elementCount: 42)"
    )
    XCTAssertDescription(
      .buildConstKeyMap(elementCount: 42),
      "buildConstKeyMap(elementCount: 42)"
    )
    XCTAssertDescription(
      .setAdd(relativeStackIndex: 42),
      "setAdd(relativeStackIndex: 42)"
    )
    XCTAssertDescription(
      .listAppend(relativeStackIndex: 42),
      "listAppend(relativeStackIndex: 42)"
    )
    XCTAssertDescription(
      .mapAdd(relativeStackIndex: 42),
      "mapAdd(relativeStackIndex: 42)"
    )
  }

  func test_unpack() {
    XCTAssertDescription(
      .buildTupleUnpack(elementCount: 42),
      "buildTupleUnpack(elementCount: 42)"
    )
    XCTAssertDescription(
      .buildTupleUnpackWithCall(elementCount: 42),
      "buildTupleUnpackWithCall(elementCount: 42)"
    )
    XCTAssertDescription(
      .buildListUnpack(elementCount: 42),
      "buildListUnpack(elementCount: 42)"
    )
    XCTAssertDescription(
      .buildSetUnpack(elementCount: 42),
      "buildSetUnpack(elementCount: 42)"
    )
    XCTAssertDescription(
      .buildMapUnpack(elementCount: 42),
      "buildMapUnpack(elementCount: 42)"
    )
    XCTAssertDescription(
      .buildMapUnpackWithCall(elementCount: 42),
      "buildMapUnpackWithCall(elementCount: 42)"
    )
    XCTAssertDescription(
      .unpackSequence(elementCount: 42),
      "unpackSequence(elementCount: 42)"
    )
    XCTAssertDescription(
      .unpackEx(arg: 42),
      "unpackEx(arg: 42)"
    )
  }

  // MARK: - Store, load, delete

  func test_storeLoadDelete_constant() {
    XCTAssertDescription(
      .loadConst(index: 42),
      "loadConst(index: 42)"
    )
  }

  func test_storeLoadDelete_name() {
    XCTAssertDescription(
      .storeName(nameIndex: 42),
      "storeName(nameIndex: 42)"
    )
    XCTAssertDescription(
      .loadName(nameIndex: 42),
      "loadName(nameIndex: 42)"
    )
    XCTAssertDescription(
      .deleteName(nameIndex: 42),
      "deleteName(nameIndex: 42)"
    )
  }

  func test_storeLoadDelete_attribute() {
    XCTAssertDescription(
      .storeAttribute(nameIndex: 42),
      "storeAttribute(nameIndex: 42)"
    )
    XCTAssertDescription(
      .loadAttribute(nameIndex: 42),
      "loadAttribute(nameIndex: 42)"
    )
    XCTAssertDescription(
      .deleteAttribute(nameIndex: 42),
      "deleteAttribute(nameIndex: 42)"
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
      .storeGlobal(nameIndex: 42),
      "storeGlobal(nameIndex: 42)"
    )
    XCTAssertDescription(
      .loadGlobal(nameIndex: 42),
      "loadGlobal(nameIndex: 42)"
    )
    XCTAssertDescription(
      .deleteGlobal(nameIndex: 42),
      "deleteGlobal(nameIndex: 42)"
    )
  }

  func test_storeLoadDelete_fast() {
    XCTAssertDescription(
      .loadFast(variableIndex: 42),
      "loadFast(variableIndex: 42)"
    )
    XCTAssertDescription(
      .storeFast(variableIndex: 42),
      "storeFast(variableIndex: 42)"
    )
    XCTAssertDescription(
      .deleteFast(variableIndex: 42),
      "deleteFast(variableIndex: 42)"
    )
  }

  func test_storeLoadDelete_cell() {
    XCTAssertDescription(
      .loadCell(cellIndex: 42),
      "loadCell(cellIndex: 42)"
    )
    XCTAssertDescription(
      .storeCell(cellIndex: 42),
      "storeCell(cellIndex: 42)"
    )
    XCTAssertDescription(
      .deleteCell(cellIndex: 42),
      "deleteCell(cellIndex: 42)"
    )
  }

  func test_storeLoadDelete_free() {
    XCTAssertDescription(
      .loadFree(freeIndex: 42),
      "loadFree(freeIndex: 42)"
    )
    XCTAssertDescription(
      .storeFree(freeIndex: 42),
      "storeFree(freeIndex: 42)"
    )
    XCTAssertDescription(
      .deleteFree(freeIndex: 42),
      "deleteFree(freeIndex: 42)"
    )
    XCTAssertDescription(
      .loadClassFree(freeIndex: 42),
      "loadClassFree(freeIndex: 42)"
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
      .callFunction(argumentCount: 42),
      "callFunction(argumentCount: 42)"
    )
    XCTAssertDescription(
      .callFunctionKw(argumentCount: 42),
      "callFunctionKw(argumentCount: 42)"
    )
    XCTAssertDescription(
      .callFunctionEx(hasKeywordArguments: false),
      "callFunctionEx(hasKeywordArguments: false)"
    )
    XCTAssertDescription(
      .return,
      "return"
    )
    XCTAssertDescription(
      .loadMethod(nameIndex: 42),
      "loadMethod(nameIndex: 42)"
    )
    XCTAssertDescription(
      .callMethod(argumentCount: 42),
      "callMethod(argumentCount: 42)"
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
      .importName(nameIndex: 42),
      "importName(nameIndex: 42)"
    )
    XCTAssertDescription(
      .importFrom(nameIndex: 42),
      "importFrom(nameIndex: 42)"
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
      .setupExcept(firstExceptLabelIndex: 42),
      "setupExcept(firstExceptLabelIndex: 42)"
    )
    XCTAssertDescription(
      .setupFinally(finallyStartLabelIndex: 42),
      "setupFinally(finallyStartLabelIndex: 42)"
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
      .setupWith(afterBodyLabelIndex: 42),
      "setupWith(afterBodyLabelIndex: 42)"
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
      .jumpAbsolute(labelIndex: 42),
      "jumpAbsolute(labelIndex: 42)"
    )
    XCTAssertDescription(
      .popJumpIfTrue(labelIndex: 42),
      "popJumpIfTrue(labelIndex: 42)"
    )
    XCTAssertDescription(
      .popJumpIfFalse(labelIndex: 42),
      "popJumpIfFalse(labelIndex: 42)"
    )
    XCTAssertDescription(
      .jumpIfTrueOrPop(labelIndex: 42),
      "jumpIfTrueOrPop(labelIndex: 42)"
    )
    XCTAssertDescription(
      .jumpIfFalseOrPop(labelIndex: 42),
      "jumpIfFalseOrPop(labelIndex: 42)"
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
    .buildString(elementCount: 42),
    "buildString(elementCount: 42)"
    )
  }

  // MARK: - Extended

  func test_extended() {
    XCTAssertDescription(.extendedArg(42), "extendedArg(42)")
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
      .loadClosure(cellOrFreeIndex: 42),
      "loadClosure(cellOrFreeIndex: 42)"
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
