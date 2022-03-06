// swiftlint:disable fatal_error_message
// swiftlint:disable unavailable_function

// MARK: - PyType

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

// MARK: - PyDict

extension PyDict {

  internal func isEqual(_ other: PyDict) -> CompareResult { fatalError() }

  public func copy() -> PyDict { fatalError() }

  public func update(from object: PyDict, onKeyDuplicate: OnUpdateKeyDuplicate) -> PyResult<PyNone> { fatalError() }
  public func update(from object: PyObject, onKeyDuplicate: OnUpdateKeyDuplicate) -> PyResult<PyNone> { fatalError() }
}

// MARK: - Collections

extension PyList {
  public func sort(key: Int?, isReverse: Bool?) -> PyResult<PyObject> { fatalError() }
}

extension PyString {
  public func repr() -> String { fatalError() }
}

// MARK: - Functions

extension PyModule {
  public func getName() -> PyResult<PyObject> { fatalError() }
}

extension PyProperty {
  public static func wrap(
    doc: String?,
    get: (Py, PyObject) -> PyResult<PyObject>,
    set: (Py, PyObject, PyObject) -> PyResult<PyObject>,
    del: (Py, PyObject) -> PyResult<PyObject>
  ) -> PyProperty { fatalError() }

  internal func bind(to object: PyObject) -> PyResult<PyObject> {fatalError() }
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

  public func bind(to object: PyObject) -> PyBuiltinMethod { fatalError() }
}

extension PyFunction {
  public func bind(to object: PyObject) -> PyMethod { fatalError() }
}

extension PySlice {
  internal struct AdjustedIndices {
    internal var start: Int
    internal var stop: Int
    internal var step: Int
    /// Number of entries between `self.start` and `self.stop` using `self.step`.
    internal let count: Int

    internal var isEmpty: Bool {
      // Both 'SwiftLint' and 'SwiftFormat' will fail on the following line

      // swiftformat:disable:next isEmpty
      return self.count == 0 // swiftlint:disable:this empty_count
    }
  }

  internal struct UnpackedIndices {
    internal var start: Int
    internal var stop: Int
    internal var step: Int

    internal func adjust(toCount count: Int) -> AdjustedIndices { fatalError() }
  }

  internal func unpack() -> PyResult<UnpackedIndices> { fatalError() }
}
