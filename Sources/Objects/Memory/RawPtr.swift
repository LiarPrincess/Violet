/// Pointer to a Python object as a whole.
///
/// If you need to manipulate memory inside of a Python object, for example a single
/// property like `type`, then use the typed `Ptr`.
public struct RawPtr: CustomStringConvertible {

  // Do not change it to 'UnsafeMutableRawPointer'!
  // Any mutation should go through 'Ptr'.
  fileprivate let value: UnsafeRawPointer

  public var description: String {
    let int = Int(bitPattern: self)
    return "0x" + String(int, radix: 16, uppercase: true)
  }

  public init(_ value: UnsafeRawPointer) {
    self.value = value
  }

  public init(_ value: UnsafeMutableRawPointer) {
    self.value = UnsafeRawPointer(value)
  }

  // MARK: - Bind

  /// Binds the memory to the specified type and returns a typed pointer to the
  /// bound memory.
  ///
  /// Use the `bind(to:)` method to bind the memory referenced by this pointer
  /// to the type `T`. The memory must be uninitialized or initialized to a type
  /// that is layout compatible with `T`. If the memory is uninitialized,
  /// it is still uninitialized after being bound to `T`.
  ///
  /// - Warning: A memory location may only be bound to one type at a time. The
  ///   behavior of accessing memory as a type unrelated to its bound type is
  ///   undefined.
  ///
  /// - Parameters:
  ///   - type: The type `T` to bind the memory to.
  /// - Returns: A typed pointer to the newly bound memory. The memory in this
  ///   region is bound to `T`, but has not been modified in any other way.
  public func bind<T>(to type: T.Type) -> Ptr<T> {
    let unsafePtr = self.value.bindMemory(to: T.self, capacity: 1)
    return Ptr(unsafePtr)
  }

  // MARK: - Advanced by

  /// Returns a `ptr` that is offset the specified distance from this `ptr`.
  public func advanced(by n: Int) -> RawPtr {
    let raw = self.value.advanced(by: n)
    return RawPtr(raw)
  }

  // MARK: - Allocate

  /// Allocates uninitialized memory with the specified size and alignment.
  ///
  /// You are in charge of managing the allocated memory. Be sure to deallocate
  /// any memory that you manually allocate.
  ///
  /// The allocated memory is not bound to any specific type and must be bound
  /// before performing any typed operations.
  ///
  /// - Parameters:
  ///   - byteCount: The number of bytes to allocate. `byteCount` must not be negative.
  ///   - alignment: The alignment of the new region of allocated memory, in
  ///     bytes.
  /// - Returns: A pointer to a newly allocated region of memory. The memory is
  ///   allocated, but not initialized.
  public static func allocate(byteCount: Int, alignment: Int) -> RawPtr {
    let ptr = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: alignment)
    return RawPtr(ptr)
  }

  /// Deallocates the previously allocated memory referenced by this pointer.
  ///
  /// The memory to be deallocated must be uninitialized or initialized to a
  /// trivial type.
  public func deallocate() {
    self.value.deallocate()
  }

  // MARK: - Equality

  /// Returns a `Boolean` value indicating whether two `Ptrs` are pointing
  /// to the same object.
  public static func === (lhs: RawPtr, rhs: RawPtr) -> Bool {
    return lhs.value == rhs.value
  }

  /// Returns a `Boolean` value indicating whether two `Ptrs` are NOT pointing
  /// to the same object.
  public static func !== (lhs: RawPtr, rhs: RawPtr) -> Bool {
    return lhs.value != rhs.value
  }
}

// MARK: - Int + init(bitPattern:)

extension Int {

  /// Creates a new value with the bit pattern of the given pointer.
  ///
  /// The new value represents the address of the pointer passed as `pointer`.
  /// If `pointer` is `nil`, the result is `0`.
  public init(bitPattern pointer: RawPtr) {
    self = Int(bitPattern: pointer.value)
  }
}
