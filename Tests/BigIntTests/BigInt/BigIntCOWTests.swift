import XCTest
@testable import BigInt

// swiftlint:disable file_length

private typealias SmiStorage = Smi.Storage
private typealias HeapWord = BigIntHeap.Word

class BigIntCOWTests: XCTestCase {

  // This can't be '1' because 'n *= 1 -> n' (which is one of our test cases)
  private let smiValue = BigInt(2)
  private let heapValue = BigInt(HeapWord.max)
  private let shiftCount = 3

  // MARK: - Plus

  /// This test actually DOES make sense, because, even though 'BigInt' is immutable,
  /// the heap that is points to is not.
  func test_plus_doesNotModifyOriginal() {
    // +smi
    var value = BigInt(SmiStorage.max)
    _ = +value
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // +heap
    value = BigInt(HeapWord.max)
    _ = +value
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  // MARK: - Minus

  /// This test actually DOES make sense, because, even though 'BigInt' is immutable,
  /// the heap that is points to is not.
  func test_minus_doesNotModifyOriginal() {
    // -smi
    var value = BigInt(SmiStorage.max)
    _ = -value
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // -heap
    value = BigInt(HeapWord.max)
    _ = -value
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  // MARK: - Invert

  /// This test actually DOES make sense, because, even though 'BigInt' is immutable,
  /// the heap that is points to is not.
  func test_invert_doesNotModifyOriginal() {
    // ~smi
    var value = BigInt(SmiStorage.max)
    _ = ~value
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // ~heap
    value = BigInt(HeapWord.max)
    _ = ~value
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  // MARK: - Add

  /// This test actually DOES make sense, because, even though 'BigInt' is immutable,
  /// the heap that is points to is not.
  func test_add_toCopy_doesNotModifyOriginal() {
    // smi + smi
    var value = BigInt(SmiStorage.max)
    var copy = value
    _ = copy + self.smiValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // smi + heap
    value = BigInt(SmiStorage.max)
    copy = value
    _ = copy + self.heapValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap + smi
    value = BigInt(HeapWord.max)
    copy = value
    _ = copy + self.smiValue
    XCTAssertEqual(value, BigInt(HeapWord.max))

    // heap + heap
    value = BigInt(HeapWord.max)
    copy = value
    _ = copy + self.heapValue
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  /// This test actually DOES make sense, because, even though 'BigInt' is immutable,
  /// the heap that is points to is not.
  func test_add_toInout_doesNotModifyOriginal() {
    // smi + smi
    var value = BigInt(SmiStorage.max)
    self.addSmi(toInout: &value)
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // smi + heap
    value = BigInt(SmiStorage.max)
    self.addHeap(toInout: &value)
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap + smi
    value = BigInt(HeapWord.max)
    self.addSmi(toInout: &value)
    XCTAssertEqual(value, BigInt(HeapWord.max))

    // heap + heap
    value = BigInt(HeapWord.max)
    self.addHeap(toInout: &value)
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  private func addSmi(toInout value: inout BigInt) {
    _ = value + self.smiValue
  }

  private func addHeap(toInout value: inout BigInt) {
    _ = value + self.heapValue
  }

  func test_addEqual_toCopy_doesNotModifyOriginal() {
    // smi + smi
    var value = BigInt(SmiStorage.max)
    var copy = value
    copy += self.smiValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // smi + heap
    value = BigInt(SmiStorage.max)
    copy = value
    copy += self.heapValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap + smi
    value = BigInt(HeapWord.max)
    copy = value
    copy += self.smiValue
    XCTAssertEqual(value, BigInt(HeapWord.max))

    // heap + heap
    value = BigInt(HeapWord.max)
    copy = value
    copy += self.heapValue
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  func test_addEqual_toInout_doesModifyOriginal() {
    // smi + smi
    var value = BigInt(SmiStorage.max)
    self.addEqualSmi(toInout: &value)
    XCTAssertNotEqual(value, BigInt(SmiStorage.max))

    // smi + heap
    value = BigInt(SmiStorage.max)
    self.addEqualHeap(toInout: &value)
    XCTAssertNotEqual(value, BigInt(SmiStorage.max))

    // heap + smi
    value = BigInt(HeapWord.max)
    self.addEqualSmi(toInout: &value)
    XCTAssertNotEqual(value, BigInt(HeapWord.max))

    // heap + heap
    value = BigInt(HeapWord.max)
    self.addEqualHeap(toInout: &value)
    XCTAssertNotEqual(value, BigInt(HeapWord.max))
  }

  private func addEqualSmi(toInout value: inout BigInt) {
    value += self.smiValue
  }

  private func addEqualHeap(toInout value: inout BigInt) {
    value += self.heapValue
  }

  // MARK: - Sub

  /// This test actually DOES make sense, because, even though 'BigInt' is immutable,
  /// the heap that is points to is not.
  func test_sub_toCopy_doesNotModifyOriginal() {
    // smi - smi
    var value = BigInt(SmiStorage.max)
    var copy = value
    _ = copy - self.smiValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // smi - heap
    value = BigInt(SmiStorage.max)
    copy = value
    _ = copy - self.heapValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap - smi
    value = BigInt(HeapWord.max)
    copy = value
    _ = copy - self.smiValue
    XCTAssertEqual(value, BigInt(HeapWord.max))

    // heap - heap
    value = BigInt(HeapWord.max)
    copy = value
    _ = copy - self.heapValue
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  /// This test actually DOES make sense, because, even though 'BigInt' is immutable,
  /// the heap that is points to is not.
  func test_sub_toInout_doesNotModifyOriginal() {
    // smi - smi
    var value = BigInt(SmiStorage.max)
    self.subSmi(toInout: &value)
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // smi - heap
    value = BigInt(SmiStorage.max)
    self.subHeap(toInout: &value)
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap - smi
    value = BigInt(HeapWord.max)
    self.subSmi(toInout: &value)
    XCTAssertEqual(value, BigInt(HeapWord.max))

    // heap - heap
    value = BigInt(HeapWord.max)
    self.subHeap(toInout: &value)
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  private func subSmi(toInout value: inout BigInt) {
    _ = value - self.smiValue
  }

  private func subHeap(toInout value: inout BigInt) {
    _ = value - self.heapValue
  }

  func test_subEqual_toCopy_doesNotModifyOriginal() {
    // smi - smi
    var value = BigInt(SmiStorage.max)
    var copy = value
    copy -= self.smiValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // smi - heap
    value = BigInt(SmiStorage.max)
    copy = value
    copy -= self.heapValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap - smi
    value = BigInt(HeapWord.max)
    copy = value
    copy -= self.smiValue
    XCTAssertEqual(value, BigInt(HeapWord.max))

    // heap - heap
    value = BigInt(HeapWord.max)
    copy = value
    copy -= self.heapValue
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  func test_subEqual_toInout_doesModifyOriginal() {
    // smi - smi
    var value = BigInt(SmiStorage.max)
    self.subEqualSmi(toInout: &value)
    XCTAssertNotEqual(value, BigInt(SmiStorage.max))

    // smi - heap
    value = BigInt(SmiStorage.max)
    self.subEqualHeap(toInout: &value)
    XCTAssertNotEqual(value, BigInt(SmiStorage.max))

    // heap - smi
    value = BigInt(HeapWord.max)
    self.subEqualSmi(toInout: &value)
    XCTAssertNotEqual(value, BigInt(HeapWord.max))

    // heap - heap
    value = BigInt(HeapWord.max)
    self.subEqualHeap(toInout: &value)
    XCTAssertNotEqual(value, BigInt(HeapWord.max))
  }

  private func subEqualSmi(toInout value: inout BigInt) {
    value -= self.smiValue
  }

  private func subEqualHeap(toInout value: inout BigInt) {
    value -= self.heapValue
  }

  // MARK: - Mul

  /// This test actually DOES make sense, because, even though 'BigInt' is immutable,
  /// the heap that is points to is not.
  func test_mul_toCopy_doesNotModifyOriginal() {
    // smi * smi
    var value = BigInt(SmiStorage.max)
    var copy = value
    _ = copy * self.smiValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // smi * heap
    value = BigInt(SmiStorage.max)
    copy = value
    _ = copy * self.heapValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap * smi
    value = BigInt(HeapWord.max)
    copy = value
    _ = copy * self.smiValue
    XCTAssertEqual(value, BigInt(HeapWord.max))

    // heap * heap
    value = BigInt(HeapWord.max)
    copy = value
    _ = copy * self.heapValue
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  /// This test actually DOES make sense, because, even though 'BigInt' is immutable,
  /// the heap that is points to is not.
  func test_mul_toInout_doesNotModifyOriginal() {
    // smi * smi
    var value = BigInt(SmiStorage.max)
    self.mulSmi(toInout: &value)
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // smi * heap
    value = BigInt(SmiStorage.max)
    self.mulHeap(toInout: &value)
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap * smi
    value = BigInt(HeapWord.max)
    self.mulSmi(toInout: &value)
    XCTAssertEqual(value, BigInt(HeapWord.max))

    // heap * heap
    value = BigInt(HeapWord.max)
    self.mulHeap(toInout: &value)
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  private func mulSmi(toInout value: inout BigInt) {
    _ = value * self.smiValue
  }

  private func mulHeap(toInout value: inout BigInt) {
    _ = value * self.heapValue
  }

  func test_mulEqual_toCopy_doesNotModifyOriginal() {
    // smi * smi
    var value = BigInt(SmiStorage.max)
    var copy = value
    copy *= self.smiValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // smi * heap
    value = BigInt(SmiStorage.max)
    copy = value
    copy *= self.heapValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap * smi
    value = BigInt(HeapWord.max)
    copy = value
    copy *= self.smiValue
    XCTAssertEqual(value, BigInt(HeapWord.max))

    // heap * heap
    value = BigInt(HeapWord.max)
    copy = value
    copy *= self.heapValue
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  func test_mulEqual_toInout_doesModifyOriginal() {
    // smi * smi
    var value = BigInt(SmiStorage.max)
    self.mulEqualSmi(toInout: &value)
    XCTAssertNotEqual(value, BigInt(SmiStorage.max))

    // smi * heap
    value = BigInt(SmiStorage.max)
    self.mulEqualHeap(toInout: &value)
    XCTAssertNotEqual(value, BigInt(SmiStorage.max))

    // heap * smi
    value = BigInt(HeapWord.max)
    self.mulEqualSmi(toInout: &value)
    XCTAssertNotEqual(value, BigInt(HeapWord.max))

    // heap * heap
    value = BigInt(HeapWord.max)
    self.mulEqualHeap(toInout: &value)
    XCTAssertNotEqual(value, BigInt(HeapWord.max))
  }

  private func mulEqualSmi(toInout value: inout BigInt) {
    value *= self.smiValue
  }

  private func mulEqualHeap(toInout value: inout BigInt) {
    value *= self.heapValue
  }

  // MARK: - Div

  /// This test actually DOES make sense, because, even though 'BigInt' is immutable,
  /// the heap that is points to is not.
  func test_div_toCopy_doesNotModifyOriginal() {
    // smi / smi
    var value = BigInt(SmiStorage.max)
    var copy = value
    _ = copy / self.smiValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // smi / heap
    value = BigInt(SmiStorage.max)
    copy = value
    _ = copy / self.heapValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap / smi
    value = BigInt(HeapWord.max)
    copy = value
    _ = copy / self.smiValue
    XCTAssertEqual(value, BigInt(HeapWord.max))

    // heap / heap
    value = BigInt(HeapWord.max)
    copy = value
    _ = copy / self.heapValue
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  /// This test actually DOES make sense, because, even though 'BigInt' is immutable,
  /// the heap that is points to is not.
  func test_div_toInout_doesNotModifyOriginal() {
    // smi / smi
    var value = BigInt(SmiStorage.max)
    self.divSmi(toInout: &value)
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // smi / heap
    value = BigInt(SmiStorage.max)
    self.divHeap(toInout: &value)
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap / smi
    value = BigInt(HeapWord.max)
    self.divSmi(toInout: &value)
    XCTAssertEqual(value, BigInt(HeapWord.max))

    // heap / heap
    value = BigInt(HeapWord.max)
    self.divHeap(toInout: &value)
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  private func divSmi(toInout value: inout BigInt) {
    _ = value / self.smiValue
  }

  private func divHeap(toInout value: inout BigInt) {
    _ = value / self.heapValue
  }

  func test_divEqual_toCopy_doesNotModifyOriginal() {
    // smi / smi
    var value = BigInt(SmiStorage.max)
    var copy = value
    copy /= self.smiValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // smi / heap
    value = BigInt(SmiStorage.max)
    copy = value
    copy /= self.heapValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap / smi
    value = BigInt(HeapWord.max)
    copy = value
    copy /= self.smiValue
    XCTAssertEqual(value, BigInt(HeapWord.max))

    // heap / heap
    value = BigInt(HeapWord.max)
    copy = value
    copy /= self.heapValue
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  func test_divEqual_toInout_doesModifyOriginal() {
    // smi / smi
    var value = BigInt(SmiStorage.max)
    self.divEqualSmi(toInout: &value)
    XCTAssertNotEqual(value, BigInt(SmiStorage.max))

    // smi / heap
    value = BigInt(SmiStorage.max)
    self.divEqualHeap(toInout: &value)
    XCTAssertNotEqual(value, BigInt(SmiStorage.max))

    // heap / smi
    value = BigInt(HeapWord.max)
    self.divEqualSmi(toInout: &value)
    XCTAssertNotEqual(value, BigInt(HeapWord.max))

    // heap / heap
    value = BigInt(HeapWord.max)
    self.divEqualHeap(toInout: &value)
    XCTAssertNotEqual(value, BigInt(HeapWord.max))
  }

  private func divEqualSmi(toInout value: inout BigInt) {
    value /= self.smiValue
  }

  private func divEqualHeap(toInout value: inout BigInt) {
    value /= self.heapValue
  }

  // MARK: - Mod

  /// This test actually DOES make sense, because, even though 'BigInt' is immutable,
  /// the heap that is points to is not.
  func test_mod_toCopy_doesNotModifyOriginal() {
    // smi % smi
    var value = BigInt(SmiStorage.max)
    var copy = value
    _ = copy % self.smiValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // smi % heap
    value = BigInt(SmiStorage.max)
    copy = value
    _ = copy % self.heapValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap % smi
    value = BigInt(HeapWord.max)
    copy = value
    _ = copy % self.smiValue
    XCTAssertEqual(value, BigInt(HeapWord.max))

    // heap % heap
    value = BigInt(HeapWord.max)
    copy = value
    _ = copy % self.heapValue
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  /// This test actually DOES make sense, because, even though 'BigInt' is immutable,
  /// the heap that is points to is not.
  func test_mod_toInout_doesNotModifyOriginal() {
    // smi % smi
    var value = BigInt(SmiStorage.max)
    self.modSmi(toInout: &value)
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // smi % heap
    value = BigInt(SmiStorage.max)
    self.modHeap(toInout: &value)
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap % smi
    value = BigInt(HeapWord.max)
    self.modSmi(toInout: &value)
    XCTAssertEqual(value, BigInt(HeapWord.max))

    // heap % heap
    value = BigInt(HeapWord.max)
    self.modHeap(toInout: &value)
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  private func modSmi(toInout value: inout BigInt) {
    _ = value % self.smiValue
  }

  private func modHeap(toInout value: inout BigInt) {
    _ = value % self.heapValue
  }

  func test_modEqual_toCopy_doesNotModifyOriginal() {
    // smi % smi
    var value = BigInt(SmiStorage.max)
    var copy = value
    copy %= self.smiValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // smi % heap
    value = BigInt(SmiStorage.max)
    copy = value
    copy %= self.heapValue
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap % smi
    value = BigInt(HeapWord.max)
    copy = value
    copy %= self.smiValue
    XCTAssertEqual(value, BigInt(HeapWord.max))

    // heap % heap
    value = BigInt(HeapWord.max)
    copy = value
    copy %= self.heapValue
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  func test_modEqual_toInout_doesModifyOriginal() {
    // smi % smi
    var value = BigInt(SmiStorage.max)
    self.modEqualSmi(toInout: &value)
    XCTAssertNotEqual(value, BigInt(SmiStorage.max))

    // smi % heap
    // 'heap' is always greater than 'smi', so modulo is actually equal to 'smi'
//    value = BigInt(SmiStorage.max)
//    self.modEqualHeap(toInout: &value)
//    XCTAssertNotEqual(value, BigInt(SmiStorage.max))

    // heap % smi
    value = BigInt(HeapWord.max)
    self.modEqualSmi(toInout: &value)
    XCTAssertNotEqual(value, BigInt(HeapWord.max))

    // heap % heap
    value = BigInt(HeapWord.max)
    self.modEqualHeap(toInout: &value)
    XCTAssertNotEqual(value, BigInt(HeapWord.max))
  }

  private func modEqualSmi(toInout value: inout BigInt) {
    value %= self.smiValue
  }

  private func modEqualHeap(toInout value: inout BigInt) {
    value %= self.heapValue
  }

  // MARK: - Shift left

  /// This test actually DOES make sense, because, even though 'BigInt' is immutable,
  /// the heap that is points to is not.
  func test_shiftLeft_copy_doesNotModifyOriginal() {
    // smi << int
    var value = BigInt(SmiStorage.max)
    var copy = value
    _ = copy << self.shiftCount
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap << int
    value = BigInt(HeapWord.max)
    copy = value
    _ = copy << self.shiftCount
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  /// This test actually DOES make sense, because, even though 'BigInt' is immutable,
  /// the heap that is points to is not.
  func test_shiftLeft_inout_doesNotModifyOriginal() {
    // smi << int
    var value = BigInt(SmiStorage.max)
    self.shiftLeft(value: &value)
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap << int
    value = BigInt(HeapWord.max)
    self.shiftLeft(value: &value)
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  private func shiftLeft(value: inout BigInt) {
    _ = value << self.shiftCount
  }

  func test_shiftLeftEqual_copy_doesNotModifyOriginal() {
    // smi << int
    var value = BigInt(SmiStorage.max)
    var copy = value
    copy <<= self.shiftCount
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap << int
    value = BigInt(HeapWord.max)
    copy = value
    copy <<= self.shiftCount
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  func test_shiftLeftEqual_inout_doesModifyOriginal() {
    // smi << int
    var value = BigInt(SmiStorage.max)
    self.shiftLeftEqual(value: &value)
    XCTAssertNotEqual(value, BigInt(SmiStorage.max))

    // heap << int
    value = BigInt(HeapWord.max)
    self.shiftLeftEqual(value: &value)
    XCTAssertNotEqual(value, BigInt(HeapWord.max))
  }

  private func shiftLeftEqual(value: inout BigInt) {
    value <<= self.shiftCount
  }

  // MARK: - Shift right

  /// This test actually DOES make sense, because, even though 'BigInt' is immutable,
  /// the heap that is points to is not.
  func test_shiftRight_copy_doesNotModifyOriginal() {
    // smi >> int
    var value = BigInt(SmiStorage.max)
    var copy = value
    _ = copy >> self.shiftCount
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap >> int
    value = BigInt(HeapWord.max)
    copy = value
    _ = copy >> self.shiftCount
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  /// This test actually DOES make sense, because, even though 'BigInt' is immutable,
  /// the heap that is points to is not.
  func test_shiftRight_inout_doesNotModifyOriginal() {
    // smi >> int
    var value = BigInt(SmiStorage.max)
    self.shiftRight(value: &value)
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap >> int
    value = BigInt(HeapWord.max)
    self.shiftRight(value: &value)
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  private func shiftRight(value: inout BigInt) {
    _ = value >> self.shiftCount
  }

  func test_shiftRightEqual_copy_doesNotModifyOriginal() {
    // smi >> int
    var value = BigInt(SmiStorage.max)
    var copy = value
    copy >>= self.shiftCount
    XCTAssertEqual(value, BigInt(SmiStorage.max))

    // heap >> int
    value = BigInt(HeapWord.max)
    copy = value
    copy >>= self.shiftCount
    XCTAssertEqual(value, BigInt(HeapWord.max))
  }

  func test_shiftRightEqual_inout_doesModifyOriginal() {
    // smi >> int
    var value = BigInt(SmiStorage.max)
    self.shiftRightEqual(value: &value)
    XCTAssertNotEqual(value, BigInt(SmiStorage.max))

    // heap >> int
    value = BigInt(HeapWord.max)
    self.shiftRightEqual(value: &value)
    XCTAssertNotEqual(value, BigInt(HeapWord.max))
  }

  private func shiftRightEqual(value: inout BigInt) {
    value >>= self.shiftCount
  }
}
