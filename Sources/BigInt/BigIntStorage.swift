import Foundation

// swiftlint:disable empty_count
// swiftlint:disable file_length

/// Basically a `Word` collection with a sign.
///
/// Least significant word is at index `0`.
/// It has no trailing zero elements.
/// If `self.isZero`, then `isNegative == false` and `self.isEmpty == true`.
///
/// This is only 'storage', it does not have any 'BigInt' related logic.
///
/// # Important 1
/// All of the mutating functions have to call
/// `guaranteeUniqueBufferReference` first.
///
/// # Important 2
/// We do not give any guarantees about the words after `self.count`.
/// They may be `0` or they may be garbage.
internal struct BigIntStorage: CustomStringConvertible {

  // MARK: - Helper types

  internal typealias Word = UInt
  private typealias Count = UInt32
  private typealias Capacity = UInt32
  private typealias Buffer = ManagedBufferPointer<Header, Word>

  // Order and types of those fields matter for performance!
  private struct Header {
    /// We will allow setting 'isNegative' when the value is '0', just assume that
    /// user know what they are doing. It is useful when they decide to set sign
    /// first and then magnitude.
    fileprivate var isNegative: Bool
    fileprivate var count: Count
    fileprivate var capacity: Capacity
  }

  // MARK: - Predefined values

  /// Value to be used when we are `0`.
  ///
  /// Use this to avoid allocating new empty buffer every time.
  internal static var zero = BigIntStorage(minimumCapacity: 0)

  // MARK: - Properties

  private var buffer: Buffer

  internal var isZero: Bool {
    return self.count == 0
  }

  internal var isNegative: Bool {
    return self.buffer.header.isNegative
  }

  internal mutating func setIsNegative(_ token: UniqueBufferToken, value: Bool) {
    self.validateToken(token)
    self.unsafeSetIsNegativeWithoutToken(value: value)
  }

  /// Use this if you are sure that we have a unique ownership.
  private mutating func unsafeSetIsNegativeWithoutToken(value: Bool) {
    // We will allow setting 'isNegative' when the value is '0',
    // just assume that user know what they are doing.
    self.buffer.header.isNegative = value
  }

  internal mutating func toggleIsNegative(_ token: UniqueBufferToken) {
    let current = self.isNegative
    self.setIsNegative(token, value: !current)
  }

  /// `0` is also positive.
  internal var isPositive: Bool {
    return !self.isNegative
  }

  internal var count: Int {
    return Int(self.buffer.header.count)
  }

  internal mutating func setCount(_ token: UniqueBufferToken, value: Int) {
    self.validateToken(token)
    self.unsafeSetCountWithoutToken(value: value)
  }

  /// Use this if you are sure that we have a unique ownership.
  private mutating func unsafeSetCountWithoutToken(value: Int) {
    assert(value >= 0)
    self.buffer.header.count = Count(value)
  }

  internal var capacity: Int {
    return Int(self.buffer.header.capacity)
  }

  // MARK: - Init

  /// Init with the value of `0` and specified capacity.
  internal init(minimumCapacity: Int) {
    self.buffer = Self.createBuffer(
      isNegative: false,
      count: 0,
      minimumCapacity: minimumCapacity
    )
  }

  /// Init positive value with magnitude filled with `repeatedValue`.
  internal init(repeating repeatedValue: Word, count: Int) {
    self.init(minimumCapacity: count)
    Self.memset(dst: self.buffer, value: repeatedValue, count: count)
    self.unsafeSetCountWithoutToken(value: count)
  }

  internal init(isNegative: Bool, magnitude: Word) {
    if magnitude == 0 {
      self = Self.zero
    } else {
      self.init(minimumCapacity: 1)
      self.unsafeSetIsNegativeWithoutToken(value: isNegative)
      self.unsafeSetCountWithoutToken(value: 1)

      self.buffer.withUnsafeMutablePointerToElements { ptr in
        ptr[0] = magnitude
      }
    }
  }

  // MARK: - Create buffer

