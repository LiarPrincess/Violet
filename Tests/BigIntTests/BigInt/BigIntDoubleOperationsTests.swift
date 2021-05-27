import XCTest
@testable import BigInt

// swiftlint:disable file_length

private typealias Word = BigIntHeap.Word

/// Double operation - operation that applied 2 times can also be expressed
/// as a single application.
/// For example: `(n + 5) + 7 = n + (5 + 7) = n + 12`.
///
/// This is not exactly associativity, because we will also do this for shifts:
/// `(n >> x) >> y = n >> (x + y)`.
class BigIntDoubleOperationsTests: XCTestCase {

  private lazy var smiValues = generateSmiValues(countButNotReally: 20)
  private lazy var heapValues = generateHeapValues(countButNotReally: 20)

  // MARK: - Add

  func test_add_smiSmi() {
    for smi in self.smiValues {
      let int = self.create(smi)
      self.addSmiTest(value: int)
    }
  }

  func test_add_smiHeap() {
    for smi in self.smiValues {
      let int = self.create(smi)
      self.addHeapTest(value: int)
    }
  }

  func test_add_heapSmi() {
    for smi in self.heapValues {
      let int = self.create(smi)
      self.addSmiTest(value: int)
    }
  }

  func test_add_heapHeap() {
    for p in self.heapValues {
      let int = self.create(p)
      self.addHeapTest(value: int)
    }
  }

  private enum AddSubValues {

    fileprivate static let smiA = BigInt(Smi.Storage.max / 2)
    fileprivate static let smiB = BigInt(Smi.Storage.max / 4)
    /// It is guaranteed that `Self.smiC = Self.smiA + Self.smiB`
    fileprivate static let smiC = Self.smiA + Self.smiB

    fileprivate static let heapA = BigInt(Word.max / 2)
    fileprivate static let heapB = BigInt(Word.max / 4)
    /// It is guaranteed that `Self.heapC = Self.heapA + Self.heapB`
    fileprivate static let heapC = Self.heapA + Self.heapB
  }

  private func addSmiTest(value: BigInt,
                          file: StaticString = #file,
                          line: UInt = #line) {
    let double = value + AddSubValues.smiA + AddSubValues.smiB
    let single = value + AddSubValues.smiC

    XCTAssertEqual(
      double,
      single,
      "\(value) + \(AddSubValues.smiA) + \(AddSubValues.smiB)",
      file: file,
      line: line
    )

    var inoutDouble = value
    inoutDouble += AddSubValues.smiA
    inoutDouble += AddSubValues.smiB

    var inoutSingle = value
    inoutSingle += AddSubValues.smiC

    XCTAssertEqual(
      double,
      single,
      "INOUT !!1 \(value) + \(AddSubValues.smiA) + \(AddSubValues.smiB)",
      file: file,
      line: line
    )
  }

  private func addHeapTest(value: BigInt,
                           file: StaticString = #file,
                           line: UInt = #line) {
    let double = value + AddSubValues.heapA + AddSubValues.heapB
    let single = value + AddSubValues.heapC

    XCTAssertEqual(
      double,
      single,
      "\(value) + \(AddSubValues.heapA) + \(AddSubValues.heapB)",
      file: file,
      line: line
    )

    var inoutDouble = value
    inoutDouble += AddSubValues.heapA
    inoutDouble += AddSubValues.heapB

    var inoutSingle = value
    inoutSingle += AddSubValues.heapC

    XCTAssertEqual(
      double,
      single,
      "INOUT !!1 \(value) + \(AddSubValues.heapA) + \(AddSubValues.heapB)",
      file: file,
      line: line
    )
  }

  // MARK: - Sub

  func test_sub_smiSmi() {
    for smi in self.smiValues {
      let int = self.create(smi)
      self.subSmiTest(value: int)
    }
  }

  func test_sub_smiHeap() {
    for smi in self.smiValues {
      let int = self.create(smi)
      self.subHeapTest(value: int)
    }
  }

  func test_sub_heapSmi() {
    for smi in self.heapValues {
      let int = self.create(smi)
      self.subSmiTest(value: int)
    }
  }

