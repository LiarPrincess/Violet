import XCTest
import VioletCore
@testable import VioletBytecode

// swiftlint:disable file_length

/// String `elsa`
private let elsa = "elsa"
/// `Data` representing 'elsa' in ASCII
private let elsaBytes = Data([101, 108, 115, 97])
/// Mangled name with value: `_Frozen__Elsa`
private let _Frozen__Elsa = MangledName(className: "Frozen", name: "__Elsa")
/// Label with `jumpAddress = 42`
private let label42 = CodeObject.Label(instructionIndex: 42)

private func XCTAssertDescription(_ instruction: Instruction.Filled,
                                  _ expected: String,
                                  file: StaticString = #file,
                                  line: UInt = #line) {
  let description = String(describing: instruction)
  XCTAssertEqual(description, expected, file: file, line: line)
}

class InstructionFilledDescriptionTests: XCTestCase {

  func test_isOurMangledNameCorrect() {
    XCTAssertEqual(_Frozen__Elsa.value, "_Frozen__Elsa")
  }

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

/*
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
      .`break`,
      "break"
    )
    XCTAssertDescription(
      .`continue`(loopStartLabelIndex: 42),
      "continue(loopStartLabelIndex: 42)"
    )
  }
*/
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

    let unpackExArg = Instruction.UnpackExArg(countBefore: 42, countAfter: 43)
    XCTAssertDescription(
      .unpackEx(arg: unpackExArg),
      "unpackEx(arg: UnpackExArg(countBefore: 42, countAfter: 43))"
    )
  }

  // MARK: - Store, load, delete

  func test_storeLoadDelete_constant() {
    XCTAssertDescription(.loadConst(.true), "loadConst(true)")
    XCTAssertDescription(.loadConst(.false), "loadConst(false)")

    XCTAssertDescription(.loadConst(.none), "loadConst(none)")
    XCTAssertDescription(.loadConst(.ellipsis), "loadConst(ellipsis)")

    XCTAssertDescription(
      .loadConst(.integer(42)),
      "loadConst(integer(42))"
    )
    XCTAssertDescription(
      .loadConst(.float(42.3)),
      "loadConst(float(42.3))"
    )
    XCTAssertDescription(
      .loadConst(.complex(real: 42.3, imag: 45.6)),
      "loadConst(complex(real: 42.3, imag: 45.6))"
    )

    XCTAssertDescription(
      .loadConst(.string(elsa)),
      "loadConst(string(elsa))"
    )
    XCTAssertDescription(
      .loadConst(.bytes(elsaBytes)),
      "loadConst(bytes(4 bytes))"
    )

    // We are NOT doing this one (too much work)!
//    XCTAssertDescription(
//      .loadConst(.code(CodeObject)),
//      "loadConst(code(CodeObject))"
//    )

    XCTAssertDescription(
      .loadConst(.tuple([.true, .false, .string(elsa)])),
      "loadConst(tuple([true, false, string(elsa)]))"
    )
  }

  func test_storeLoadDelete_name() {
    XCTAssertDescription(
      .storeName(name: elsa),
      "storeName(name: elsa)"
    )
    XCTAssertDescription(
      .loadName(name: elsa),
      "loadName(name: elsa)"
    )
    XCTAssertDescription(
      .deleteName(name: elsa),
      "deleteName(name: elsa)"
    )
  }

  func test_storeLoadDelete_attribute() {
    XCTAssertDescription(
      .storeAttribute(name: elsa),
      "storeAttribute(name: elsa)"
    )
    XCTAssertDescription(
      .loadAttribute(name: elsa),
      "loadAttribute(name: elsa)"
    )
    XCTAssertDescription(
      .deleteAttribute(name: elsa),
      "deleteAttribute(name: elsa)"
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
      .storeGlobal(name: elsa),
      "storeGlobal(name: elsa)"
    )
    XCTAssertDescription(
      .loadGlobal(name: elsa),
      "loadGlobal(name: elsa)"
    )
    XCTAssertDescription(
      .deleteGlobal(name: elsa),
      "deleteGlobal(name: elsa)"
    )
  }

  func test_storeLoadDelete_fast() {
    XCTAssertDescription(
      .loadFast(variable: _Frozen__Elsa),
      "loadFast(variable: _Frozen__Elsa)"
    )
    XCTAssertDescription(
      .storeFast(variable: _Frozen__Elsa),
      "storeFast(variable: _Frozen__Elsa)"
    )
    XCTAssertDescription(
      .deleteFast(variable: _Frozen__Elsa),
      "deleteFast(variable: _Frozen__Elsa)"
    )
  }

  func test_storeLoadDelete_cell() {
    XCTAssertDescription(
      .loadCell(cell: _Frozen__Elsa),
      "loadCell(cell: _Frozen__Elsa)"
    )
    XCTAssertDescription(
      .storeCell(cell: _Frozen__Elsa),
      "storeCell(cell: _Frozen__Elsa)"
    )
    XCTAssertDescription(
      .deleteCell(cell: _Frozen__Elsa),
      "deleteCell(cell: _Frozen__Elsa)"
    )
  }

  func test_storeLoadDelete_free() {
    XCTAssertDescription(
      .loadFree(free: _Frozen__Elsa),
      "loadFree(free: _Frozen__Elsa)"
    )
    XCTAssertDescription(
      .storeFree(free: _Frozen__Elsa),
      "storeFree(free: _Frozen__Elsa)"
    )
    XCTAssertDescription(
      .deleteFree(free: _Frozen__Elsa),
      "deleteFree(free: _Frozen__Elsa)"
    )
    XCTAssertDescription(
      .loadClassFree(free: _Frozen__Elsa),
      "loadClassFree(free: _Frozen__Elsa)"
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
      .loadMethod(name: elsa),
      "loadMethod(name: elsa)"
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
      .importName(name: elsa),
      "importName(name: elsa)"
    )
    XCTAssertDescription(
      .importFrom(name: elsa),
      "importFrom(name: elsa)"
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
      .setupExcept(firstExceptLabel: label42),
      "setupExcept(firstExceptLabel: Label(instructionIndex: 42, byteOffset: 84))"
    )
    XCTAssertDescription(
      .setupFinally(finallyStartLabel: label42),
      "setupFinally(finallyStartLabel: Label(instructionIndex: 42, byteOffset: 84))"
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
      .setupWith(afterBodyLabel: label42),
      "setupWith(afterBodyLabel: Label(instructionIndex: 42, byteOffset: 84))"
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
      .jumpAbsolute(label: label42),
      "jumpAbsolute(label: Label(instructionIndex: 42, byteOffset: 84))"
    )
    XCTAssertDescription(
      .popJumpIfTrue(label: label42),
      "popJumpIfTrue(label: Label(instructionIndex: 42, byteOffset: 84))"
    )
    XCTAssertDescription(
      .popJumpIfFalse(label: label42),
      "popJumpIfFalse(label: Label(instructionIndex: 42, byteOffset: 84))"
    )
    XCTAssertDescription(
      .jumpIfTrueOrPop(label: label42),
      "jumpIfTrueOrPop(label: Label(instructionIndex: 42, byteOffset: 84))"
    )
    XCTAssertDescription(
      .jumpIfFalseOrPop(label: label42),
      "jumpIfFalseOrPop(label: Label(instructionIndex: 42, byteOffset: 84))"
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
      .loadClosure(cellOrFree: _Frozen__Elsa),
      "loadClosure(cellOrFree: _Frozen__Elsa)"
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
