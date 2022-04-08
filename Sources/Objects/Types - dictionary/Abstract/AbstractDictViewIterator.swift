/// Mixin with methods for various `PyDict` iterators.
///
/// DO NOT use them outside of the `dict` iterator objects!
internal protocol AbstractDictViewIterator: PyObjectMixin {

  /// Name of the type in Python.
  ///
  /// Used mainly in error messages.
  static var pythonTypeName: String { get }

  var dict: PyDict { get }
  var index: Int { get nonmutating set }
  var initialCount: Int { get }

  /// Cast `PyObject` -> Self``.
  static func downcast(_ py: Py, _ object: PyObject) -> Self?
}

extension AbstractDictViewIterator {

  // MARK: - __getattribute__

  // sourcery: pymethod = __getattribute__
  internal static func abstract__getattribute__(_ py: Py,
                                                zelf _zelf: PyObject,
                                                name: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - __iter__

  internal static func abstract__iter__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__iter__")
    }

    return PyResult(zelf)
  }

  // MARK: - __next__

  internal typealias Entry = PyDict.OrderedDictionary.Entry

  internal static func abstract__next__(_ py: Py,
                                        zelf _zelf: PyObject) -> PyResultGen<Entry> {
    guard let zelf = Self.downcast(py, _zelf) else {
      let error = self.invalidZelfArgumentError(py, _zelf, "__next__")
      return .error(error.asBaseException)
    }

    let elements = zelf.dict.elements

    let currentCount = elements.count
    guard currentCount == zelf.initialCount else {
      zelf.index = -1 // Make this state sticky
      return .runtimeError(py, message: "dictionary changed size during iteration")
    }

    let entries = elements.entries
    while zelf.index < entries.count {
      let entry = entries[zelf.index]

      // Increment index NOW, so that the regardless of whether we return 'entry'
      // or iterate more we move to next element.
      zelf.index += 1

      switch entry {
      case .entry(let e):
        return .value(e)
      case .deleted:
        break // move to next element
      }
    }

    return .stopIteration(py, value: nil)
  }

  // MARK: - __length_hint__

  internal static func abstract__length_hint__(_ py: Py,
                                               zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__length_hint__")
    }

    let count = zelf.dict.elements.count
    let result = count - zelf.index
    return PyResult(py, result)
  }

  // MARK: - Helpers

  private static func invalidZelfArgumentError(_ py: Py,
                                               _ object: PyObject,
                                               _ fnName: String) -> PyTypeError {
    return py.newInvalidSelfArgumentError(object: object,
                                          expectedType: Self.pythonTypeName,
                                          fnName: fnName)
  }

  private static func invalidZelfArgument(_ py: Py,
                                          _ object: PyObject,
                                          _ fnName: String) -> PyResult {
    let error = self.invalidZelfArgumentError(py, object, fnName)
    return .error(error.asBaseException)
  }
}
