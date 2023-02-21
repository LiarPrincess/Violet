/// Storage for `BigIntStorage.Word`.
///
/// Use when `BigIntStorage.guaranteeUniqueBufferReference` is too slow.
/// Remember to `deallocate` after.
internal struct TemporaryWordBuffer: Collection {

  internal typealias Element = BigIntStorage.Word
  private typealias BufferPtr = UnsafeMutableBufferPointer<BigIntStorage.Word>

  private let ptr: BufferPtr
  internal private(set) var count: Int

  internal var startIndex: Int { return 0 }
  internal var endIndex: Int { return self.count }

  internal init(capacity: Int) {
    self.ptr = BufferPtr.allocate(capacity: capacity)
    self.count = 0
  }

  internal init(repeating: Element, count: Int) {
    self.ptr = BufferPtr.allocate(capacity: count)
    self.count = count
    self.ptr.assign(repeating: repeating)
  }

  internal subscript(index: Int) -> Element {
    get { return self.ptr[index] }
    set { self.ptr[index] = newValue }
  }

  internal func index(after i: Int) -> Int {
    return i + 1
  }

  internal mutating func append(_ word: Element) {
    self[self.count] = word
    self.count += 1
  }

  internal mutating func fillWith0() {
    self.ptr.assign(repeating: 0)
  }

  internal mutating func removeAll() {
    self.count = 0
  }

  internal func deallocate() {
    self.ptr.deallocate()
  }
}
