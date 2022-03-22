import VioletCore

/// Helper type used when implementing `__dir__` methods.
public struct DirResult {

  fileprivate var elements = [PyObject]()

  // MARK: - Init

  public init() {}

  public init<S: Sequence>(_ elements: S) where S.Element == PyObject {
    self.append(contentsOf: elements)
  }

  // MARK: - Append

  public mutating func append(_ element: PyObject) {
    self.elements.append(element)
  }

  public mutating func append<S: Sequence>(contentsOf newElements: S)
  where S.Element == PyObject {

    for element in newElements {
      self.append(element)
    }
  }

  public mutating func append(contentsOf newElements: DirResult) {
    self.append(contentsOf: newElements.elements)
  }

  // MARK: - Append keys/elements

  public mutating func append(_ py: Py, keysFrom dict: PyDict) -> PyBaseException? {
    self.append(py, keysFrom: dict.asObject)
  }

  public mutating func append(_ py: Py, keysFrom object: PyObject) -> PyBaseException? {
    switch py.getKeys(object: object) {
    case let .value(keys):
      return self.append(py, elementsFrom: keys)
    case let .missingMethod(e),
      let .error(e):
      return e
    }
  }

  public mutating func append(_ py: Py, elementsFrom iterable: PyObject) -> PyBaseException? {
    let e = py.forEach(iterable: iterable) { object in
      self.append(object)
      return .goToNextElement
    }

    return e
  }
}

// MARK: - PyResult

extension PyResult {

  public init(_ py: Py, _ dir: DirResult) {
    let list = py.newList(elements: dir.elements)
    switch list.sort(py, key: nil, isReverse: false) {
    case .value:
      self = PyResult(list)
    case .error(let e):
      self = .error(e)
    }
  }

  public init(_ py: Py, _ result: PyResultGen<DirResult>) {
    switch result {
    case let .value(dir):
      self = PyResult(py, dir)
    case let .error(e):
      self = .error(e)
    }
  }
}

extension PyResultGen where Wrapped == DirResult {
  public static func invalidSelfArgument(
    _ py: Py,
    _ zelf: PyObject,
    _ expectedType: String
  ) -> PyResultGen<DirResult> {
    let error = py.newInvalidSelfArgumentError(object: zelf,
                                               expectedType: expectedType,
                                               fnName: "__dir__")

    return .error(error.asBaseException)
  }
}
