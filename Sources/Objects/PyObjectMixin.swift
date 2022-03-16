/// Common things for all of the Python objects.
public protocol PyObjectMixin: CustomStringConvertible {
  /// Pointer to and object.
  ///
  /// Each object starts with the same fields as `PyObject`.
  var ptr: RawPtr { get }
}

extension PyObjectMixin {

  // MARK: - Header

  /// [Convenience] Convert this object to `PyObject`.
  public var asObject: PyObject {
    return PyObject(ptr: self.ptr)
  }

  /// [Convenience] Name of the runtime type of this Python object.
  public var typeName: String {
    let object = self.asObject
    let type = object.type
    return type.name
  }

  // MARK: - Repr

  /// This flag is used to control infinite recursion
  /// in `repr`, `str`, `print` etc.
  internal var hasReprLock: Bool {
    let object = self.asObject
    return object.flags.isSet(.reprLock)
  }

  /// Set, execute `body` and then unset `reprLock` flag
  /// (the one that is used to control recursion in `repr`, `str`, `print` etc).
  internal func withReprLock<T>(body: () -> T) -> T {
    let object = self.asObject

    // We do not need 'defer' because 'body' is not throwing
    object.flags.set(.reprLock)
    let result = body()
    object.flags.unset(.reprLock)
    return result
  }

  // MARK: - Description

  public var description: String {
    let object = self.asObject
    let type = object.type
    return type.debugFn(self.ptr)
  }

  // TODO: [Old] Description
//  public var description: String {
//    let swiftType = String(describing: Swift.type(of: self))
//    var result = "\(swiftType)(type: \(self.typeName), flags: \(self.flags)"
//
//    let hasDescriptionLock = self.flags.isSet(.descriptionLock)
//    if hasDescriptionLock {
//      result.append(", RECURSIVE ENTRY)")
//      return result
//    }
//
//    self.flags.set(.descriptionLock)
//    defer { self.flags.unset(.descriptionLock) }
//
//    let mirror = Mirror(reflecting: self)
//    self.appendProperties(from: mirror, to: &result)
//
//    result.append(")")
//    return result
//  }
}