  /// `ManagedBufferPointer` will call our `deinit`.
  /// This is basically kind of memory overlay thingie.
  private class LetItGo {
    // Let it go, let it go
    // Can't hold it back anymore
    // Let it go, let it go
    // Turn away and slam the door
    //
    // I don't care
    // What they're going to say
    // Let the storm rage on
    // The cold never bothered me anyway
  }

  /// IMPORTANT: Created buffer will contain uninitialized memory!
  private static func createBuffer(
    isNegative: Bool,
    count: Int,
    minimumCapacity capacity: Int
  ) -> Buffer {
    assert(count >= 0)

    let _count = Count(count)
    let _capacity = Capacity(capacity)

    // swiftlint:disable:next trailing_closure
    var result = Buffer(
      bufferClass: LetItGo.self,
      minimumCapacity: capacity,
      makingHeaderWith: { _, _ in
        Header(isNegative: isNegative, count: _count, capacity: _capacity)
      }
    )

    // Replace 'header.capacity' with an actual malloc size which may be greater
    // than the requested minimumCapacity.
    result.header.capacity = Capacity(result.capacity)
    return result
  }

  // MARK: - Word access

  /// Read only access to buffer.
  internal func withWordsBuffer<R>(_ fn: (UnsafeBufferPointer<Word>) -> R) -> R {
    return self.buffer.withUnsafeMutablePointerToElements { ptr in
      let bufferPtr = UnsafeBufferPointer(start: ptr, count: self.count)
      return fn(bufferPtr)
    }
  }

  /// Mutable access to buffer.
  ///
  /// Do NOT call any of the potentially reallocating methods (`append` etc.)
  /// in the closure! They will invalidate the buffer pointer.
  internal func withMutableWordsBuffer<R>(
    _ token: UniqueBufferToken,
    _ fn: (UnsafeMutableBufferPointer<Word>) -> R
  ) -> R {
    return self.buffer.withUnsafeMutablePointerToElements { ptr in
      let bufferPtr = UnsafeMutableBufferPointer(start: ptr, count: self.count)
      return fn(bufferPtr)
    }
  }

  @available(*, deprecated, message: "Use 'with[Mutable]WordsBuffer' instead")
  internal subscript(index: Int) -> Word {
    return self.buffer.withUnsafeMutablePointerToElements { ptr in
      ptr.advanced(by: index).pointee
    }
  }

  // MARK: - Append/prepend

  /// Add given `Word` to the buffer.
  internal mutating func appendWithPossibleGrow(
    _ token: UniqueBufferToken,
    element: Word
  ) {
    self.reserveCapacity(token, capacity: self.count + 1) // Will  validate token
    self.unsafeAppendWithoutToken(element: element)
  }

  /// Add given `Word` to the buffer.
  ///
  /// Caller is responsible for ensuring that the buffer can hold the result
  /// (use `guaranteeUniqueBufferReference(withCapacity:)`).
  internal mutating func appendAssumingCapacity(
    _ token: UniqueBufferToken,
    element: Word
  ) {
    self.validateToken(token)
    self.assertCapacity(newCount: self.count + 1)
    self.unsafeAppendWithoutToken(element: element)
  }

  private mutating func unsafeAppendWithoutToken(element: Word) {
    let oldCount = self.count
    let newCount = oldCount + 1

    self.buffer.withUnsafeMutablePointerToElements { ptr in
      ptr.advanced(by: oldCount).pointee = element
    }

    self.unsafeSetCountWithoutToken(value: newCount)
  }

  /// Add given `Word`  at the start of the buffer specified number of times.
  ///
  /// Caller is responsible for ensuring that the buffer can hold the result
  /// (use `guaranteeUniqueBufferReference(withCapacity:)`).
  internal mutating func prependAssumingCapacity(
    _ token: UniqueBufferToken,
    element: Word,
    count: Int
  ) {
    assert(count >= 0)

    if count != 0 {
      let oldCount = self.count
      let newCount = oldCount + count

      self.validateToken(token)
      self.assertCapacity(newCount: newCount)

      self.buffer.withUnsafeMutablePointerToElements { startPtr in
        // Move current words back
        let targetPtr = startPtr.advanced(by: count)
        targetPtr.assign(from: startPtr, count: oldCount)

        // Set prefix words to given 'element'
        startPtr.assign(repeating: element, count: count)
      }

      self.unsafeSetCountWithoutToken(value: newCount)
    }
  }

