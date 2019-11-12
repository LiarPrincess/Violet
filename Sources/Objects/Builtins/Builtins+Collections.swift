public class CreateDictionaryArg {
  public let key: PyObject
  public let value: PyObject

  public init(key: PyObject, value: PyObject) {
    self.key = key
    self.value = value
  }
}

extension Builtins {

  // MARK: - Tuple

  /// PyObject * PyTuple_New(Py_ssize_t size)
  public func newTuple(_ elements: PyObject...) -> PyTuple {
    return self.newTuple(elements)
  }

  /// PyObject * PyTuple_New(Py_ssize_t size)
  public func newTuple(_ elements: [PyObject]) -> PyTuple {
    return elements.isEmpty ?
      self.emptyTuple :
      PyTuple(self.context, elements: elements)
  }

  /// PyObject * PyList_AsTuple(PyObject *v)
  public func newTuple(list: PyObject) -> PyTuple {
    let list = TypeFactory.selfAsPyList(list)
    return PyTuple(self.context, elements: list.elements)
  }

  // MARK: - List

  /// PyObject * PyList_New(Py_ssize_t size)
  public func newList(_ elements: PyObject...) -> PyList {
    return self.newList(elements)
  }

  /// PyObject * PyList_New(Py_ssize_t size)
  public func newList(_ elements: [PyObject]) -> PyList {
    return PyList(self.context, elements: elements)
  }

  /// int PyList_Append(PyObject *op, PyObject *newitem)
  public func add(list: PyObject, element: PyObject) {
    let list = TypeFactory.selfAsPyList(list)
    self.handleError(list.append(element))
  }

  /// PyObject * _PyList_Extend(PyListObject *self, PyObject *iterable)
//  public func extend(list: PyObject, iterable: PyObject) -> PyResult<()> {
//    let list = TypeFactory.selfAsPyList(list)
//    return list.extend(iterable).map { _ in () }
//  }

  // MARK: - Set

  /// PyObject * PySet_New(PyObject *iterable)
  public func newSet(_ elements: [PyObject] = []) -> PySet {
    var data = PySetData()
    for element in elements {
      switch self.hash(element) {
      case let .value(hash):
        data.insert(key: PySetElement(hash: hash, object: element))
      case let .error(e):
        self.handleError(e)
      }
    }

    return PySet(self.context, elements: data)
  }

  /// int PySet_Add(PyObject *anyset, PyObject *key)
  public func add(set: PyObject, value: PyObject) {
    let set = TypeFactory.selfAsPySet(set)
    self.handleError(set.add(value))
  }

  /// int _PySet_Update(PyObject *set, PyObject *iterable)
//  public func extend(set: PyObject, iterable: PyObject) {
//    self.unimplemented()
//  }

  // MARK: - Dictionary

  public func newDict(_ args: [CreateDictionaryArg] = []) -> PyDict {
    var data = PyDictData()
    for arg in args {
      switch self.hash(arg.key) {
      case let .value(hash):
        let key = PyDictKey(hash: hash, object: arg.key)
        data.insert(key: key, value: arg.value)
      case let .error(e):
        self.handleError(e)
      }
    }

    return PyDict(self.context, elements: data)
  }

  public func newDict(keyTuple: PyObject,
                      elements: [PyObject]) -> PyDict {
    var data = PyDictData()
    let keyTuple = TypeFactory.selfAsPyTuple(keyTuple)

    guard keyTuple.elements.count == elements.count else {
      self.handleError(
        PyErrorEnum.valueError("bad 'dictionary(keyTuple:elements:)' keys argument")
      )
      fatalError()
    }

    for (keyObject, value) in Swift.zip(keyTuple.elements, elements) {
      switch self.hash(keyObject) {
      case let .value(hash):
        let key = PyDictKey(hash: hash, object: keyObject)
        data.insert(key: key, value: value)
      case let .error(e):
        self.handleError(e)
      }
    }

    return PyDict(self.context, elements: data)
  }

  public func add(dict: PyObject, key: PyObject, value: PyObject) {
    let dict = TypeFactory.selfAsPyDict(dict)
    self.handleError(dict.setItem(at: key, to: value))
  }

  // MARK: - Range

  public func newRange(stop: PyInt) -> PyRange {
    let zero = self.newInt(0)
    return self.newRange(start: zero, stop: stop, step: nil)
  }

  public func newRange(start: PyInt, stop: PyInt, step: PyInt?) -> PyRange {
    if let s = step, s.value == 0 {
      self.handleError(PyErrorEnum.valueError("range() arg 3 must not be zero"))
    }

    return PyRange(self.context, start: start, stop: stop, step: step)
  }

  // MARK: - Enumerate

//  public func _enumerate(iterable: PyObject, startIndex: Int) -> PyResult<PyEnumerate> {
//    guard let source = iterable as? PyEnumerateSource else {
//      let str = self._str(value: iterable)
//      return .error(.typeError("'\(str)' object is not iterable"))
//    }
//
//    return .value(PyEnumerate(self, iterable: source, startIndex: startIndex))
//  }

  // MARK: - Slice

  public func slice(stop: PyInt?) -> PySlice {
    return PySlice(
      self.context,
      start: self.none,
      stop: stop ?? self.none,
      step: self.none
    )
  }

  public func slice(start: PyInt?, stop: PyInt?, step: PyInt? = nil) -> PySlice {
    return PySlice(
      self.context,
      start: start ?? self.none,
      stop: stop ?? self.none,
      step: step ?? self.none
    )
  }
}
