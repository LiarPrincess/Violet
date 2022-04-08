import BigInt
import VioletCore

/// Mixin with methods for various `PyDict` views.
///
/// DO NOT use them outside of the `dict` view objects!
internal protocol AbstractDictView: PyObjectMixin {

  /// Name of the type in Python.
  ///
  /// Used mainly in error messages.
  static var pythonTypeName: String { get }

  var dict: PyDict { get }

  /// Cast `PyObject` -> Self``.
  static func downcast(_ py: Py, _ object: PyObject) -> Self?
}

extension AbstractDictView {

  internal typealias OrderedDictionary = PyDict.OrderedDictionary
  internal typealias Element = OrderedDictionary.Element

  private var elements: OrderedDictionary {
    return self.dict.elements
  }

  // MARK: - Equatable

  internal static func abstract__eq__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__eq__)
    }

    return Self.isEqual(py, zelf: zelf, other: other)
  }

  internal static func abstract__ne__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__ne__)
    }

    let isEqual = Self.isEqual(py, zelf: zelf, other: other)
    return isEqual.not
  }

  private static func isEqual(_ py: Py, zelf: Self, other: PyObject) -> CompareResult {
    guard let size = Self.getDictOrSetSize(py, object: other) else {
      return .notImplemented
    }

    guard zelf.elements.count == size else {
      return .value(false)
    }

    let result = py.contains(iterable: zelf.asObject, allFrom: other)
    return CompareResult(result)
  }

  // MARK: - Comparable

  internal static func abstract__lt__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__lt__)
    }

    guard let size = Self.getDictOrSetSize(py, object: other) else {
      return .notImplemented
    }

    guard zelf.elements.count < size else {
      return .value(false)
    }

    let result = py.contains(iterable: other, allFrom: zelf.asObject)
    return CompareResult(result)
  }

  internal static func abstract__le__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__le__)
    }

    guard let size = Self.getDictOrSetSize(py, object: other) else {
      return .notImplemented
    }

    guard zelf.elements.count <= size else {
      return .value(false)
    }

    let result = py.contains(iterable: other, allFrom: zelf.asObject)
    return CompareResult(result)
  }

  internal static func abstract__gt__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__gt__)
    }

    guard let size = Self.getDictOrSetSize(py, object: other) else {
      return .notImplemented
    }

    guard zelf.elements.count > size else {
      return .value(false)
    }

    let result = py.contains(iterable: zelf.asObject, allFrom: other)
    return CompareResult(result)
  }

  internal static func abstract__ge__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__ge__)
    }

    guard let size = Self.getDictOrSetSize(py, object: other) else {
      return .notImplemented
    }

    guard zelf.elements.count >= size else {
      return .value(false)
    }

    let result = py.contains(iterable: zelf.asObject, allFrom: other)
    return CompareResult(result)
  }

  private static func getDictOrSetSize(_ py: Py, object: PyObject) -> Int? {
    if let set = py.cast.asAnySet(object) {
      return set.elements.count
    }

    if let dict = py.cast.asDict(object) {
      return dict.elements.count
    }

    return nil
  }

  // MARK: - __hash__

  internal static func abstract__hash__(_ py: Py, zelf _zelf: PyObject) -> HashResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName)
    }

    return .unhashable(zelf.asObject)
  }

  // MARK: - __repr__

  internal static func abstract__repr__(
    _ py: Py,
    zelf _zelf: PyObject,
    elementRepr: (Py, Element) -> PyResultGen<String>
  ) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__repr__")
    }

    if zelf.hasReprLock {
      return PyResult(py, interned: "...")
    }

    return zelf.withReprLock {
      var result = Self.pythonTypeName + "("
      for (index, element) in zelf.dict.elements.enumerated() {
        if index > 0 {
          result += ", " // so that we don't have ', )'.
        }

        switch elementRepr(py, element) {
        case let .value(s): result += s
        case let .error(e): return .error(e)
        }
      }

      result += ")"
      return PyResult(py, result)
    }
  }

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

  // MARK: - __len__

  internal static func abstract__len__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__len__")
    }

    let result = zelf.elements.count
    return PyResult(py, result)
  }

  // MARK: - Helpers

  private static func invalidZelfArgument(_ py: Py,
                                          _ object: PyObject,
                                          _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}
