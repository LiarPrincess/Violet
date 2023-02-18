import Foundation

// swiftlint:disable nesting
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
internal struct BigIntStorage: Equatable, CustomStringConvertible {

  // MARK: - Helper types

  private struct Header {

    fileprivate typealias Storage = UInt
    fileprivate static let signMask = Storage(1) << (Storage.bitWidth - 1)
    fileprivate static let countMask = ~Self.signMask

    /// We store both sign and count in a single field.
    ///
    /// `Sign` is stored in most significant bit:
    /// - 0 for positive numbers
    /// - 1 for negative numbers
    ///
    /// Other bits represent `count`.
    ///
    /// We could use use negative numbers for negative sign,
    /// but then we would not be able to represent `-0`.
    /// `-0` could be useful when the user decides to set sign first
    /// and then magnitude. If the current value is `0` then even though user
    /// would set `sign` to negative `Swift` would still treat it as positive (`+0`).
    fileprivate var signAndCount: Storage

    fileprivate init(isNegative: Bool, count: Int) {
      assert(count >= 0)
      let sign = isNegative ? Self.signMask : 0
      self.signAndCount = sign | Storage(count)
    }
  }

  internal typealias Word = UInt
  private typealias Buffer = ManagedBufferPointer<Header, Word>

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
    let signAndCount = self.buffer.header.signAndCount
    return (signAndCount & Header.signMask) == Header.signMask
  }

  internal mutating func setIsNegative(_ token: UniqueBufferToken, value: Bool) {
    self.validateToken(token)
    self.unsafeSetIsNegativeWithoutToken(value: value)
  }

  /// Use this if you are sure that we have a unique ownership.
  private mutating func unsafeSetIsNegativeWithoutToken(value: Bool) {
    // We will allow setting 'isNegative' when the value is '0',
    // just assume that user know what they are doing.
    let sign = value ? Header.signMask : 0
    let count = self.buffer.header.signAndCount & Header.countMask
    self.buffer.header.signAndCount = sign | count
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
    let signAndCount = self.buffer.header.signAndCount
    return Int(signAndCount & Header.countMask)
  }

  private mutating func setCount(_ token: UniqueBufferToken, value: Int) {
    self.validateToken(token)
    self.unsafeSetCountWithoutToken(value: value)
  }

  /// Use this if you are sure that we have a unique ownership.
  private mutating func unsafeSetCountWithoutToken(value: Int) {
    assert(value >= 0)
    let sign = self.buffer.header.signAndCount & Header.signMask
    let count = Header.Storage(value)
    self.buffer.header.signAndCount = sign | count
  }

  internal var capacity: Int {
    return self.buffer.capacity
  }

  // MARK: - Init

  /// Init with the value of `0` and specified capacity.
  internal init(minimumCapacity: Int) {
    self.buffer = Self.createBuffer(
      header: Header(isNegative: false, count: 0),
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

    private var buffer: Buffer {
      return Buffer(unsafeBufferObject: self)
    }

    deinit {
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
  }

  /// IMPORTANT: Created buffer will contain uninitialized memory!
  private static func createBuffer(header: Header, minimumCapacity: Int) -> Buffer {
    // swiftlint:disable:next trailing_closure
    return Buffer(
      bufferClass: LetItGo.self,
      minimumCapacity: minimumCapacity,
      makingHeaderWith: { _, _ in header }
    )
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

  // MARK: - Append

  /// Add given `Word` to the buffer.
  internal mutating func append(_ token: UniqueBufferToken, element: Word) {
    let oldCount = self.count
    let newCount = oldCount + 1
    self.reserveCapacity(token, capacity: newCount) // Will  validate token

    self.buffer.withUnsafeMutablePointerToElements { ptr in
      ptr.advanced(by: oldCount).pointee = element
    }

    self.unsafeSetCountWithoutToken(value: newCount)
  }

  /// Add all of the `Word`s from given collection to the buffer.
  internal mutating func append(
    _ token: UniqueBufferToken,
    contentsOf other: UnsafeBufferPointer<Word>
  ) {
    // From docs:
    // If the `baseAddress` of this buffer is `nil`, the count is zero. However,
    // a buffer can have a `count` of zero even with a non-`nil` base address.
    guard let otherPtr = other.baseAddress else {
      return
    }

    let oldCount = self.count
    let newCount = oldCount + other.count
    self.reserveCapacity(token, capacity: newCount) // Will  validate token

    self.buffer.withUnsafeMutablePointerToElements { startPtr in
      let ptr = startPtr.advanced(by: oldCount)
      ptr.assign(from: otherPtr, count: other.count)
    }

    self.unsafeSetCountWithoutToken(value: newCount)
  }

  // MARK: - Prepend

  /// Add given `Word`  at the start of the buffer specified number of times.
  internal mutating func prepend(
    _ token: UniqueBufferToken,
    element: Word,
    count: Int
  ) {
    assert(count >= 0)

    if count.isZero {
      return
    }

    let oldCount = self.count
    let newCount = oldCount + count

    if self.capacity >= newCount {
      // Our current buffer is big enough to do the whole operation,
      // no new allocation is needed.
      self.validateToken(token)

      self.buffer.withUnsafeMutablePointerToElements { startPtr in
        // Move current words back
        let targetPtr = startPtr.advanced(by: count)
        targetPtr.assign(from: startPtr, count: oldCount)

        // Set prefix words to given 'element'
        startPtr.assign(repeating: element, count: count)
      }

      self.unsafeSetCountWithoutToken(value: newCount)
      return
    }

    // We do not have to call 'guaranteeUniqueBufferReference',
    // because we will be allocating new buffer (which is trivially unique).

    let new = Self.createBuffer(
      header: Header(isNegative: self.isNegative, count: newCount),
      minimumCapacity: newCount
    )

    self.buffer.withUnsafeMutablePointerToElements { selfStartPtr in
      new.withUnsafeMutablePointerToElements { newStartPtr in
        // Move current words at the correct (shifted) place
        let targetPtr = newStartPtr.advanced(by: count)
        targetPtr.assign(from: selfStartPtr, count: oldCount)

        // Set prefix words to given 'element'.
        // We have to do this even if 'element = 0',
        // because new buffer contains garbage.
        newStartPtr.assign(repeating: element, count: count)
      }
    }

    self.buffer = new
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

  internal mutating func reserveCapacity(_ token: UniqueBufferToken, capacity: Int) {
    self.validateToken(token)
    assert(capacity > 0)

    let oldCapacity = self.capacity

    if oldCapacity < capacity {
      let new = Self.createBuffer(
        header: self.buffer.header,
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
  internal mutating func replaceAll(
    _ token: UniqueBufferToken,
    withContentsOf other: UnsafeMutableBufferPointer<Word>
  ) {
    // From docs:
    // If the baseAddress of this buffer is nil, the count is zero.
    // However, a buffer can have a count of zero even with a non-nil base address.
    guard let otherPtr = other.baseAddress else {
      return
    }

    let newCount = other.count
    self.reserveCapacity(token, capacity: newCount) // Will validate token.

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
  }

  /// Set `self` to represent given `UInt`.
  ///
  /// May REALLOCATE BUFFER -> invalidates tokens.
  internal mutating func setTo(_ token: UniqueBufferToken, value: UInt) {
    if value == 0 {
      self.setToZero()
    } else {
      self.removeAll(token) // Will validate token.
      self.setIsNegative(token, value: false)
      self.append(token, element: value)
    }
  }

  /// Set `self` to represent given `Int`.
  ///
  /// May REALLOCATE BUFFER -> invalidates tokens.
  internal mutating func setTo(_ token: UniqueBufferToken, value: Int) {
    if value == 0 {
      self.setToZero()
    } else {
      self.removeAll(token) // Will validate token.
      self.setIsNegative(token, value: value.isNegative)
      self.append(token, element: value.magnitude)
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

  // MARK: - Equatable

  // This is mostly for unit tests
  internal static func == (lhs: Self, rhs: Self) -> Bool {
    let lhsHeader = lhs.buffer.header
    let rhsHeader = rhs.buffer.header

    guard lhsHeader.signAndCount == rhsHeader.signAndCount else {
      return false
    }

    return lhs.withWordsBuffer { lhs in
      return rhs.withWordsBuffer { rhs in
        // By hand is faster than: zip(lhs, rhs).allSatisfy { $0.0 == $0.1 }
        for i in 0..<lhs.count where lhs[i] != rhs[i] {
          return false
        }

        return true
      }
    }
  }

  // MARK: - Invariants

  internal mutating func fixInvariants(_ token: UniqueBufferToken) {
    self.validateToken(token)

    // Trim prefix zeros
    self.withWordsBuffer { words in
      while self.count > 0 && words[self.count - 1] == 0 {
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
      self.withWordsBuffer { words in
        let last = words[words.count - 1]
        assert(last != 0, "Zero prefix in BigInt")
      }
    }
#endif
  }

  // MARK: - Unique

  /// Token confirming exclusive access to buffer.
  ///
  /// All of the `mutating` methods will require token as a proof of buffer ownership.
  /// This type should be `move-only`, but Swift does not support it yet.
  internal struct UniqueBufferToken {
    fileprivate init () {}
  }

  internal mutating func guaranteeUniqueBufferReference() -> UniqueBufferToken {
    if self.buffer.isUniqueReference() {
      return UniqueBufferToken()
    }

    // Well… shit
    let new = Self.createBuffer(
      header: self.buffer.header,
      minimumCapacity: self.capacity
    )

    Self.memcpy(dst: new, src: self.buffer, count: self.count)
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
