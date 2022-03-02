import VioletCore

/// Helper type used when implementing `__dir__` methods.
internal struct DirResult {

  private var elements = [PyObject]()

  // MARK: - Init

  internal init() {}

  internal init<S: Sequence>(_ elements: S) where S.Element == PyObject {
    self.append(contentsOf: elements)
  }

  // MARK: - Append

  internal mutating func append(_ element: PyObject) {
    self.elements.append(element)
  }

  internal mutating func append<S: Sequence>(contentsOf newElements: S)
    where S.Element == PyObject {

    for element in newElements {
      self.append(element)
    }
  }

  internal mutating func append(contentsOf newElements: DirResult) {
    self.append(contentsOf: newElements.elements)
  }

  // MARK: - Append keys/elements

  internal mutating func append(_ py: Py,
                                keysFrom dict: PyDict) -> PyBaseException? {
    self.append(py, keysFrom: dict.asObject)
  }

  internal mutating func append(_ py: Py,
                                keysFrom object: PyObject) -> PyBaseException? {
    switch py.getKeys(object: object) {
    case let .value(keys):
      return self.append(py, elementsFrom: keys)
    case let .missingMethod(e),
         let .error(e):
      return e
    }
  }

  internal mutating func append(_ py: Py,
                                elementsFrom iterable: PyObject) -> PyBaseException? {
    let e = py.forEach(iterable: iterable) { object in
      self.append(object)
      return .goToNextElement
    }

    return e
  }

  // MARK: - Result

  internal func toResult(_ py: Py) -> PyResult<PyObject> {
    let list = py.newList(elements: self.elements)
    switch list.sort(key: nil, isReverse: false) {
    case .value:
      return .value(list.asObject)
    case .error(let e):
      return .error(e)
    }
  }
}
