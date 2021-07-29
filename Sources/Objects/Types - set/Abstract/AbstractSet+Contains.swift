extension AbstractSet {

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _contains(object: PyObject) -> PyResult<Bool> {
    switch Self._createElement(from: object) {
    case let .value(element):
      return self._contains(element: element)
    case let .error(e):
      return .error(e)
    }
  }

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _contains(element: Element) -> PyResult<Bool> {
    return self.elements.contains(element: element)
  }
}
