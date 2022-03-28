/// A pointer for accessing a single instance of `Pointee`.
///
/// For example: a pointer to Python object `type` or `__dict__` property.
public struct Ptr<Pointee> {

  /// Accesses the instance referenced by this pointer.
  ///
  /// When reading from the `pointee` property, the instance referenced by this
  /// pointer must already be initialized. When `pointee` is used as the left
  /// side of an assignment, the instance must be initialized or this
  /// pointer's `Pointee` type must be a trivial type.
  ///
  /// Do not assign an instance of a nontrivial type through `pointee` to
  /// uninitialized memory. Instead, use an initializing method, such as
  /// `initialize(to:)`.
  public var pointee: Pointee {
    get { self.value.pointee }
    nonmutating set { self.value.pointee = newValue }
  }

  private let value: UnsafeMutablePointer<Pointee>

  public init(_ value: UnsafePointer<Pointee>) {
    self.value = UnsafeMutablePointer(mutating: value)
  }

  public init(_ value: UnsafeMutablePointer<Pointee>) {
    self.value = value
  }

  public init(_ baseRawPtr: RawPtr, offset: Int) {
    let raw = baseRawPtr.advanced(by: offset)
    self = raw.bind(to: Pointee.self)
  }

  // MARK: - Initialize

  /// Initializes this pointer's memory with a single instance of the given value.
  ///
  /// The destination memory must be uninitialized or the pointer's `Pointee`
  /// must be a trivial type. After a call to `initialize(to:)`, the
  /// memory referenced by this pointer is initialized.
  ///
  /// - Parameters:
  ///   - value: The instance to initialize this pointer's pointee to.
  public func initialize(to pointee: Pointee) {
    self.value.initialize(to: pointee)
  }

  /// Deinitialize the value represented by this pointer.
  ///
  /// The region of memory pointed by this pointer must be initialized to `Pointee`
  /// type first. After calling `deinitialize`, the memory is uninitialized,
  /// but still bound to the `Pointee` type.
  ///
  /// - Important: Calling this method is **essential** for updating ARC
  /// for managed objects.
  @discardableResult
  public func deinitialize() -> RawPtr {
    let unsafeRawPtr = self.value.deinitialize(count: 1)
    return RawPtr(unsafeRawPtr)
  }

  // MARK: - Equality

  /// Returns a `Boolean` value indicating whether two `Ptrs` are pointing
  /// to the same object.
  public static func === (lhs: Ptr, rhs: Ptr) -> Bool {
    return lhs.value == rhs.value
  }
}
