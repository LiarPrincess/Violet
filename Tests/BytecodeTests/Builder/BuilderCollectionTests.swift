import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

class BuilderCollectionTests: XCTestCase {

  // MARK: - Tuple

  func test_appendBuildTuple() {
    let builder = createBuilder()
    builder.appendBuildTuple(elementCount: 42)

    let code = builder.finalize()
    XCTAssertInstructions(code, .buildTuple(elementCount: 42))
  }

  func test_appendBuildTuple_extended() {
    let builder = createBuilder()
    builder.appendBuildTuple(elementCount: 256)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .buildTuple(elementCount: 0))
  }

  func test_appendBuildTuple_extended2() {
    let builder = createBuilder()
    builder.appendBuildTuple(elementCount: 0xff_ffff)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .extendedArg(0xff),
                          .extendedArg(0xff),
                          .buildTuple(elementCount: 0xff))
  }

  func test_appendBuildTuple_extended3() {
    let builder = createBuilder()
    builder.appendBuildTuple(elementCount: 0xffff_ffff)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .extendedArg(0xff),
                          .extendedArg(0xff),
                          .extendedArg(0xff),
                          .buildTuple(elementCount: 0xff))
  }

  // MARK: - List

  func test_appendBuildList() {
    let builder = createBuilder()
    builder.appendBuildList(elementCount: 42)

    let code = builder.finalize()
    XCTAssertInstructions(code, .buildList(elementCount: 42))
  }

  func test_appendBuildList_extended() {
    let builder = createBuilder()
    builder.appendBuildList(elementCount: 256)

    let code = builder.finalize()
    XCTAssertInstructions(code, .extendedArg(1), .buildList(elementCount: 0))
  }

  // MARK: - Set

  func test_appendBuildSet() {
    let builder = createBuilder()
    builder.appendBuildSet(elementCount: 42)

    let code = builder.finalize()
    XCTAssertInstructions(code, .buildSet(elementCount: 42))
  }

  func test_appendBuildSet_extended() {
    let builder = createBuilder()
    builder.appendBuildSet(elementCount: 256)

    let code = builder.finalize()
    XCTAssertInstructions(code, .extendedArg(1), .buildSet(elementCount: 0))
  }

  // MARK: - Map

  func test_appendBuildMap() {
    let builder = createBuilder()
    builder.appendBuildMap(elementCount: 42)

    let code = builder.finalize()
    XCTAssertInstructions(code, .buildMap(elementCount: 42))
  }

  func test_appendBuildMap_extended() {
    let builder = createBuilder()
    builder.appendBuildMap(elementCount: 256)

    let code = builder.finalize()
    XCTAssertInstructions(code, .extendedArg(1), .buildMap(elementCount: 0))
  }

  func test_appendBuildConstKeyMap() {
    let builder = createBuilder()
    builder.appendBuildConstKeyMap(elementCount: 42)

    let code = builder.finalize()
    XCTAssertInstructions(code, .buildConstKeyMap(elementCount: 42))
  }

  func test_appendBuildConstKeyMap_extended() {
    let builder = createBuilder()
    builder.appendBuildConstKeyMap(elementCount: 256)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .buildConstKeyMap(elementCount: 0))
  }

  // MARK: - List append

  func test_appendListAppend() {
    let builder = createBuilder()
    builder.appendListAppend(relativeStackIndex: 42)

    let code = builder.finalize()
    XCTAssertInstructions(code, .listAppend(relativeStackIndex: 42))
  }

  func test_appendListAppend_extended() {
    let builder = createBuilder()
    builder.appendListAppend(relativeStackIndex: 256)

    let code = builder.finalize()
    XCTAssertInstructions(code, .extendedArg(1), .listAppend(relativeStackIndex: 0))
  }

  // MARK: - Set add

  func test_appendSetAdd() {
    let builder = createBuilder()
    builder.appendSetAdd(relativeStackIndex: 42)

    let code = builder.finalize()
    XCTAssertInstructions(code, .setAdd(relativeStackIndex: 42))
  }

  func test_appendSetAdd_extended() {
    let builder = createBuilder()
    builder.appendSetAdd(relativeStackIndex: 256)

    let code = builder.finalize()
    XCTAssertInstructions(code, .extendedArg(1), .setAdd(relativeStackIndex: 0))
  }

  // MARK: - Map add

  func test_appendMapAdd() {
    let builder = createBuilder()
    builder.appendMapAdd(relativeStackIndex: 42)

    let code = builder.finalize()
    XCTAssertInstructions(code, .mapAdd(relativeStackIndex: 42))
  }

  func test_appendMapAdd_extended() {
    let builder = createBuilder()
    builder.appendMapAdd(relativeStackIndex: 256)

    let code = builder.finalize()
    XCTAssertInstructions(code, .extendedArg(1), .mapAdd(relativeStackIndex: 0))
  }

  // MARK: - Tuple unpack

  func test_appendBuildTupleUnpack() {
    let builder = createBuilder()
    builder.appendBuildTupleUnpack(elementCount: 42)

    let code = builder.finalize()
    XCTAssertInstructions(code, .buildTupleUnpack(elementCount: 42))
  }

  func test_appendBuildTupleUnpack_extended() {
    let builder = createBuilder()
    builder.appendBuildTupleUnpack(elementCount: 256)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .buildTupleUnpack(elementCount: 0))
  }

  func test_appendBuildTupleUnpackWithCall() {
    let builder = createBuilder()
    builder.appendBuildTupleUnpackWithCall(elementCount: 42)

    let code = builder.finalize()
    XCTAssertInstructions(code, .buildTupleUnpackWithCall(elementCount: 42))
  }

  func test_appendBuildTupleUnpackWithCall_extended() {
    let builder = createBuilder()
    builder.appendBuildTupleUnpackWithCall(elementCount: 256)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .buildTupleUnpackWithCall(elementCount: 0))
  }

  // MARK: - List unpack

  func test_appendBuildListUnpack() {
    let builder = createBuilder()
    builder.appendBuildListUnpack(elementCount: 42)

    let code = builder.finalize()
    XCTAssertInstructions(code, .buildListUnpack(elementCount: 42))
  }

  func test_appendBuildListUnpack_extended() {
    let builder = createBuilder()
    builder.appendBuildListUnpack(elementCount: 256)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .buildListUnpack(elementCount: 0))
  }

  // MARK: - Set unpack

  func test_appendBuildSetUnpack() {
    let builder = createBuilder()
    builder.appendBuildSetUnpack(elementCount: 42)

    let code = builder.finalize()
    XCTAssertInstructions(code, .buildSetUnpack(elementCount: 42))
  }

  func test_appendBuildSetUnpack_extended() {
    let builder = createBuilder()
    builder.appendBuildSetUnpack(elementCount: 256)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .buildSetUnpack(elementCount: 0))
  }

  // MARK: - Map unpack

  func test_appendBuildMapUnpack() {
    let builder = createBuilder()
    builder.appendBuildMapUnpack(elementCount: 42)

    let code = builder.finalize()
    XCTAssertInstructions(code, .buildMapUnpack(elementCount: 42))
  }

  func test_appendBuildMapUnpack_extended() {
    let builder = createBuilder()
    builder.appendBuildMapUnpack(elementCount: 256)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .buildMapUnpack(elementCount: 0))
  }

  func test_appendBuildMapUnpackWithCall() {
    let builder = createBuilder()
    builder.appendBuildMapUnpackWithCall(elementCount: 42)

    let code = builder.finalize()
    XCTAssertInstructions(code, .buildMapUnpackWithCall(elementCount: 42))
  }

  func test_appendBuildMapUnpackWithCall_extended() {
    let builder = createBuilder()
    builder.appendBuildMapUnpackWithCall(elementCount: 256)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .buildMapUnpackWithCall(elementCount: 0))
  }

  // MARK: - Unpack sequence

  func test_appendUnpackSequence() {
    let builder = createBuilder()
    builder.appendUnpackSequence(elementCount: 42)

    let code = builder.finalize()
    XCTAssertInstructions(code, .unpackSequence(elementCount: 42))
  }

  func test_appendUnpackSequence_extended() {
    let builder = createBuilder()
    builder.appendUnpackSequence(elementCount: 256)

    let code = builder.finalize()
    XCTAssertInstructions(code, .extendedArg(1), .unpackSequence(elementCount: 0))
  }

  // MARK: - Unpack ex

  func test_appendUnpackEx() {
    let builder = createBuilder()
    builder.appendUnpackEx(countBefore: 42, countAfter: 24)

    let code = builder.finalize()
    XCTAssertInstructions(code, .extendedArg(24), .unpackEx(arg: 42))
  }

  func test_appendUnpackEx_extended() {
    let builder = createBuilder()
    builder.appendUnpackEx(countBefore: 42, countAfter: 256)

    let code = builder.finalize()
    XCTAssertInstructions(code,
                          .extendedArg(1),
                          .extendedArg(0),
                          .unpackEx(arg: 42))
  }
}