  func test_sub_heapHeap() {
    for p in self.heapValues {
      let int = self.create(p)
      self.subHeapTest(value: int)
    }
  }

  private func subSmiTest(value: BigInt,
                          file: StaticString = #file,
                          line: UInt = #line) {
    let double = value + AddSubValues.smiA + AddSubValues.smiB
    let single = value + AddSubValues.smiC

    XCTAssertEqual(
      double,
      single,
      "\(value) - \(AddSubValues.smiA) - \(AddSubValues.smiB)",
      file: file,
      line: line
    )

    var inoutDouble = value
    inoutDouble -= AddSubValues.smiA
    inoutDouble -= AddSubValues.smiB

    var inoutSingle = value
    inoutSingle -= AddSubValues.smiC

    XCTAssertEqual(
      double,
      single,
      "INOUT !!1 \(value) - \(AddSubValues.smiA) - \(AddSubValues.smiB)",
      file: file,
      line: line
    )
  }

  private func subHeapTest(value: BigInt,
                           file: StaticString = #file,
                           line: UInt = #line) {
    let double = value - AddSubValues.heapA - AddSubValues.heapB
    let single = value - AddSubValues.heapC

    XCTAssertEqual(
      double,
      single,
      "\(value) - \(AddSubValues.heapA) - \(AddSubValues.heapB)",
      file: file,
      line: line
    )

    var inoutDouble = value
    inoutDouble -= AddSubValues.heapA
    inoutDouble -= AddSubValues.heapB

    var inoutSingle = value
    inoutSingle -= AddSubValues.heapC

    XCTAssertEqual(
      double,
      single,
      "INOUT !!1 \(value) - \(AddSubValues.heapA) - \(AddSubValues.heapB)",
      file: file,
      line: line
    )
  }

  // MARK: - Mul

  func test_mul_smiSmi() {
    for smi in self.smiValues {
      let int = self.create(smi)
      self.mulSmiTest(value: int)
    }
  }

  func test_mul_smiHeap() {
    for smi in self.smiValues {
      let int = self.create(smi)
      self.mulHeapTest(value: int)
    }
  }

  func test_mul_heapSmi() {
    for smi in self.heapValues {
      let int = self.create(smi)
      self.mulSmiTest(value: int)
    }
  }

  func test_mul_heapHeap() {
    for p in self.heapValues {
      let int = self.create(p)
      self.mulHeapTest(value: int)
    }
  }

  private enum MulDivValues {

    fileprivate static let smiA = BigInt(2)
    fileprivate static let smiB = BigInt(4)
    /// It is guaranteed that `Self.smiC = Self.smiA * Self.smiB`
    fileprivate static let smiC = Self.smiA * Self.smiB

    fileprivate static let heapA = BigInt(Word(Smi.Storage.max) + 1)
    fileprivate static let heapB = BigInt(Word(Smi.Storage.max) + 2)
    /// It is guaranteed that `Self.heapC = Self.heapA * Self.heapB`
    fileprivate static let heapC = Self.heapA * Self.heapB
  }

  private func mulSmiTest(value: BigInt,
                          file: StaticString = #file,
                          line: UInt = #line) {
    let double = value * MulDivValues.smiA * MulDivValues.smiB
    let single = value * MulDivValues.smiC

    XCTAssertEqual(
      double,
      single,
      "\(value) * \(MulDivValues.smiA) * \(MulDivValues.smiB)",
      file: file,
      line: line
    )

    var inoutDouble = value
    inoutDouble *= MulDivValues.smiA
    inoutDouble *= MulDivValues.smiB

    var inoutSingle = value
    inoutSingle *= MulDivValues.smiC

    XCTAssertEqual(
      double,
      single,
      "INOUT !!1 \(value) * \(MulDivValues.smiA) * \(MulDivValues.smiB)",
      file: file,
      line: line
    )
  }

