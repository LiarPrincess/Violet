extension PyContext {

  // MARK: - Tuple

  /// PyObject * PyTuple_New(Py_ssize_t size)
  public func tuple(elements: [PyObject] = []) -> PyObject {
    return elements.isEmpty ? self.emptyTuple : self.types.tuple.new(elements)
  }

  /// PyObject * PyList_AsTuple(PyObject *v)
  public func tuple(list: PyObject) throws -> PyObject {
    let l = try self.types.list.matchType(list)
    return self.tuple(elements: l.elements)
  }

  // MARK: - List

  /// PyObject * PyList_New(Py_ssize_t size)
  public func list(elements: [PyObject] = []) -> PyObject {
    return self.types.list.new(elements)
  }

  /// int PyList_Append(PyObject *op, PyObject *newitem)
  public func append(list: PyObject, element: PyObject) throws {
    try self.types.list.add(owner: list, element: element)
  }

  /// PyObject * _PyList_Extend(PyListObject *self, PyObject *iterable)
  public func append(list: PyObject, iterable: PyObject) throws {
    try self.types.list.extend(owner: list, iterable: iterable)
  }

  // MARK: - Set

  public func set(elements: [PyObject] = []) -> PyObject {
    return self.unimplemented()
  }

  public func setAdd(set: PyObject, value: PyObject) {
    self.unimplemented()
  }

  public func _PySet_Update(set: PyObject, iterable: PyObject) {
    self.unimplemented()
  }

  // MARK: - Dictionary

  public func dictionary(elements: [CreateDictionaryArg] = []) -> PyObject {
    return self.unimplemented()
  }

  public func dictionary(keyTuple: PyObject, elements: [PyObject]) -> PyObject {
    // check keys.count == elements.count
    return self.unimplemented()
  }

  public func dictionaryAdd(dictionary: PyObject, key: PyObject, value: PyObject) {
    self.unimplemented()
  }

  public func PyDict_Update(dictionary: PyObject, iterable: PyObject) {
    self.unimplemented()
  }

  // MARK: - Shared

  public func contains(sequence: PyObject, value: PyObject) -> PyObject {
    return self.unimplemented()
  }
}
