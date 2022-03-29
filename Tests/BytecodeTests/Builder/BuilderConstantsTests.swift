import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

class BuilderConstantsTests: XCTestCase {

  // MARK: - Boolean

  func test_appendTrue() {
    let builder = createBuilder()
    builder.appendTrue()

    let code = builder.finalize()
    XCTAssertConstants(code, .true)
    XCTAssertInstructions(code, .loadConst(index: 0))
  }

  func test_appendTrue_constantIndex_isReused() {
    let builder = createBuilder()
    builder.appendTrue()
    builder.appendTrue()

    let code = builder.finalize()
    XCTAssertConstants(code, .true)
    XCTAssertInstructions(code, .loadConst(index: 0), .loadConst(index: 0))
  }

  func test_appendFalse() {
    let builder = createBuilder()
    builder.appendFalse()

    let code = builder.finalize()
    XCTAssertConstants(code, .false)
    XCTAssertInstructions(code, .loadConst(index: 0))
  }

  func test_appendFalse_constantIndex_isReused() {
    let builder = createBuilder()
    builder.appendFalse()
    builder.appendFalse()

    let code = builder.finalize()
    XCTAssertConstants(code, .false)
    XCTAssertInstructions(code, .loadConst(index: 0), .loadConst(index: 0))
  }

  // MARK: - None

  func test_appendNone() {
    let builder = createBuilder()
    builder.appendNone()

    let code = builder.finalize()
    XCTAssertConstants(code, .none)
    XCTAssertInstructions(code, .loadConst(index: 0))
  }

  func test_appendNone_constantIndex_isReused() {
    let builder = createBuilder()
    builder.appendNone()
    builder.appendNone()

    let code = builder.finalize()
    XCTAssertConstants(code, .none)
    XCTAssertInstructions(code, .loadConst(index: 0), .loadConst(index: 0))
  }

  // MARK: - Ellipsis

  func test_appendEllipsis() {
    let builder = createBuilder()
    builder.appendEllipsis()

    let code = builder.finalize()
    XCTAssertConstants(code, .ellipsis)
    XCTAssertInstructions(code, .loadConst(index: 0))
  }

  func test_appendEllipsis_constantIndex_isReused() {
    let builder = createBuilder()
    builder.appendEllipsis()
    builder.appendEllipsis()

    let code = builder.finalize()
    XCTAssertConstants(code, .ellipsis)
    XCTAssertInstructions(code, .loadConst(index: 0), .loadConst(index: 0))
  }

  // MARK: - Int

  func test_appendInteger_small() {
    let value = BigInt(42)

    let builder = createBuilder()
    builder.appendInteger(value)

    let code = builder.finalize()
    XCTAssertConstants(code, .integer(value))
    XCTAssertInstructions(code, .loadConst(index: 0))
  }

  func test_appendInteger_zero_constantIndex_isReused() {
    let value = BigInt.zero

    let builder = createBuilder()
    builder.appendInteger(value)
    builder.appendInteger(value)

    let code = builder.finalize()
    XCTAssertConstants(code, .integer(value))
    XCTAssertInstructions(code, .loadConst(index: 0), .loadConst(index: 0))
  }

  func test_appendInteger_one_constantIndex_isReused() {
    let value = BigInt(1)

    let builder = createBuilder()
    builder.appendInteger(value)
    builder.appendInteger(value)

    let code = builder.finalize()
    XCTAssertConstants(code, .integer(value))
    XCTAssertInstructions(code, .loadConst(index: 0), .loadConst(index: 0))
  }

  func test_appendInteger_big() throws {
    let value = try BigInt("42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42_42")

    let builder = createBuilder()
    builder.appendInteger(value)

    let code = builder.finalize()
    XCTAssertConstants(code, .integer(value))
    XCTAssertInstructions(code, .loadConst(index: 0))
  }

  // MARK: - Float

  func test_appendFloat() {
    let value = 4.2

    let builder = createBuilder()
    builder.appendFloat(value)

    let code = builder.finalize()
    XCTAssertConstants(code, .float(value))
    XCTAssertInstructions(code, .loadConst(index: 0))
  }

  // MARK: - Complex

  func test_appendComplex() {
    let real = 4.2
    let imag = 2.4

    let builder = createBuilder()
    builder.appendComplex(real: real, imag: imag)

    let code = builder.finalize()
    XCTAssertConstants(code, .complex(real: real, imag: imag))
    XCTAssertInstructions(code, .loadConst(index: 0))
  }

  // MARK: - String

  func test_appendString() {
    let value = "Ariel"

    let builder = createBuilder()
    builder.appendString(value)

    let code = builder.finalize()
    XCTAssertConstants(code, .string(value))
    XCTAssertInstructions(code, .loadConst(index: 0))
  }