  private func assertCapacity(newCount: Int) {
#if DEBUG
    assert(
      self.capacity >= newCount,
      "Not enough capacity, " +
      "please call 'guaranteeUniqueBufferReference(withCapacity:)' first."
    )
#endif
  }

  // MARK: - Drop first

  /// Remove first `k` elements.
  internal mutating func dropFirst(_ token: UniqueBufferToken, wordCount count: Int) {
    assert(count >= 0)

    if count == 0 {
      return
    }

    let oldCount = self.count

    if count >= oldCount {
      self.removeAll(token) // Will validate token
      return
    }

    let newCount = oldCount - count
    assert(newCount > 0) // We checked 'count >= self.count'
    self.validateToken(token)

    self.buffer.withUnsafeMutablePointerToElements { startPtr in
      // Copy 'newCount' elements to front
      let copySrcPtr = startPtr.advanced(by: count)
      startPtr.assign(from: copySrcPtr, count: newCount)
    }

    self.unsafeSetCountWithoutToken(value: newCount)
  }

  // MARK: - Reserve capacity

  private mutating func reserveCapacity(_ token: UniqueBufferToken, capacity: Int) {
    self.validateToken(token)
    assert(capacity > 0)

    let oldCapacity = self.capacity

    if oldCapacity < capacity {
      let new = Self.createBuffer(
        isNegative: self.isNegative,
        count: self.count,
        minimumCapacity: capacity
      )

      Self.memcpy(dst: new, src: self.buffer, count: self.count)
      self.buffer = new
    }
  }

  // MARK: - Remove/replace all

  internal mutating func removeAll(_ token: UniqueBufferToken) {
    self.setCount(token, value: 0) // Will validate token.
  }

  /// Replace all of the `Word`s with the contents of the buffer.
  ///
  /// Caller is responsible for ensuring that the buffer can hold the result
  /// (use `guaranteeUniqueBufferReference(withCapacity:)`).
  internal mutating func replaceAllAssumingCapacity(
    _ token: UniqueBufferToken,
    withContentsOf other: UnsafeBufferPointer<Word>
  ) {
    // From docs:
    // If the baseAddress of this buffer is nil, the count is zero.
    // However, a buffer can have a count of zero even with a non-nil base address.
    guard let otherPtr = other.baseAddress else {
      self.setToZero()
      return
    }

    let newCount = other.count
    if newCount == 0 {
      self.setToZero()
      return
    }

    self.validateToken(token)
    self.assertCapacity(newCount: newCount)

    self.buffer.withUnsafeMutablePointerToElements { ptr in
      ptr.assign(from: otherPtr, count: other.count)
    }

    self.unsafeSetCountWithoutToken(value: newCount)
  }

  // MARK: - Set

  /// Invalidates tokens.
  internal mutating func setToZero() {
    self = Self.zero
    assert(self.isPositive)
    assert(self.count == 0)
  }

  /// Set `self` to represent given `UInt`.
  ///
  /// May REALLOCATE BUFFER -> invalidates tokens.
  ///
  /// Caller is responsible for ensuring that the buffer can hold the result
  /// (use `guaranteeUniqueBufferReference(withCapacity:)`).
  internal mutating func setToAssumingCapacity(_ token: UniqueBufferToken, value: UInt) {
    if value == 0 {
      self.setToZero()
    } else {
      let newCount = 1
      self.validateToken(token)
      self.assertCapacity(newCount: newCount)

      self.unsafeSetIsNegativeWithoutToken(value: false)
      self.buffer.withUnsafeMutablePointerToElements { $0[0] = value }
      self.unsafeSetCountWithoutToken(value: newCount)
    }
  }

