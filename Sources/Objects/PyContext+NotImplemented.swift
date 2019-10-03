import Core

public enum CompareMode {
  case equal
  case notEqual
  case less
  case lessEqual
  case greater
  case greaterEqual
}

internal protocol CGVisitor {
  func visit(_ object: PyObject)
}

extension PyContext {

  @discardableResult
  internal func unimplemented() -> PyObject {
    return self.none
  }

  public func _PyUnicode_JoinArray(elements: [PyObject]) -> PyObject {
    return self.unimplemented()
  }

  public func getSizeInt(value: PyObject) -> Int {
    return 0
  }

  internal func hash(value: PyObject) throws -> PyHash {
    return 0
  }

  internal func PyObject_GetIter(value: PyObject) -> PyObject {
    return value
  }

  internal func _PyType_Name(value: PyType) -> String {
    return value.name
  }

  internal func PyType_IsSubtype(parent: PyType, subtype: PyType) -> Bool {
    return false
  }

  internal func PyUnicode_FromFormat(format: String, args: Any...) -> String {
    return ""
  }

  public func PyObject_Format(value: PyObject, format: PyObject) -> PyObject {
    return self.unimplemented()
  }

  public func Py_CLEAR(value: PyObject) throws { }

  public func pySlice_New(start: PyObject, stop: PyObject, step: PyObject?) -> PyObject {
    return start
  }

  // MARK: - Attribute

  /// PyObject_SetAttr
  public func setAttribute(object: PyObject, name: String, value: PyObject) throws {
    self.unimplemented()
  }

  public func deleteAttribute(object: PyObject, name: String) throws {
    // err = PyObject_SetAttr(owner, name, (PyObject *)NULL);
    self.unimplemented()
  }

  /// PyObject_GetAttr
  public func getAttribute(object: PyObject, name: String) throws -> PyObject {
    return object
  }

  // MARK: - Subscript

  /// PyObject_GetItem
  public func getItem(object: PyObject, index: PyObject) throws -> PyObject {
    return object
  }

  /// PyObject_SetItem
  public func setItem(object: PyObject, index: PyObject, value: PyObject) throws {
    self.unimplemented()
  }

  /// PyObject_DelItem
  public func deleteItem(object: PyObject, index: PyObject) throws {
    self.unimplemented()
  }
}