  func test_appendString_constantIndex_isReused() {
    let value = "Sebastian"

    let builder = createBuilder()
    builder.appendString(value)
    builder.appendString(value)

    let code = builder.finalize()
    XCTAssertConstants(code, .string(value))
    XCTAssertInstructions(code, .loadConst(index: 0), .loadConst(index: 0))
  }

  func test_appendString_mangled() {
    let className = "Little_Mermaid"
    let name = "__Ariel"
    let mangled = MangledName(className: className, name: name)
    let expectedMangled = "_Little_Mermaid__Ariel"
    XCTAssertEqual(mangled.value, expectedMangled)

    let builder = createBuilder()
    builder.appendString(mangled)

    let code = builder.finalize()
    XCTAssertConstants(code, .string(expectedMangled))
    XCTAssertInstructions(code, .loadConst(index: 0))
  }

  func test_appendString_mangled_constantIndex_isReused() {
    let className = "Little_Mermaid"
    let name = "__Sebastian"
    let mangled = MangledName(className: className, name: name)
    let expectedMangled = "_Little_Mermaid__Sebastian"
    XCTAssertEqual(mangled.value, expectedMangled)

    let builder = createBuilder()
    builder.appendString(mangled) // MangledName
    builder.appendString(expectedMangled) // String

    let code = builder.finalize()
    XCTAssertConstants(code, .string(expectedMangled))
    XCTAssertInstructions(code, .loadConst(index: 0), .loadConst(index: 0))
  }

  // MARK: - String - Add constant

  func test_addConstant() {
    let value = "Ariel"

    let builder = createBuilder()
    builder.addConstant(string: value)

    let code = builder.finalize()
    XCTAssertConstants(code, .string(value))
    XCTAssertNoInstructions(code)
  }

  // MARK: - Bytes

  func test_appendBytes() {
    let value = Data([1, 2, 3])

    let builder = createBuilder()
    builder.appendBytes(value)

    let code = builder.finalize()
    XCTAssertConstants(code, .bytes(value))
    XCTAssertInstructions(code, .loadConst(index: 0))
  }

  // MARK: - Tuple

  func test_appendTuple() {
    let values: [CodeObject.Constant] = [.true, .false, .none, .integer(42)]

    let builder = createBuilder()
    builder.appendTuple(values)

    let code = builder.finalize()
    XCTAssertConstants(code, .tuple(values))
    XCTAssertInstructions(code, .loadConst(index: 0))
  }

  // MARK: - Code

  func test_appendCode() {
    let nestedBuilder = createBuilder()
    let nestedCode = nestedBuilder.finalize()

    let builder = createBuilder()
    builder.appendCode(nestedCode)

    let code = builder.finalize()
    XCTAssertConstants(code, .code(nestedCode))
    XCTAssertInstructions(code, .loadConst(index: 0))
  }

  // MARK: - Mix

  struct ConstantCase {
    let value: CodeObject.Constant
    let append: (CodeObjectBuilder) -> Void
  }

  func test_mixDifferentTypes_where_constantIndex_isReused() {
    // Those constants will be reused:
    let cases = [
      ConstantCase(value: .true) { $0.appendTrue() },
      ConstantCase(value: .false) { $0.appendFalse() },
      ConstantCase(value: .none) { $0.appendNone() },
      ConstantCase(value: .ellipsis) { $0.appendEllipsis() },
      ConstantCase(value: .integer(0)) { $0.appendInteger(0) },
      ConstantCase(value: .integer(1)) { $0.appendInteger(1) }
    ]

    // Append each constant 2 times
    let builder = createBuilder()
    for c in cases { c.append(builder) }
    for c in cases { c.append(builder) }

    let code = builder.finalize()
    let constants = code.constants
    let instructions = code.instructions

    XCTAssertEqual(constants.count, cases.count)
    guard instructions.count == cases.count else { return }

    for (index, c) in cases.enumerated() {
      XCTAssertEqual(constants[index], c.value)
    }

    let expectedInstructionCount = cases.count * 2
    XCTAssertEqual(instructions.count, expectedInstructionCount)
    guard instructions.count == expectedInstructionCount else { return }

    for index in cases.indices {
      let indexUInt8 = UInt8(index)

      let instruction0 = instructions[index]
      XCTAssertEqual(instruction0, .loadConst(index: indexUInt8))

      // We added each case 2 times
      let instruction1 = instructions[index + cases.count]
      XCTAssertEqual(instruction1, .loadConst(index: indexUInt8))
    }
  }
}
