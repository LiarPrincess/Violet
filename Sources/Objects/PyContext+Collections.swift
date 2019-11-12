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
  public func tuple(_ elements: PyObject...) -> PyObject {
    return self._tuple(elements)
  }

  /// PyObject * PyTuple_New(Py_ssize_t size)
  public func tuple(_ elements: [PyObject]) -> PyObject {
    return self._tuple(elements)
  }

  internal func _tuple(_ elements: [PyObject]) -> PyTuple {
    return elements.isEmpty ?
      self._emptyTuple :
      PyTuple(self, elements: elements)
  }

  /// PyObject * PyList_AsTuple(PyObject *v)
  public func tuple(list: PyObject) throws -> PyObject {
//    let l = try self.types.list.matchType(list)
//    return self.tuple(elements: l.elements)
    return self.unimplemented()
  }

  // MARK: - List

  /// PyObject * PyList_New(Py_ssize_t size)
  public func list(_ elements: PyObject...) -> PyObject {
    return self._list(elements)
  }

  /// PyObject * PyList_New(Py_ssize_t size)
  public func list(_ elements: [PyObject]) -> PyObject {
    return self._list(elements)
  }

  internal func _list(_ elements: [PyObject]) -> PyList {
    return PyList(self, elements: elements)
  }

  /// int PyList_Append(PyObject *op, PyObject *newitem)
  public func add(list: PyObject, element: PyObject) throws {
//    try self.types.list.add(owner: list, element: element)
  }

  /// PyObject * _PyList_Extend(PyListObject *self, PyObject *iterable)
  public func extend(list: PyObject, iterable: PyObject) throws {
//    try self.types.list.extend(owner: list, iterable: iterable)
  }

  // MARK: - Set

  /// PyObject * PySet_New(PyObject *iterable)
  public func set(elements: [PyObject] = []) throws -> PyObject {
//    return try self.types.set.new(elements: elements)
    return self.unimplemented()
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

  // MARK: - Range

  internal func _range(stop: PyInt) -> PyResult<PyRange> {
    let zero = self._int(0)
    return self._range(start: zero, stop: stop, step: nil)
  }

  internal func _range(start: PyInt,
                       stop: PyInt,
                       step: PyInt?) -> PyResult<PyRange> {
    if let s = step, s.value == 0 {
      return .error(.valueError("range() arg 3 must not be zero"))
    }

    return .value(PyRange(self, start: start, stop: stop, step: step))
  }

  // MARK: - Shared

  public func contains(sequence: PyObject, value: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // MARK: - Enumerate

//  internal func _enumerate(iterable: PyObject, startIndex: Int) -> PyResult<PyEnumerate> {
//    guard let source = iterable as? PyEnumerateSource else {
//      let str = self._str(value: iterable)
//      return .error(.typeError("'\(str)' object is not iterable"))
//    }
//
//    return .value(PyEnumerate(self, iterable: source, startIndex: startIndex))
//  }

  // MARK: - Slice

  internal func slice(stop: PyInt?) -> PySlice {
    return PySlice(
      self,
      start: self.none,
      stop: stop ?? self.none,
      step: self.none
    )
  }

  internal func slice(start: PyInt?, stop: PyInt?, step: PyInt? = nil) -> PySlice {
    return PySlice(
      self,
      start: start ?? self.none,
      stop: stop ?? self.none,
      step: step ?? self.none
    )
  }
}