  private func mulHeapTest(value: BigInt,
                           file: StaticString = #file,
                           line: UInt = #line) {
    let double = value * MulDivValues.heapA * MulDivValues.heapB
    let single = value * MulDivValues.heapC

    XCTAssertEqual(
      double,
      single,
      "\(value) * \(MulDivValues.heapA) * \(MulDivValues.heapB)",
      file: file,
      line: line
    )

    var inoutDouble = value
    inoutDouble *= MulDivValues.heapA
    inoutDouble *= MulDivValues.heapB

    var inoutSingle = value
    inoutSingle *= MulDivValues.heapC

    XCTAssertEqual(
      double,
      single,
      "INOUT !!1 \(value) * \(MulDivValues.heapA) * \(MulDivValues.heapB)",
      file: file,
      line: line
    )
  }

  // MARK: - Div

  func test_div_smiSmi() {
    for smi in self.smiValues {
      let int = self.create(smi)
      self.divSmiTest(value: int)
    }
  }

  func test_div_smiHeap() {
    for smi in self.smiValues {
      let int = self.create(smi)
      self.divHeapTest(value: int)
    }
  }

  func test_div_heapSmi() {
    for smi in self.heapValues {
      let int = self.create(smi)
      self.divSmiTest(value: int)
    }
  }

  func test_div_heapHeap() {
    for p in self.heapValues {
      let int = self.create(p)
      self.divHeapTest(value: int)
    }
  }

  private func divSmiTest(value: BigInt,
                          file: StaticString = #file,
                          line: UInt = #line) {
    let double = value / MulDivValues.smiA / MulDivValues.smiB
    let single = value / MulDivValues.smiC

    XCTAssertEqual(
      double,
      single,
      "\(value) / \(MulDivValues.smiA) / \(MulDivValues.smiB)",
      file: file,
      line: line
    )

    var inoutDouble = value
    inoutDouble /= MulDivValues.smiA
    inoutDouble /= MulDivValues.smiB

    var inoutSingle = value
    inoutSingle /= MulDivValues.smiC

    XCTAssertEqual(
      double,
      single,
      "INOUT !!1 \(value) / \(MulDivValues.smiA) / \(MulDivValues.smiB)",
      file: file,
      line: line
    )
  }

  private func divHeapTest(value: BigInt,
                           file: StaticString = #file,
                           line: UInt = #line) {
    let double = value / MulDivValues.heapA / MulDivValues.heapB
    let single = value / MulDivValues.heapC

    XCTAssertEqual(
      double,
      single,
      "\(value) / \(MulDivValues.heapA) / \(MulDivValues.heapB)",
      file: file,
      line: line
    )

    var inoutDouble = value
    inoutDouble /= MulDivValues.heapA
    inoutDouble /= MulDivValues.heapB

    var inoutSingle = value
    inoutSingle /= MulDivValues.heapC

    XCTAssertEqual(
      double,
      single,
      "INOUT !!1 \(value) / \(MulDivValues.heapA) / \(MulDivValues.heapB)",
      file: file,
      line: line
    )
  }

  // MARK: - Left shift

  func test_shiftLeft_smi() {
    for smi in self.smiValues {
      let int = self.create(smi)
      self.shiftLeftTest(value: int)
    }
  }

  func test_shiftLeft_heap() {
    for smi in self.smiValues {
      let int = self.create(smi)
      self.shiftLeftTest(value: int)
    }
  }

  private enum LeftShiftValues {

    // 7 + Word.bitWidth - 5 = Word.bitWidth + 2

    fileprivate static let a = BigInt(7)
    fileprivate static let b = BigInt(Word.bitWidth - 5)
    /// It is guaranteed that `Self.c = Self.a + Self.b`
    fileprivate static let c = Self.a + Self.b
  }

  private func shiftLeftTest(value: BigInt,
                             file: StaticString = #file,
                             line: UInt = #line) {
    let double = (value << LeftShiftValues.a) << LeftShiftValues.b
    let single = value << LeftShiftValues.c

    XCTAssertEqual(
      double,
      single,
      "(\(value) << \(LeftShiftValues.a)) << \(LeftShiftValues.b)",
      file: file,
      line: line
    )

    var inoutDouble = value
    inoutDouble <<= LeftShiftValues.a
    inoutDouble <<= LeftShiftValues.b

    var inoutSingle = value
    inoutSingle <<= LeftShiftValues.c

    XCTAssertEqual(
      double,
      single,
      "INOUT !!1 (\(value) << \(LeftShiftValues.a)) << \(LeftShiftValues.b)",
      file: file,
      line: line
    )
  }

