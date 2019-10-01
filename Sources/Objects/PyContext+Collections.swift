extension PyContext {

  // MARK: - Tuple

  /// PyObject * PyTuple_New(Py_ssize_t size)
  public func createTuple(elements: [PyObject] = []) -> PyObject {
    return elements.isEmpty ? self.emptyTuple : self.types.tuple.new(elements)
  }

  /// PyObject * PyList_AsTuple(PyObject *v)
  public func createTuple(list: PyObject) throws -> PyObject {
    let l = try self.types.list.matchType(list)
    return self.createTuple(elements: l.elements)
  }

  // MARK: - List

  /// PyObject * PyList_New(Py_ssize_t size)
  public func createList(elements: [PyObject] = []) -> PyObject {
    return self.types.list.new(elements)
  }

  /// int PyList_Append(PyObject *op, PyObject *newitem)
  public func PyList_Append(list: PyObject, value: PyObject) {
    self.unimplemented()
  }

  /// PyObject * _PyList_Extend(PyListObject *self, PyObject *iterable)
  public func _PyList_Extend(list: PyObject, iterable: PyObject) {
    self.unimplemented()
  }

  // MARK: - Set

  public func createSet(elements: [PyObject] = []) -> PyObject {
    return self.unimplemented()
  }

  // TODO: rename to 'add'?
  public func setAdd(set: PyObject, value: PyObject) {
    self.unimplemented()
  }

  public func _PySet_Update(set: PyObject, iterable: PyObject) {
    self.unimplemented()
  }

  // MARK: - Dictionary

  public func createDictionary(elements: [CreateDictionaryArg] = []) -> PyObject {
    return self.unimplemented()
  }

  public func createConstDictionary(keys: PyObject,
                                    elements: [PyObject]) -> PyObject {
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
