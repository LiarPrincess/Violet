// swiftlint:disable fatal_error_message
// swiftlint:disable unavailable_function

extension PyType {
  public struct MemoryLayout {
    internal func isEqual(to other: MemoryLayout) -> Bool {
      fatalError()
    }

    internal func isAddingNewProperties(to other: MemoryLayout) -> Bool {
      fatalError()
    }
  }

  public static func pyNew(type: PyType, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> { fatalError() }
}

extension PyDict {

  public enum GetResult {
    case value(PyObject)
    case notFound
    case error(PyBaseException)
  }

  public func get(id: IdString) -> PyObject? { fatalError() }
  public func get(key: PyObject) -> GetResult { fatalError() }

  public enum SetResult {
    case ok
    case error(PyBaseException)
  }

  public func set(id: IdString, to value: PyObject) { fatalError() }
  public func set(key: PyString, to value: PyObject) -> SetResult { fatalError() }

  public enum DelResult {
    case value(PyObject)
    case notFound
    case error(PyBaseException)
  }

  public func del(id: IdString) -> PyObject? { fatalError() }
  public func del(key: PyObject) -> DelResult { fatalError() }

  public func copy() -> PyDict { fatalError() }
}

extension PyList {
  public func sort(key: Int?, isReverse: Bool?) -> PyResult<PyObject> { fatalError() }
}

extension PyModule {
  public func getName() -> PyResult<PyObject> { fatalError() }
}

extension PyString {
  public func repr() -> String { fatalError() }
}

extension PyProperty {
  public static func wrap(
    doc: String?,
    get: (Py, PyObject) -> PyResult<PyObject>,
    set: (Py, PyObject, PyObject) -> PyResult<PyObject>,
    del: (Py, PyObject) -> PyResult<PyObject>
  ) -> PyProperty { fatalError() }
}

extension PyBuiltinFunction {
  public static func wrap(
    name: String,
    doc: String?,
    fn: (Py, PyObject, PyObject) -> PyResult<PyObject>
  ) -> PyBuiltinFunction { fatalError() }

  public static func wrap(
    name: String,
    doc: String?,
    fn: (Py, PyObject, PyObject, PyObject?) -> PyResult<PyObject>
  ) -> PyBuiltinFunction { fatalError() }
}
