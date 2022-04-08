extension AbstractSet {

  internal static func abstract__contains__(_ py: Py,
                                            zelf _zelf: PyObject,
                                            object: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__contains__")
    }

    switch Self.createElement(py, object: object) {
    case let .value(element):
      let result = Self.contains(py, zelf: zelf, element: element)
      return PyResult(py, result)
    case let .error(e):
      return .error(e)
    }
  }

  private static func contains(_ py: Py,
                               zelf: Self,
                               element: Element) -> PyResultGen<Bool> {
    return zelf.elements.contains(py, element: element)
  }
}
