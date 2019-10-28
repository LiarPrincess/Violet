extension PyContext {

  // MARK: - Str

  /// PyObject * PyObject_Str(PyObject *v)
  public func str(value: PyObject) -> PyObject {
    let raw = self._str(value: value)
    return PyString(self, value: raw)
  }

  internal func _str(value: PyObject) -> String {
    return ""
  }
}