  // MARK: - Right shift

  func test_shiftRight_smi_belowWord() {
    for smi in self.smiValues {
      let int = self.create(smi)
      self.shiftRightBelowWordTest(value: int)
    }
  }

  func test_shiftRight_heap_belowWord() {
    for smi in self.smiValues {
      let int = self.create(smi)
      self.shiftRightBelowWordTest(value: int)
    }
  }

  func test_shiftRight_smi_overWord() {
    for smi in self.smiValues {
      let int = self.create(smi)
      self.shiftRightOverWordTest(value: int)
    }
  }

  func test_shiftRight_heap_overWord() {
    for smi in self.smiValues {
      let int = self.create(smi)
      self.shiftRightOverWordTest(value: int)
    }
  }

  private enum RightShiftValues {

    fileprivate static let belowWordA = BigInt(2)
    fileprivate static let belowWordB = BigInt(3)
    /// It is guaranteed that `Self.belowWordC = Self.belowWordA + Self.belowWordB`
    fileprivate static let belowWordC = Self.belowWordA + Self.belowWordB

    // 7 + Word.bitWidth - 5 = Word.bitWidth + 2
    // Right shift for more than 'Word.bitWidth' has high probability
    // of shifting value into oblivion (0 or -1).

    fileprivate static let overWordA = BigInt(7)
    fileprivate static let overWordB = BigInt(Word.bitWidth - 5)
    /// It is guaranteed that `Self.overWordC = Self.overWordA + Self.overWordB`
    fileprivate static let overWordC = Self.overWordA + Self.overWordB
  }

  private func shiftRightBelowWordTest(value: BigInt,
                                       file: StaticString = #file,
                                       line: UInt = #line) {
    let double = (value >> RightShiftValues.belowWordA) >> RightShiftValues.belowWordB
    let single = value >> RightShiftValues.belowWordC

    XCTAssertEqual(
      double,
      single,
      "(\(value) >> \(RightShiftValues.belowWordA)) >> \(RightShiftValues.belowWordB)",
      file: file,
      line: line
    )

    var inoutDouble = value
    inoutDouble >>= RightShiftValues.belowWordA
    inoutDouble >>= RightShiftValues.belowWordB

    var inoutSingle = value
    inoutSingle >>= RightShiftValues.belowWordC

    XCTAssertEqual(
      double,
      single,
      "INOUT !!1 (\(value) >> \(RightShiftValues.belowWordA)) >> \(RightShiftValues.belowWordB)",
      file: file,
      line: line
    )
  }

  private func shiftRightOverWordTest(value: BigInt,
                                      file: StaticString = #file,
                                      line: UInt = #line) {
    let double = (value >> RightShiftValues.overWordA) >> RightShiftValues.overWordB
    let single = value >> RightShiftValues.overWordC

    XCTAssertEqual(
      double,
      single,
      "(\(value) >> \(RightShiftValues.overWordA)) >> \(RightShiftValues.overWordB)",
      file: file,
      line: line
    )

    var inoutDouble = value
    inoutDouble >>= RightShiftValues.overWordA
    inoutDouble >>= RightShiftValues.overWordB

    var inoutSingle = value
    inoutSingle >>= RightShiftValues.overWordC

    XCTAssertEqual(
      double,
      single,
      "INOUT !!1 (\(value) >> \(RightShiftValues.overWordA)) >> \(RightShiftValues.overWordB)",
      file: file,
      line: line
    )
  }

  // MARK: - Helpers

  private func create(_ smi: Smi.Storage) -> BigInt {
    return BigInt(smi: smi)
  }

  private func create(_ p: HeapPrototype) -> BigInt {
    let heap = p.create()
    return BigInt(heap)
  }
}
