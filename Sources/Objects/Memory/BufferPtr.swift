public struct BufferPtr<Element>: RandomAccessCollection {

  /// The number of elements in the buffer.
  ///
  /// If the `baseAddress` of this buffer is `nil`, the count is zero. However,
  /// a buffer can have a `count` of zero even with a non-`nil` base address.
  public var count: Int { self.value.count }

  public var startIndex: Int { 0 }
  public var endIndex: Int { self.count }

  private let value: UnsafeMutableBufferPointer<Element>

  public init(_ value: UnsafeBufferPointer<Element>) {
    self.value = UnsafeMutableBufferPointer(mutating: value)
  }

  public init(_ value: UnsafeMutableBufferPointer<Element>) {
    self.value = value
  }

  // MARK: - Initialize

  /// Initializes every element in this buffer's memory to a copy of the given value.
  ///
  /// The destination memory must be uninitialized or the buffer's `Element`
  /// must be a trivial type. After a call to `initialize(repeating:)`, the
  /// entire region of memory referenced by this buffer is initialized.
  ///
  /// - Parameters:
  ///   - repeatedValue: The instance to initialize this buffer's memory with.
  public func initialize(repeating repeatedValue: Element) {
    self.value.initialize(repeating: repeatedValue)
  }

  /// Initializes the buffer's memory with the given elements.
  ///
  /// When calling the `initialize(from:)` method on a buffer `b`, the memory
  /// referenced by `b` must be uninitialized or the `Element` type must be a
  /// trivial type. After the call, the memory referenced by this buffer up
  /// to, but not including, the returned index is initialized. The buffer
  /// must contain sufficient memory to accommodate
  /// `source.underestimatedCount`.
  ///
  /// The returned index is the position of the element in the buffer one past
  /// the last element written. If `source` contains no elements, the returned
  /// index is equal to the buffer's `startIndex`. If `source` contains an
  /// equal or greater number of elements than the buffer can hold, the
  /// returned index is equal to the buffer's `endIndex`.
  ///
  /// - Parameter source: A sequence of elements with which to initializer the
  ///   buffer.
  /// - Returns: An iterator to any elements of `source` that didn't fit in the
  ///   buffer, and an index to the point in the buffer one past the last
  ///   element written.
  public func initialize<S: Sequence>(
    from source: S
  ) -> (S.Iterator, Int) where S.Element == Element {
    return self.value.initialize(from: source)
  }

  /// Deinitializes the specified all values in buffer.
  ///
  /// The region of memory starting at this pointer and covering `count`
  /// instances of the pointer's `Pointee` type must be initialized. After
  /// calling `deinitialize(count:)`, the memory is uninitialized, but still
  /// bound to the `Pointee` type.
  @discardableResult
  public func deinitialize() -> RawPtr? {
    let unsafeRawPointer = self.value.baseAddress?.deinitialize(count: self.count)
    return unsafeRawPointer.map(RawPtr.init)
  }

  // MARK: - Subscript

  public subscript(index: Int) -> Element {
    get { return self.value[index] }
    nonmutating set { self.value[index] = newValue }
  }

  public subscript(range: Range<Int>) -> BufferPtr<Element> {
    let slice = self.value[range]
    let ptr = UnsafeMutableBufferPointer(rebasing: slice)
    return BufferPtr(ptr)
  }

  // MARK: - Equality


  private var baseAddress: UnsafeMutablePointer<Element>? {
    return self.value.baseAddress
  }

  /// Returns a `Boolean` value indicating whether two `Ptrs` are pointing
  /// to the same object.
  @available(*, unavailable, message: "Can't compare buffers")
  public static func === (lhs: BufferPtr, rhs: BufferPtr) -> Bool {
    guard lhs.count == rhs.count else {
      return false
    }

    // Docs for 'UnsafeMutablePointer.baseAddress':
    // A pointer to the first element of the buffer.
    //
    // If the `baseAddress` of this buffer is `nil`, the count is zero. However,
    // a buffer can have a `count` of zero even with a non-`nil` base address.

    // Basically:
    // - both have 'baseAddress' -> compare them
    // - one of them does not have 'baseAddress' -> false
    // - both do not have 'baseAddress' -> THIS IS THE PROBLEM
    //   we have already lost our 'identity' so we have nothing to compare.

    guard let lhsPtr = lhs.baseAddress, let rhsPtr = rhs.baseAddress else {
      return false
    }

    return lhsPtr == rhsPtr
  }
}
