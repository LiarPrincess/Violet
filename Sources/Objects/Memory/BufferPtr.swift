// swiftlint:disable empty_count

/// A pointer for accessing a continuous allocation of `TrivialElement` instances.
///
/// - Important: `TrivialElement` has to be a trivial type:
///   A trivial type can be copied bit for bit with no indirection or
///   reference-counting operations. Generally, native Swift types that do not
///   contain strong or weak references or other forms of indirection are trivial,
///   as are imported C structs and enumerations.
public struct BufferPtr<TrivialElement>: RandomAccessCollection {

  /// A pointer to the first element of the buffer.
  public let baseAddress: UnsafeMutablePointer<TrivialElement>
  /// The number of elements in the buffer.
  ///
  /// If the `baseAddress` of this buffer is `nil`, the count is zero. However,
  /// a buffer can have a `count` of zero even with a non-`nil` base address.
  public let count: Int

  public var startIndex: Int { 0 }
  public var endIndex: Int { self.count }

  /// Creates a new buffer pointer over the specified number of contiguous
  /// instances beginning at the given pointer.
  ///
  /// - Parameters:
  ///   - start: A pointer to the start of the buffer. The pointer passed as `start`
  ///     must be aligned to `MemoryLayout<TrivialElement>.alignment`.
  ///   - count: The number of instances in the buffer. `count` must not be
  ///     negative.
  public init(start: UnsafePointer<TrivialElement>, count: Int) {
    assert(count >= 0, "BufferPtr with negative count")
    let startMutable = UnsafeMutablePointer(mutating: start)
    self.init(start: startMutable, count: count)
  }

  /// Creates a new buffer pointer over the specified number of contiguous
  /// instances beginning at the given pointer.
  ///
  /// - Parameters:
  ///   - start: A pointer to the start of the buffer. The pointer passed as `start`
  ///     must be aligned to `MemoryLayout<TrivialElement>.alignment`.
  ///   - count: The number of instances in the buffer. `count` must not be
  ///     negative.
  public init(start: UnsafeMutablePointer<TrivialElement>, count: Int) {
    assert(count >= 0, "BufferPtr with negative count")
    self.baseAddress = start
    self.count = count
  }

  // MARK: - Initialize

  /// Initializes every element in this buffer's memory to a copy of the given value.
  ///
  /// After a call to `initialize(repeating:)`, the entire region of memory
  /// referenced by this buffer is initialized.
  public func initialize(repeating repeatedValue: TrivialElement) {
    self.baseAddress.initialize(repeating: repeatedValue, count: self.count)
  }

  /// Initializes `source.count` first elements referenced by this buffer with
  /// the values frm `source`.
  ///
  /// After calling `initialize(from:)` the initial `source.count` elements are
  /// initialized. The rest of the elements are left uninitialized.
  ///
  /// - Parameters:
  ///   - source: A pointer to the values to copy. The memory region
  ///     `source..<(source + count)` must be initialized. The memory regions
  ///     referenced by `source` and this pointer must not overlap.
  public func initialize(from source: BufferPtr<TrivialElement>) {
    self.baseAddress.initialize(from: source.baseAddress, count: source.count)
  }

  /// Initializes every element in this buffer's memory to a result of calling
  /// `fn(index)`.
  ///
  /// After a call to `initialize(fn:)`, the entire region of memory referenced
  /// by this buffer is initialized.
  public func initialize(fn: (Int) -> TrivialElement) {
    var ptr = self.baseAddress
    for index in 0..<self.count {
      let element = fn(index)
      ptr.initialize(to: element)
      ptr = ptr.advanced(by: 1)
    }
  }

  /// Deinitialize all values in buffer.
  ///
  /// The region of memory starting at this pointer and covering `count`
  /// instances of the pointer's `Pointee` type must be initialized. After
  /// calling `deinitialize(count:)`, the memory is uninitialized, but still
  /// bound to the `Pointee` type.
  @discardableResult
  public func deinitialize() -> RawPtr {
    let raw = self.baseAddress.deinitialize(count: self.count)
    return RawPtr(raw)
  }

  // MARK: - Subscript

  public subscript(index: Int) -> TrivialElement {
    get {
      let elementPtr = self.getElementPointer(index: index)
      return elementPtr.pointee
    }
    nonmutating set {
      // This type only deals with trivial elements!
      let elementPtr = self.getElementPointer(index: index)
      elementPtr.pointee = newValue
    }
  }

  private func getElementPointer(index: Int) -> UnsafeMutablePointer<TrivialElement> {
#if DEBUG
    assert(index >= 0)
    assert(index < self.count)
#endif
    return self.baseAddress.advanced(by: index)
  }

  public subscript(range: Range<Int>) -> BufferPtr<TrivialElement> {
#if DEBUG
    assert(range.lowerBound >= 0)
    assert(range.upperBound <= self.count) // 'upperBound' is 1 past end, so is 'self.count'
#endif
    let ptr = self.baseAddress.advanced(by: range.lowerBound)
    return BufferPtr(start: ptr, count: range.count)
  }
}
