/// Mixin with methods for various `PyDict` iterators.
///
/// DO NOT use them outside of the `dict` iterator objects!
internal protocol AbstractDictViewIterator: PyObjectMixin {
  var dict: PyDict { get }
  var index: Int { get nonmutating set }
  var initialCount: Int { get }

  /// Cast `PyObject` -> Self``.
  static func castZelf(_ py: Py, _ object: PyObject) -> Self?
}

extension AbstractDictViewIterator {

  // MARK: - __getattribute__

  // sourcery: pymethod = __getattribute__
  internal static func abstract__getattribute__(_ py: Py,
                                                zelf: PyObject,
                                                name: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - __iter__

  internal static func abstract__iter__(_ py: Py,
                                        zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__iter__")
    }

    return PyResult(zelf)
  }

  // MARK: - __next__

  internal typealias Entry = PyDict.OrderedDictionary.Entry

  internal static func abstract__next__(_ py: Py,
                                        zelf: PyObject) -> PyResult<Entry> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__next__")
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
                                               zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__length_hint__")
    }

    let count = zelf.dict.elements.count
    let result = count - zelf.index
    return PyResult(py, result)
  }
}
