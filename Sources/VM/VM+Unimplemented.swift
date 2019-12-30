import Objects

extension VM {

  /// PyImport_ImportModule
  internal func importModule(_ name: String) -> PyObject {
    self.unimplemented()
  }

  /// PyModule_GetDict
  internal func getDict(_ object: PyObject) -> PyObject {
    self.unimplemented()
  }

  /// PyDict_SetItemString
  internal func setItemString(dict: PyObject, key: String, value: PyObject) {
    self.unimplemented()
  }

  /// PyDict_DelItemString
  internal func delItemString(dict: PyObject, key: String) {
    self.unimplemented()
  }

  /// PyUnicode_DecodeFSDefault
  internal func newString(_ value: String) -> PyObject {
    self.unimplemented()
  }

  /// PyObject_GetAttrString
  internal func getAttrString(dict: PyObject, key: String) -> PyObject {
    self.unimplemented()
  }

  /// PyObject_Call
  internal func call(callable: PyObject,
                     args: [PyObject],
                     kwargs: [PyObject]) -> PyObject {
    self.unimplemented()
  }
}
