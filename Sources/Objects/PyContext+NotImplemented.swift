import Core

extension PyContext {

  @discardableResult
  internal func unimplemented() -> PyObject {
    return self.builtins.none
  }

  internal func call(_ fn: PyObject, args: [PyObject?]) -> PyResult<PyObject> {
    return .value(self.unimplemented())
  }

  internal func callDir(_ fn: PyObject, args: [PyObject?]) -> DirResult {
    return DirResult()
  }

  public func _PyUnicode_JoinArray(elements: [PyObject]) -> PyObject {
    return self.unimplemented()
  }

  public func getSizeInt(value: PyObject) -> Int {
    return 0
  }

  public func PyObject_Format(value: PyObject, format: PyObject) -> PyObject {
    return self.unimplemented()
  }

  public func pySlice_New(start: PyObject, stop: PyObject, step: PyObject?) -> PyObject {
    return start
  }

  internal func getGlobals() -> [String: PyObject] {
    return [:]
  }

  // MARK: - Attribute

  /// PyObject_SetAttr
  public func setAttribute(object: PyObject, name: String, value: PyObject) {
    self.unimplemented()
  }

  public func deleteAttribute(object: PyObject, name: String) {
    // err = PyObject_SetAttr(owner, name, (PyObject *)NULL);
    self.unimplemented()
  }

  /// PyObject_GetAttr
  public func getAttribute(object: PyObject, name: String) -> PyObject {
    return object
  }

  // MARK: - Subscript

  /// PyObject_GetItem
  public func getItem(object: PyObject, index: PyObject) -> PyObject {
    return object
  }

  /// PyObject_SetItem
  public func setItem(object: PyObject, index: PyObject, value: PyObject) {
    self.unimplemented()
  }

  /// PyObject_DelItem
  public func deleteItem(object: PyObject, index: PyObject) {
    self.unimplemented()
  }
}
