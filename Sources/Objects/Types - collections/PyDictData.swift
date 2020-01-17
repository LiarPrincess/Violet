internal typealias PyDictData = OrderedDictionary<PyDictKey, PyObject>

internal struct PyDictKey: PyHashable {

  internal var hash: PyHash
  internal var object: PyObject

  internal init(hash: PyHash, object: PyObject) {
    self.hash = hash
    self.object = object
  }

  internal func isEqual(to other: PyDictKey) -> PyResult<Bool> {
    // >>> class C:
    // ...     def __eq__(self, other): raise NotImplementedError('a')
    // ...     def __hash__(self): return 1
    // >>> d = {}
    // >>> d[1] = 'a'
    // >>> d[c] = 'b'
    // NotImplementedError: a

    guard self.hash == other.hash else {
      return .value(false)
    }

    return Py.isEqualBool(left: self.object, right: other.object)
  }
}
