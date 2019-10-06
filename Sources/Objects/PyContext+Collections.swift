public class CreateDictionaryArg {
  public let key: PyObject
  public let value: PyObject

  public init(key: PyObject, value: PyObject) {
    self.key = key
    self.value = value
  }
}

extension PyContext {

  // MARK: - Tuple

  /// PyObject * PyTuple_New(Py_ssize_t size)
  public func tuple(elements: [PyObject] = []) -> PyObject {
    return elements.isEmpty ? self.emptyTuple : self.types.tuple.new(elements)
  }

  /// PyObject * PyList_AsTuple(PyObject *v)
  public func tuple(list: PyObject) throws -> PyObject {
//    let l = try self.types.list.matchType(list)
//    return self.tuple(elements: l.elements)
    return self.unimplemented()
  }

  // MARK: - List

  /// PyObject * PyList_New(Py_ssize_t size)
  public func list(elements: [PyObject] = []) -> PyObject {
    return self.types.list.new(elements)
  }

  /// int PyList_Append(PyObject *op, PyObject *newitem)
  public func add(list: PyObject, element: PyObject) throws {
//    try self.types.list.add(owner: list, element: element)
  }

  /// PyObject * _PyList_Extend(PyListObject *self, PyObject *iterable)
  public func extent(list: PyObject, iterable: PyObject) throws {
//    try self.types.list.extend(owner: list, iterable: iterable)
  }

  // MARK: - Set

  /// PyObject * PySet_New(PyObject *iterable)
  public func set(elements: [PyObject] = []) throws -> PyObject {
    return try self.types.set.new(elements: elements)
  }

  /// int PySet_Add(PyObject *anyset, PyObject *key)
  public func add(set: PyObject, value: PyObject) throws {
//    try self.types.set.add(owner: set, element: value)
  }

  /// int _PySet_Update(PyObject *set, PyObject *iterable)
  public func extend(set: PyObject, iterable: PyObject) throws {
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
