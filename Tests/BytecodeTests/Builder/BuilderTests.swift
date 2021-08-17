import XCTest
import VioletCore
@testable import VioletBytecode

private let name = "Ariel"
private let qualifiedName = "Sebastian"
private let filename = "Flounder"

class BuilderTests: XCTestCase {

  // MARK: - Name, filename, kind

  func test_names_forModule() {
    let kind = CodeObject.Kind.module

    let builder = createBuilder(name: name,
                                qualifiedName: qualifiedName,
                                filename: filename,
                                kind: kind)

    let code = builder.finalize()
    XCTAssertEqual(code.name, name)
    XCTAssertEqual(code.qualifiedName, qualifiedName)
    XCTAssertEqual(code.filename, filename)
    XCTAssertEqual(code.kind, kind)
  }

  func test_names_forClass() {
    let kind = CodeObject.Kind.class

    let builder = createBuilder(name: name,
                                qualifiedName: qualifiedName,
                                filename: filename,
                                kind: kind)

    let code = builder.finalize()
    XCTAssertEqual(code.name, name)
    XCTAssertEqual(code.qualifiedName, qualifiedName)
    XCTAssertEqual(code.filename, filename)
    XCTAssertEqual(code.kind, kind)
  }

  func test_names_forFunction() {
    let kind = CodeObject.Kind.function

    let builder = createBuilder(name: name,
                                qualifiedName: qualifiedName,
                                filename: filename,
                                kind: kind)

    let code = builder.finalize()
    XCTAssertEqual(code.name, name)
    XCTAssertEqual(code.qualifiedName, qualifiedName)
    XCTAssertEqual(code.filename, filename)
    XCTAssertEqual(code.kind, kind)
  }

  func test_names_forAsyncFunction() {
    let kind = CodeObject.Kind.asyncFunction

    let builder = createBuilder(name: name,
                                qualifiedName: qualifiedName,
                                filename: filename,
                                kind: kind)

    let code = builder.finalize()
    XCTAssertEqual(code.name, name)
    XCTAssertEqual(code.qualifiedName, qualifiedName)
    XCTAssertEqual(code.filename, filename)
    XCTAssertEqual(code.kind, kind)
  }

  func test_names_forLambda() {
    let kind = CodeObject.Kind.lambda

    let builder = createBuilder(name: name,
                                qualifiedName: qualifiedName,
                                filename: filename,
                                kind: kind)

    let code = builder.finalize()
    XCTAssertEqual(code.name, name)
    XCTAssertEqual(code.qualifiedName, qualifiedName)
    XCTAssertEqual(code.filename, filename)
    XCTAssertEqual(code.kind, kind)
  }

  func test_names_forComprehension() {
    let values: [CodeObject.ComprehensionKind] = [
      .list,
      .set,
      .dictionary,
      .generator
    ]

    for v in values {
      let kind = CodeObject.Kind.comprehension(v)
      let builder = createBuilder(name: name,
                                  qualifiedName: qualifiedName,
                                  filename: filename,
                                  kind: kind)

      let code = builder.finalize()
      XCTAssertEqual(code.name, name)
      XCTAssertEqual(code.qualifiedName, qualifiedName)
      XCTAssertEqual(code.filename, filename)
      XCTAssertEqual(code.kind, kind)
    }
  }

  // MARK: - Flags

  func test_property_flags() {
    let values: [CodeObject.Flags] = [
      [.optimized],
      [.newLocals],
      [.varArgs],
      [.varKeywords],
      [.nested],
      [.generator],
      [.noFree],
      [.coroutine],
      [.iterableCoroutine],
      [.asyncGenerator]
    ]

    for v in values {
      let builder = createBuilder(flags: v)
      let code = builder.finalize()
      XCTAssertEqual(code.flags, v)
    }
  }

  // MARK: - Variable names

  func test_property_variableNames() {
    let variableNames = [
      MangledName(withoutClass: "Ariel"),
      MangledName(withoutClass: "Sebastian")
    ]
    let freeVariableNames = [
      MangledName(withoutClass: "Beauty"),
      MangledName(withoutClass: "Beast")
    ]
    let cellVariableNames = [
      MangledName(withoutClass: "Pooh"),
      MangledName(withoutClass: "Tigger")
    ]

    let builder = createBuilder(variableNames: variableNames,
                                freeVariableNames: freeVariableNames,
                                cellVariableNames: cellVariableNames)

    let code = builder.finalize()
    XCTAssertEqual(code.variableNames, variableNames)
    XCTAssertEqual(code.freeVariableNames, freeVariableNames)
    XCTAssertEqual(code.cellVariableNames, cellVariableNames)
  }

  // MARK: - Arg count

  func test_property_argCount() {
    let argCount = 42
    let kwOnlyArgCount = 505
    let builder = createBuilder(argCount: argCount,
                                kwOnlyArgCount: kwOnlyArgCount)

    let code = builder.finalize()
    XCTAssertEqual(code.argCount, argCount)
    XCTAssertEqual(code.kwOnlyArgCount, kwOnlyArgCount)
  }

  // MARK: - First line

  func test_property_firsLine() {
    let lines: [SourceLine] = [42, 505]

    for line in lines {
      let builder = createBuilder(firstLine: line)
      let code = builder.finalize()
      XCTAssertEqual(code.firstLine, line)
    }
  }

  // MARK: - Label

  func test_createLabel_setLabel() {
    let builder = createBuilder()

    // Creating label
    XCTAssert(builder.labels.isEmpty)
    let notAssigned = builder.createLabel()

    // Before assign
    XCTAssertEqual(builder.labels.count, 1)
    guard builder.labels.count == 1 else { return }

    let labelBefore = builder.labels[0]
    XCTAssertEqual(labelBefore, CodeObject.Label.notAssigned)
    XCTAssertFalse(labelBefore.isAssigned)

    // Assign
    builder.appendNop()
    builder.setLabel(notAssigned)

    // After assign
    XCTAssertEqual(builder.labels.count, 1)
    guard builder.labels.count == 1 else { return }

    let labelAfter = builder.labels[0]
    XCTAssertEqual(labelAfter.instructionIndex, 1)
    XCTAssertTrue(labelAfter.isAssigned)

    // 'PeepholeOptimizer' may remove some jumps etc.
    let code = builder.finalize(usePeepholeOptimizer: false)

    XCTAssertEqual(code.labels.count, 1)
    guard code.labels.count == 1 else { return }

    let codeLabel = code.labels[0]
    XCTAssertEqual(codeLabel.instructionIndex, 1)
    XCTAssertTrue(codeLabel.isAssigned)
  }

  // MARK: - AppendLocation

  func test_setAppendLocation() {
    let location0 = SourceLocation(line: 42, column: 24)
    let location1 = SourceLocation(line: 43, column: 25)

    let builder = createBuilder()
    builder.setAppendLocation(location0)
    builder.appendTrue()
    builder.setAppendLocation(location1)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertInstructions(code, .loadConst(index: 0), .return)
    XCTAssertInstructionLines(code, location0, location1)
  }
}