  /// Set `self` to represent given `Int`.
  ///
  /// May REALLOCATE BUFFER -> invalidates tokens.
  ///
  /// Caller is responsible for ensuring that the buffer can hold the result
  /// (use `guaranteeUniqueBufferReference(withCapacity:)`).
  internal mutating func setToAssumingCapacity(_ token: UniqueBufferToken, value: Int) {
    if value == 0 {
      self.setToZero()
    } else {
      let newCount = 1
      self.validateToken(token)
      self.assertCapacity(newCount: newCount)

      self.unsafeSetIsNegativeWithoutToken(value: value.isNegative)
      self.buffer.withUnsafeMutablePointerToElements { $0[0] = value.magnitude }
      self.unsafeSetCountWithoutToken(value: newCount)
    }
  }

  // MARK: - String

  internal var description: String {
    var result = "BigIntStorage(isNegative: \(self.isNegative), words: ["

    self.withWordsBuffer { words in
      for (index, word) in words.enumerated() {
        result.append("0b")
        result.append(String(word, radix: 2, uppercase: false))

        let isLast = index == self.count - 1
        if !isLast {
          result.append(", ")
        }
      }
    }

    result.append("])")
    return result
  }

  // MARK: - Invariants

  internal mutating func fixInvariants(_ token: UniqueBufferToken) {
    self.validateToken(token)

    // Trim suffix zeros
    self.buffer.withUnsafeMutablePointerToElements { ptr in
      while self.count > 0 && ptr[self.count - 1] == 0 {
        let newCount = self.count - 1
        self.unsafeSetCountWithoutToken(value: newCount)
      }
    }

    // Zero is always positive
    if self.isZero {
      self.unsafeSetIsNegativeWithoutToken(value: false)
    }
  }

  internal func checkInvariants() {
#if DEBUG
    if self.isZero {
      assert(!self.isNegative, "Negative zero")
    } else {
      self.buffer.withUnsafeMutablePointerToElements { ptr in
        let last = ptr[self.count - 1]
        assert(last != 0, "Zero prefix in BigInt")
      }
    }
#endif
  }

  // MARK: - Unique

  /// Token confirming exclusive access to buffer.
  ///
  /// All of the `mutating` methods will require token as a proof of buffer ownership.
  ///
  /// This type should be `move-only`, but Swift does not support it yet:
  /// - borrow for word change - `withMutableWordsBuffer`
  /// - consume for buffer relocation - `append`; return new token
  /// - consume for `setToZero`; does not return new token (shared value)
  internal struct UniqueBufferToken {
    fileprivate init() {}
  }

  internal mutating func guaranteeUniqueBufferReference() -> UniqueBufferToken {
    if self.buffer.isUniqueReference() {
      return UniqueBufferToken()
    }

    let new = Self.createBuffer(
      isNegative: self.isNegative,
      count: self.count,
      minimumCapacity: self.count
    )

    Self.memcpy(dst: new, src: self.buffer, count: self.count)
    self.buffer = new
    return UniqueBufferToken()
  }

  internal mutating func guaranteeUniqueBufferReference(
    withCapacity capacity: Int
  ) -> UniqueBufferToken {
    assert(capacity > 0)

    let oldCapacity = self.capacity

    if oldCapacity >= capacity && self.buffer.isUniqueReference() {
      return UniqueBufferToken()
    }

    let oldCount = self.count

    let new = Self.createBuffer(
      isNegative: self.isNegative,
      count: oldCount,
      minimumCapacity: Swift.max(oldCount, capacity)
    )

    Self.memcpy(dst: new, src: self.buffer, count: oldCount)
    self.buffer = new
    return UniqueBufferToken()
  }

  private mutating func validateToken(_ token: UniqueBufferToken) {
#if DEBUG
    assert(self.buffer.isUniqueReference())
#endif
  }

  private static func memcpy(dst: Buffer, src: Buffer, count: Int) {
    src.withUnsafeMutablePointerToElements { srcPtr in
      dst.withUnsafeMutablePointerToElements { dstPtr in
        dstPtr.assign(from: srcPtr, count: count)
      }
    }
  }

  private static func memset(dst: Buffer, value: Word, count: Int) {
    dst.withUnsafeMutablePointerToElements { dstPtr in
      dstPtr.assign(repeating: value, count: count)
    }
  }
}
