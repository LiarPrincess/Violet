/// Common things for all of the Python objects.
public protocol PyObjectMixin: PyFunctionResultConvertible, CustomStringConvertible {
  var ptr: RawPtr { get }
}

extension PyObjectMixin {

  // MARK: - Header

  public var header: PyObjectHeader {
    // Assumption: headerOffset = 0, but this should be valid for all of our types.
    return PyObjectHeader(ptr: self.ptr)
  }

  /// Also known as `klass`, but we are using CPython naming convention.
  public var type: PyType { self.header.type }
  /// [Convenience] Name of the type of this Python object.
  public var typeName: String { self.type.name }

  /// Various flags that describe the current state of the `PyObject`.
  ///
  /// It can also be used to store `Bool` properties (via `custom` flags).
  public var flags: PyObjectHeader.Flags {
    get { self.header.flags }
    nonmutating set { self.header.flags = newValue }
  }

  /// [Convenience] Convert this object to `PyObject`.
  public var asObject: PyObject { PyObject(ptr: self.ptr) }

  // MARK: - Repr

  /// This flag is used to control infinite recursion
  /// in `repr`, `str`, `print` etc.
  internal var hasReprLock: Bool {
    return self.flags.isSet(.reprLock)
  }

  /// Set, execute `body` and then unset `reprLock` flag
  /// (the one that is used to control recursion in `repr`, `str`, `print` etc).
  internal func withReprLock<T>(body: () -> T) -> T {
    // We do not need 'defer' because 'body' is not throwing
    self.flags.set(.reprLock)
    let result = body()
    self.flags.unset(.reprLock)
    return result
  }

  // MARK: - Description

  public var description: String {
    let type = self.header.type
    return type.debugFn(self.ptr)
  }

  // MARK: - Function result convertible

  // 'PyObject' can be returned from Python function!
  // Yeah… I know, kind of hard to believe.
  internal var asFunctionResult: PyFunctionResult {
    return .value(self.asObject)
  }
}
