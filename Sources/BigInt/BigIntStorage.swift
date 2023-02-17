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
internal struct BigIntStorage: RandomAccessCollection, Equatable, CustomStringConvertible {

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
    return self.isEmpty
  }

  internal var isNegative: Bool {
    get {
      let signAndCount = self.buffer.header.signAndCount
      return (signAndCount & Header.signMask) == Header.signMask
    }
    set {
      // Avoid possible copy in 'self.guaranteeUniqueBufferReference()'.
      // This check is free because we have to get header from the memory anyway.
      if self.isNegative != newValue {
        // We will allow setting 'isNegative' when the value is '0',
        // just assume that user know what they are doing.
        let token = self.guaranteeUniqueBufferReference()
        self.setIsNegative(token, value: newValue)
      }
    }
  }

  internal mutating func setIsNegative(_ token: UniqueBufferToken, value: Bool) {
    self.validateToken(token)

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
    get { return !self.isNegative }
    set { self.isNegative = !newValue }
  }

  internal private(set) var count: Int {
    get {
      let signAndCount = self.buffer.header.signAndCount
      return Int(signAndCount & Header.countMask)
    }
    set {
      // Avoid possible copy in 'self.guaranteeUniqueBufferReference()'.
      // This check is free because we have to get header from the memory anyway.
      if self.count != newValue {
        let token = self.guaranteeUniqueBufferReference()
        self.setCount(token, value: newValue)
      }
    }
  }

  private mutating func setCount(_ token: UniqueBufferToken, value: Int) {
    self.validateToken(token)
    assert(value >= 0)

    let sign = self.buffer.header.signAndCount & Header.signMask
    let count = Header.Storage(value)
    self.buffer.header.signAndCount = sign | count
  }

  internal var capacity: Int {
    return self.buffer.capacity
  }

  internal var startIndex: Int {
    return 0
  }

  internal var endIndex: Int {
    return self.count
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
    self.count = count
  }

  internal init(isNegative: Bool, magnitude: Word) {
    if magnitude == 0 {
      self = Self.zero
    } else {
      self.init(minimumCapacity: 1)
      self.isNegative = isNegative
      self.append(magnitude)
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
    get {
      self.checkBounds(index: index)
      return self.buffer.withUnsafeMutablePointerToElements { ptr in
        ptr.advanced(by: index).pointee
      }
    }
    set {
      self.checkBounds(index: index)
      self.guaranteeUniqueBufferReference()
      self.buffer.withUnsafeMutablePointerToElements { ptr in
        ptr.advanced(by: index).pointee = newValue
      }
    }
  }

  private func checkBounds(index: Int) {
    // 'Assert' instead of 'precondition',
    // because we control all of the callers (this type is internal).
    assert(0 <= index && index < self.count, "Index out of range")
  }

  // MARK: - Append

  /// Add given `Word` to the buffer.
  internal mutating func append(_ element: Word) {
    self.guaranteeUniqueBufferReference(withMinimumCapacity: self.count + 1)

    self.buffer.withUnsafeMutablePointerToElements { ptr in
      ptr.advanced(by: self.count).pointee = element
    }

    self.count += 1
  }

  /// Add given `Word` to the buffer.
  internal mutating func append(_ token: UniqueBufferToken, element: Word) {
    self.validateToken(token)

    let newCount = self.count + 1
    self.reserveCapacity(token, capacity: newCount)

    self.buffer.withUnsafeMutablePointerToElements { ptr in
      ptr.advanced(by: self.count).pointee = element
    }

    self.count += 1
  }

  /// Add all of the `Word`s from given collection to the buffer.
  internal mutating func append<C: Collection>(
    contentsOf other: C
  ) where C.Element == Word {
    if other.isEmpty {
      return
    }

    let newCount = self.count + other.count
    self.guaranteeUniqueBufferReference(withMinimumCapacity: newCount)

    self.buffer.withUnsafeMutablePointerToElements { startPtr in
      var ptr = startPtr.advanced(by: self.count)
      for word in other {
        ptr.pointee = word
        ptr = ptr.successor()
      }
    }

    self.count = newCount
  }

  /// Add all of the `Word`s from given collection to the buffer.
  internal mutating func append<C: Collection>(
    _ token: UniqueBufferToken,
    contentsOf other: C
  ) where C.Element == Word {
    if other.isEmpty {
      return
    }

    let newCount = self.count + other.count
    self.reserveCapacity(token, capacity: newCount)

    self.buffer.withUnsafeMutablePointerToElements { startPtr in
      var ptr = startPtr.advanced(by: self.count)
      for word in other {
        ptr.pointee = word
        ptr = ptr.successor()
      }
    }

    self.count = newCount
  }

  // MARK: - Prepend

  /// Add given `Word`  at the start of the buffer specified number of times.
  internal mutating func prepend(_ element: Word, count: Int) {
    assert(count >= 0)

    if count.isZero {
      return
    }

    let newCount = self.count + count
    if self.buffer.isUniqueReference() && self.capacity >= newCount {
      // Our current buffer is big enough to do the whole operation,
      // no new allocation is needed.

      self.buffer.withUnsafeMutablePointerToElements { startPtr in
        // Move current words back
        let targetPtr = startPtr.advanced(by: count)
        targetPtr.assign(from: startPtr, count: self.count)

        // Set prefix words to given 'element'
        startPtr.assign(repeating: element, count: count)
      }

      self.count = newCount
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
        targetPtr.assign(from: selfStartPtr, count: self.count)

        // Set prefix words to given 'element'.
        // We have to do this even if 'element = 0',
        // because new buffer contains garbage.
        newStartPtr.assign(repeating: element, count: count)
      }
    }

    self.buffer = new
  }

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

    let newCount = self.count + count
    if self.buffer.isUniqueReference() && self.capacity >= newCount {
      // Our current buffer is big enough to do the whole operation,
      // no new allocation is needed.

      self.buffer.withUnsafeMutablePointerToElements { startPtr in
        // Move current words back
        let targetPtr = startPtr.advanced(by: count)
        targetPtr.assign(from: startPtr, count: self.count)

        // Set prefix words to given 'element'
        startPtr.assign(repeating: element, count: count)
      }

      self.count = newCount
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
        targetPtr.assign(from: selfStartPtr, count: self.count)

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
  internal mutating func dropFirst(wordCount count: Int) {
    assert(count >= 0)

    if count == 0 {
      return
    }

    if count >= self.count {
      self.removeAll()
      return
    }

    self.guaranteeUniqueBufferReference()

    let newCount = self.count - count
    assert(newCount > 0) // We checked 'count >= self.count'

    self.buffer.withUnsafeMutablePointerToElements { startPtr in
      // Copy 'newCount' elements to front
      let copySrcPtr = startPtr.advanced(by: count)
      startPtr.assign(from: copySrcPtr, count: newCount)
    }

    self.count = newCount
  }

  // MARK: - Transform

  /// Apply given function to every word
  internal mutating func transformEveryWord(fn: (Word) -> Word) {
    self.guaranteeUniqueBufferReference()

    self.buffer.withUnsafeMutablePointerToElements { startPtr in
      let endPtr = startPtr.advanced(by: self.count)

      var ptr = startPtr
      while ptr != endPtr {
        let old = ptr.pointee
        ptr.pointee = fn(old)
        ptr = ptr.successor()
      }
    }
  }

  // MARK: - Reserve capacity

  internal mutating func reserveCapacity(_ capacity: Int) {
    self.guaranteeUniqueBufferReference(withMinimumCapacity: capacity)
  }

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

  // MARK: - Remove all

  internal mutating func removeAll() {
    // We do not have to call 'self.guaranteeUniqueBufferReference'
    // because 'self.count' will do it anyway.
    self.count = 0
  }

  private mutating func removeAll(_ token: UniqueBufferToken) {
    self.setCount(token, value: 0)
  }

  // MARK: - Replace all

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
    self.reserveCapacity(token, capacity: newCount)

    self.buffer.withUnsafeMutablePointerToElements { ptr in
      ptr.assign(from: otherPtr, count: other.count)
    }

    self.count = newCount
  }

  // MARK: - Set

  internal mutating func setToZero() {
    self = Self.zero
    assert(self.isPositive)
  }

  /// Set `self` to represent given `UInt`.
  internal mutating func set(to value: UInt) {
    // We do not have to call 'self.guaranteeUniqueBufferReference'
    // because all of the functions we are using will do it anyway.

    if value == 0 {
      self.setToZero()
    } else {
      self.removeAll()
      self.isNegative = false
      self.append(value)
    }
  }

  /// Set `self` to represent given `UInt`.
  ///
  /// May REALLOCATE BUFFER -> invalidates tokens.
  internal mutating func setTo(_ token: UniqueBufferToken, value: UInt) {
    if value == 0 {
      self.setToZero()
    } else {
      self.removeAll(token)
      self.setIsNegative(token, value: false)
      self.append(token, element: value)
    }
  }

  /// Set `self` to represent given `Int`.
  internal mutating func set(to value: Int) {
    // We do not have to call 'self.guaranteeUniqueBufferReference'
    // because all of the functions we are using will do it anyway.

    if value == 0 {
      self.setToZero()
    } else {
      self.removeAll()
      self.isNegative = value.isNegative
      self.append(value.magnitude)
    }
  }

  /// Set `self` to represent given `Int`.
  internal mutating func setTo(_ token: UniqueBufferToken, value: Int) {
    if value == 0 {
      self.setToZero()
    } else {
      self.removeAll(token)
      self.setIsNegative(token, value: value.isNegative)
      self.append(token, element: value.magnitude)
    }
  }

  // MARK: - String

  internal var description: String {
    var result = "BigIntStorage("
    result.append("isNegative: \(self.isNegative), ")

    result.append("words: [")
    for (index, word) in self.enumerated() {
      result.append("0b")
      result.append(String(word, radix: 2, uppercase: false))

      let isLast = index == self.count - 1
      if !isLast {
        result.append(", ")
      }
    }
    result.append("]")

    result.append(")")
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
        for i in 0..<lhs.count {
          if lhs[i] != rhs[i] {
            return false
          }
        }

        return true
      }
    }
  }

  // MARK: - Invariants

  internal mutating func fixInvariants() {
    // Trim prefix zeros
    while let last = self.last, last.isZero {
      self.count -= 1
    }

    // Zero is always positive
    if self.isEmpty {
      self.isNegative = false
    }
  }

  internal func checkInvariants() {
#if DEBUG
    if let last = self.last {
      assert(last != 0, "zero prefix in BigInt")
    } else {
      // 'self.data' is empty = we are '0'
      assert(!self.isNegative, "isNegative with empty data")
    }
#endif
  }

  // MARK: - Unique

  /// Token confirming exclusive access to buffer.
  ///
  /// All of the `mutating` methods will require token as a proof of buffer ownership.
  internal struct UniqueBufferToken {
    internal init () {}
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

  private mutating func guaranteeUniqueBufferReference(
    withMinimumCapacity minimumCapacity: Int
  ) -> UniqueBufferToken {
    if self.buffer.isUniqueReference() && self.capacity >= minimumCapacity {
      return UniqueBufferToken()
    }

    // Well… shit, we have to allocate new buffer,
    // but we can grow at the same time (2 birds - 1 stone).
    let growFactor = 2
    let capacity = Swift.max(minimumCapacity, growFactor * self.capacity, 1)

    let new = Self.createBuffer(
      header: self.buffer.header,
      minimumCapacity: capacity
    )

    Self.memcpy(dst: new, src: self.buffer, count: self.count)
    self.buffer = new
    return UniqueBufferToken()
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
