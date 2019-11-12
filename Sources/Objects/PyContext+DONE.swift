import Core

// swiftlint:disable file_length

extension PyContext {

  // MARK: - Bool

  public func not(value: PyObject) -> Bool {
    return false
  }

  public func isTrue(value: PyObject) -> Bool {
    return true
  }

  public func `is`(left: PyObject, right: PyObject) -> Bool {
    return false
  }

  // MARK: - Repr

  /// PyObject * PyObject_Repr(PyObject *v)
  public func repr(value: PyObject) -> PyObject {
    let raw = self._repr(value: value)
    return PyString(self, value: raw)
  }

  internal func _repr(value: PyObject) -> String {
//    if let reprType = value as? ReprTypeClass {
//      return reprType.repr()
//    }
//
//    return self.genericRepr(value: value)
    return ""
  }

  // MARK: - ASCII

  /// PyObject * PyObject_ASCII(PyObject *v)
  public func ascii(value: PyObject) -> PyObject {
    let raw = self.asciiStr(value: value)
    return PyString(self, value: raw)
  }

  internal func asciiStr(value: PyObject) -> String {
    let repr = self._repr(value: value)
    let scalars = repr.unicodeScalars

    let allASCII = scalars.allSatisfy { $0.isASCII }
    if allASCII {
      return repr
    }

    var result = ""
    for scalar in scalars {
      if scalar.isASCII {
        result.append(String(scalar))
      } else if scalar.value < 0x10000 {
        // \uxxxx Character with 16-bit hex value xxxx
        result.append("\\u\(self.hex(scalar.value, padTo: 4))")
      } else {
        // \Uxxxxxxxx Character with 32-bit hex value xxxxxxxx
        result.append("\\U\(self.hex(scalar.value, padTo: 8))")
      }
    }

    return result
  }

  private func hex(_ value: UInt32, padTo: Int) -> String {
    let raw = String(value, radix: 16, uppercase: false)
    return raw.padding(toLength: padTo, withPad: "0", startingAt: 0)
  }

  // MARK: - Helpers

  private func genericRepr(value: PyObject) -> String {
    return "<\(value.typeName) object at \(value.ptrString)>"
  }

  // MARK: - Hash

  /// Py_hash_t PyObject_Hash(PyObject *v)
  internal func hash(value: PyObject) -> PyHash {
    return 0
  }

  // MARK: - Compare

  public func isEqual(left: PyObject, right: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  public func isNotEqual(left: PyObject, right: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  public func isLess(left: PyObject, right: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  public func isLessEqual(left: PyObject, right: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  public func isGreater(left: PyObject, right: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  public func isGreaterEqual(left: PyObject, right: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

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
    let zero = self.builtins.newInt(0)
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
