import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

// swiftlint:disable file_length

class PeepholeJumpIfOrPopConditionalJumpTests: XCTestCase {

  // MARK: - Same condition - jumpIfOrPop

  func test_ifTrue_jumpIfTrueOrPop_isRedirected() {
    // jumpIfTrueOrPop -----.
    //   xxx                | jumps here
    // jumpIfTrueOrPop -. <-'
    //   xxx            | jumps here
    // xxx <------------'
    //
    // After optimization:
    // jumpIfTrueOrPop -.
    //   xxx            |
    // jumpIfTrueOrPop  | jumps here
    //   xxx            |
    // xxx <------------'

    let builder = createBuilder()
    let label0 = builder.createLabel()
    let label1 = builder.createLabel()
    builder.appendJumpIfTrueOrPop(to: label0)
    builder.appendLoadName("Snow White")
    builder.setLabel(label0)
    builder.appendJumpIfTrueOrPop(to: label1)
    builder.appendLoadName("Evil Queen")
    builder.setLabel(label1)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2, 4)
    XCTAssertNoConstants(code)
    XCTAssertNames(code, "Snow White", "Evil Queen")
    XCTAssertInstructions(
      code,
      .jumpIfTrueOrPop(labelIndex: 1), // 0 (new label)
      .loadName(nameIndex: 0), // 1
      .jumpIfTrueOrPop(labelIndex: 1), // 2
      .loadName(nameIndex: 1), // 3
      .return // 4
    )
  }

  func test_ifFalse_jumpIfFalseOrPop_isRedirected() {
    let builder = createBuilder()
    let label0 = builder.createLabel()
    let label1 = builder.createLabel()
    builder.appendJumpIfFalseOrPop(to: label0)
    builder.appendLoadName("Snow White")
    builder.setLabel(label0)
    builder.appendJumpIfFalseOrPop(to: label1)
    builder.appendLoadName("Evil Queen")
    builder.setLabel(label1)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2, 4)
    XCTAssertNoConstants(code)
    XCTAssertNames(code, "Snow White", "Evil Queen")
    XCTAssertInstructions(
      code,
      .jumpIfFalseOrPop(labelIndex: 1), // 0 (new label)
      .loadName(nameIndex: 0), // 1
      .jumpIfFalseOrPop(labelIndex: 1), // 2
      .loadName(nameIndex: 1), // 3
      .return // 4
    )
  }

  // MARK: - Same condition - popJumpIf

  func test_ifTrue_popJumpIfTrue_isRedirected() {
    // jumpIfTrueOrPop ---.
    //   xxx              | jumps here
    // popJumpIfTrue -. <-'
    //   xxx          | jumps here
    // xxx <----------'
    //
    // After optimization:
    // popJumpIfTrue -.
    //   xxx          |
    // popJumpIfTrue  | jumps here
    //   xxx          |
    // xxx <----------'

    let builder = createBuilder()
    let label0 = builder.createLabel()
    let label1 = builder.createLabel()
    builder.appendJumpIfTrueOrPop(to: label0)
    builder.appendLoadName("Snow White")
    builder.setLabel(label0)
    builder.appendPopJumpIfTrue(to: label1)
    builder.appendLoadName("Evil Queen")
    builder.setLabel(label1)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2, 4)
    XCTAssertNoConstants(code)
    XCTAssertNames(code, "Snow White", "Evil Queen")
    XCTAssertInstructions(
      code,
      .popJumpIfTrue(labelIndex: 1), // 0
      .loadName(nameIndex: 0), // 1
      .popJumpIfTrue(labelIndex: 1), // 2
      .loadName(nameIndex: 1), // 3
      .return // 4
    )
  }

  func test_ifFalse_popJumpIfFalse_isRedirected() {
    let builder = createBuilder()
    let label0 = builder.createLabel()
    let label1 = builder.createLabel()
    builder.appendJumpIfFalseOrPop(to: label0)
    builder.appendLoadName("Snow White")
    builder.setLabel(label0)
    builder.appendPopJumpIfFalse(to: label1)
    builder.appendLoadName("Evil Queen")
    builder.setLabel(label1)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2, 4)
    XCTAssertNoConstants(code)
    XCTAssertNames(code, "Snow White", "Evil Queen")
    XCTAssertInstructions(
      code,
      .popJumpIfFalse(labelIndex: 1), // 0
      .loadName(nameIndex: 0), // 1
      .popJumpIfFalse(labelIndex: 1), // 2
      .loadName(nameIndex: 1), // 3
      .return // 4
    )
  }

  // MARK: - Opposite condition - popJumpIf

  func test_ifTrue_popJumpIfFalse_addsNewLabel_justAfterPopJumpIf() {
    // jumpIfTrueOrPop ----.
    //   xxx               | jumps here
    // popJumpIfFalse -. <-'
    //   xxx           | jumps here
    // xxx <-----------'
    //
    // After optimization:
    // popJumpIfTrue -.
    //   xxx          | jumps here
    // popJumpIfTrue  |
    //   xxx <--------'
    // xxx

    let builder = createBuilder()
    let label0 = builder.createLabel()
    let label1 = builder.createLabel()
    builder.appendJumpIfTrueOrPop(to: label0)
    builder.appendLoadName("Snow White")
    builder.setLabel(label0)
    builder.appendPopJumpIfFalse(to: label1)
    builder.appendLoadName("Evil Queen")
    builder.setLabel(label1)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2, 4, 3)
    XCTAssertNoConstants(code)
    XCTAssertNames(code, "Snow White", "Evil Queen")
    XCTAssertInstructions(
      code,
      .popJumpIfTrue(labelIndex: 2), // 0 (new label)
      .loadName(nameIndex: 0), // 1
      .popJumpIfFalse(labelIndex: 1), // 2
      .loadName(nameIndex: 1), // 3
      .return // 4
    )
  }

  func test_ifFalse_popJumpIfTrue_addsNewLabel_justAfterPopJumpIf() {
    let builder = createBuilder()
    let label0 = builder.createLabel()
    let label1 = builder.createLabel()
    builder.appendJumpIfFalseOrPop(to: label0)
    builder.appendLoadName("Snow White")
    builder.setLabel(label0)
    builder.appendPopJumpIfTrue(to: label1)
    builder.appendLoadName("Evil Queen")
    builder.setLabel(label1)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2, 4, 3)
    XCTAssertNoConstants(code)
    XCTAssertNames(code, "Snow White", "Evil Queen")
    XCTAssertInstructions(
      code,
      .popJumpIfFalse(labelIndex: 2), // 0 (new label)
      .loadName(nameIndex: 0), // 1
      .popJumpIfTrue(labelIndex: 1), // 2
      .loadName(nameIndex: 1), // 3
      .return // 4
    )
  }

  // MARK: - Opposite condition - jumpIfXXXOrPop

  func test_ifTrue_jumpIfFalseOrPop_addsNewLabel_justAfterPopJumpIf() {
    // jumpIfTrueOrPop ------.
    //   xxx                 | jumps here
    // jumpIfFalseOrPop -. <-'
    //   xxx             | jumps here
    // xxx <-------------'
    //
    // After optimization:
    // popJumpIfTrue ----.
    //   xxx             | jumps here
    // jumpIfFalseOrPop  |
    //   xxx <-----------'
    // xxx

    let builder = createBuilder()
    let label0 = builder.createLabel()
    let label1 = builder.createLabel()
    builder.appendJumpIfTrueOrPop(to: label0)
    builder.appendLoadName("Snow White")
    builder.setLabel(label0)
    builder.appendPopJumpIfFalse(to: label1)
    builder.appendLoadName("Evil Queen")
    builder.setLabel(label1)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2, 4, 3)
    XCTAssertNoConstants(code)
    XCTAssertNames(code, "Snow White", "Evil Queen")
    XCTAssertInstructions(
      code,
      .popJumpIfTrue(labelIndex: 2), // 0 (new label)
      .loadName(nameIndex: 0), // 1
      .popJumpIfFalse(labelIndex: 1), // 2
      .loadName(nameIndex: 1), // 3
      .return // 4
    )
  }

  func test_ifFalse_jumpIfTrueOrPop_addsNewLabel_justAfterPopJumpIf() {
    let builder = createBuilder()
    let label0 = builder.createLabel()
    let label1 = builder.createLabel()
    builder.appendJumpIfFalseOrPop(to: label0)
    builder.appendLoadName("Snow White")
    builder.setLabel(label0)
    builder.appendPopJumpIfTrue(to: label1)
    builder.appendLoadName("Evil Queen")
    builder.setLabel(label1)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2, 4, 3)
    XCTAssertNoConstants(code)
    XCTAssertNames(code, "Snow White", "Evil Queen")
    XCTAssertInstructions(
      code,
      .popJumpIfFalse(labelIndex: 2), // 0 (new label)
      .loadName(nameIndex: 0), // 1
      .popJumpIfTrue(labelIndex: 1), // 2
      .loadName(nameIndex: 1), // 3
      .return // 4
    )
  }

  // MARK: - Multiple jumps in a row

  func test_ifTrue_jumpIfTrueOrPop_jumpIfTrueOrPop_isRedirected() {
    // jumpIfTrueOrPop ---------.
    //   xxx                    | jumps here
    // jumpIfTrueOrPop -----. <-'
    //   xxx                | jumps here
    // jumpIfTrueOrPop -. <-'
    //   xxx            | jumps here
    // xxx <------------'
    //
    // After optimization:
    // jumpIfTrueOrPop -+
    //   xxx            | jumps here
    // jumpIfTrueOrPop -+
    //   xxx            |
    // jumpIfTrueOrPop -+
    //   xxx            |
    // xxx <------------'

    let builder = createBuilder()
    let label0 = builder.createLabel()
    let label1 = builder.createLabel()
    let label2 = builder.createLabel()
    builder.appendJumpIfTrueOrPop(to: label0)
    builder.appendLoadName("Snow White")
    builder.setLabel(label0)
    builder.appendJumpIfTrueOrPop(to: label1)
    builder.appendLoadName("Evil Queen")
    builder.setLabel(label1)
    builder.appendJumpIfTrueOrPop(to: label2)
    builder.appendLoadName("Dwarf")
    builder.setLabel(label2)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2, 4, 6)
    XCTAssertNoConstants(code)
    XCTAssertNames(code, "Snow White", "Evil Queen", "Dwarf")
    XCTAssertInstructions(
      code,
      .jumpIfTrueOrPop(labelIndex: 2), // 0
      .loadName(nameIndex: 0), // 1
      .jumpIfTrueOrPop(labelIndex: 2), // 2
      .loadName(nameIndex: 1), // 3
      .jumpIfTrueOrPop(labelIndex: 2), // 4
      .loadName(nameIndex: 2), // 5
      .return // 6
    )
  }

  func test_ifTrue_jumpIfTrueOrPop_popJumpIfFalse_isRedirected() {
    // jumpIfTrueOrPop --------.
    //   xxx                   | jumps here
    // jumpIfTrueOrPop ----. <-'
    //   xxx               | jumps here
    // popJumpIfFalse -. <-'
    //   xxx           | jumps here
    // xxx <-----------'
    //
    // After optimization:
    // popJumpIfTrue ----.
    //   xxx             |
    // popJumpIfTrue ----+ jumps here (both should have their own label)
    //   xxx             |
    // popJumpIfFalse -. |
    //   xxx <---------|-'
    // xxx <-----------'

    let builder = createBuilder()
    let label0 = builder.createLabel()
    let label1 = builder.createLabel()
    let label2 = builder.createLabel()
    builder.appendJumpIfTrueOrPop(to: label0)
    builder.appendLoadName("Snow White")
    builder.setLabel(label0)
    builder.appendJumpIfTrueOrPop(to: label1)
    builder.appendLoadName("Evil Queen")
    builder.setLabel(label1)
    builder.appendPopJumpIfFalse(to: label2)
    builder.appendLoadName("Dwarf")
    builder.setLabel(label2)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2, 4, 6, 5, 5)
    XCTAssertNoConstants(code)
    XCTAssertNames(code, "Snow White", "Evil Queen", "Dwarf")
    XCTAssertInstructions(
      code,
      .popJumpIfTrue(labelIndex: 3), // 0
      .loadName(nameIndex: 0), // 1
      .popJumpIfTrue(labelIndex: 4), // 2
      .loadName(nameIndex: 1), // 3
      .popJumpIfFalse(labelIndex: 2), // 4
      .loadName(nameIndex: 2), // 5
      .return // 6
    )
  }

  func test_ifTrue_jumpIfFalseOrPop_popJumpIfTrue_isRedirected() {
    // jumpIfTrueOrPop --------.
    //   xxx                   | jumps here
    // jumpIfFalseOrPop ---. <-'
    //   xxx               | jumps here
    // popJumpIfTrue --. <-'
    //   xxx           | jumps here
    // xxx <-----------'
    //
    // After optimization:
    // popJumpIfTrue ---.
    //   xxx            | jumps here
    // popJumpIfFalse --|-.
    //   xxx <----------' | jumps here
    // popJumpIfTrue -.   |
    //   xxx <--------|---'
    // xxx <----------'

    let builder = createBuilder()
    let label0 = builder.createLabel()
    let label1 = builder.createLabel()
    let label2 = builder.createLabel()
    builder.appendJumpIfTrueOrPop(to: label0)
    builder.appendLoadName("Snow White")
    builder.setLabel(label0)
    builder.appendJumpIfFalseOrPop(to: label1)
    builder.appendLoadName("Evil Queen")
    builder.setLabel(label1)
    builder.appendPopJumpIfTrue(to: label2)
    builder.appendLoadName("Dwarf")
    builder.setLabel(label2)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2, 4, 6, 3, 5)
    XCTAssertNoConstants(code)
    XCTAssertNames(code, "Snow White", "Evil Queen", "Dwarf")
    XCTAssertInstructions(
      code,
      .popJumpIfTrue(labelIndex: 3), // 0
      .loadName(nameIndex: 0), // 1
      .popJumpIfFalse(labelIndex: 4), // 2
      .loadName(nameIndex: 1), // 3
      .popJumpIfTrue(labelIndex: 2), // 4
      .loadName(nameIndex: 2), // 5
      .return // 6
    )
  }

  func test_ifTrue_jumpIfFalseOrPop_popJumpIfFalse_isRedirected() {
    // jumpIfTrueOrPop --------.
    //   xxx                   | jumps here
    // jumpIfFalseOrPop ---. <-'
    //   xxx               | jumps here
    // popJumpIfFalse -. <-'
    //   xxx           | jumps here
    // xxx <-----------'
    //
    // After optimization:
    // popJumpIfTrue -----.
    //   xxx              | jumps here
    // jumpIfFalseOrPop --|---------.
    //   xxx <------------'         |
    // popJumpIfFalse -.            | jumps here
    //   xxx           | jumps here |
    // xxx <-----------+------------'

    let builder = createBuilder()
    let label0 = builder.createLabel()
    let label1 = builder.createLabel()
    let label2 = builder.createLabel()
    builder.appendJumpIfTrueOrPop(to: label0)
    builder.appendLoadName("Snow White")
    builder.setLabel(label0)
    builder.appendJumpIfFalseOrPop(to: label1)
    builder.appendLoadName("Evil Queen")
    builder.setLabel(label1)
    builder.appendPopJumpIfFalse(to: label2)
    builder.appendLoadName("Dwarf")
    builder.setLabel(label2)
    builder.appendReturn()

    let code = builder.finalize()
    XCTAssertLabelTargets(code, 2, 4, 6, 3)
    XCTAssertNoConstants(code)
    XCTAssertNames(code, "Snow White", "Evil Queen", "Dwarf")
    XCTAssertInstructions(
      code,
      .popJumpIfTrue(labelIndex: 3), // 0 (new label)
      .loadName(nameIndex: 0), // 1
      .popJumpIfFalse(labelIndex: 2), // 2
      .loadName(nameIndex: 1), // 3
      .popJumpIfFalse(labelIndex: 2), // 4
      .loadName(nameIndex: 2), // 5
      .return // 6
    )
  }

  // MARK: - Space

  func test_ifTrue_jumpIfTrueOrPop_notEnoughSpace_doesNothing() {
    let builder = createBuilder()
    let smallLabel = builder.createLabel()
    add256Labels(builder: builder)
    let bigLabel = builder.createLabel()
    builder.appendJumpIfTrueOrPop(to: smallLabel)
    builder.appendLoadName("Snow White")
    builder.setLabel(smallLabel)
    builder.appendJumpIfTrueOrPop(to: bigLabel)
    builder.appendLoadName("Evil Queen")
    builder.setLabel(bigLabel)
    builder.appendReturn()

    let code = builder.finalize()
    // XCTAssertLabelTargets(code, 2, 4)
    XCTAssertNoConstants(code)
    XCTAssertNames(code, "Snow White", "Evil Queen")
    XCTAssertInstructions(
      code,
      .jumpIfTrueOrPop(labelIndex: 0), // 0 - no space for 'extendedArg'!
      .loadName(nameIndex: 0), // 1
      .extendedArg(1), // 2
      .jumpIfTrueOrPop(labelIndex: 1), // 3
      .loadName(nameIndex: 1), // 4
      .return // 5
    )
  }

  func test_ifTrue_jumpIfTrueOrPop_tooMuchSpace_addNops() {
    let builder = createBuilder()
    let smallLabel = builder.createLabel()
    add256Labels(builder: builder)
    let bigLabel = builder.createLabel()
    builder.appendJumpIfTrueOrPop(to: bigLabel)
    builder.appendLoadName("Snow White")
    builder.setLabel(bigLabel)
    builder.appendJumpIfTrueOrPop(to: smallLabel)
    builder.appendLoadName("Evil Queen")
    builder.setLabel(smallLabel)
    builder.appendReturn()

    let code = builder.finalize()
    // XCTAssertLabelTargets(code, 2, 4)
    XCTAssertNoConstants(code)
    XCTAssertNames(code, "Snow White", "Evil Queen")
    XCTAssertInstructions(
      code,
      .jumpIfTrueOrPop(labelIndex: 0), // 0, label is 'smallLabel'
      .loadName(nameIndex: 0), // 1
      .jumpIfTrueOrPop(labelIndex: 0), // 2, label is 'smallLabel'
      .loadName(nameIndex: 1), // 3
      .return // 4
    )
  }
}
