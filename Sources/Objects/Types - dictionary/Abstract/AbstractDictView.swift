import BigInt
import VioletCore

/// Mixin with methods for various `PyDict` views.
///
/// DO NOT use them outside of the `dict` view objects!
internal protocol AbstractDictView: PyObjectMixin {

  /// Name of the type.
  /// Used mainly in error messages.
  static var typeName: String { get }

  var dict: PyDict { get }

  /// Cast `PyObject` -> Self``.
  static func castZelf(_ py: Py, _ object: PyObject) -> Self?
}

extension AbstractDictView {

  internal typealias OrderedDictionary = PyDict.OrderedDictionary
  internal typealias Element = OrderedDictionary.Element

  private var elements: OrderedDictionary {
    return self.dict.elements
  }

  // MARK: - Zelf

  internal static func invalidZelfArgument<T>(_ py: Py,
                                              _ object: PyObject,
                                              _ fnName: String) -> PyResult<T> {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.typeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }

  // MARK: - Equatable

  internal static func abstract__eq__(_ py: Py,
                                      zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.castZelf(py, zelf) else {
      return .invalidSelfArgument(zelf, Self.typeName, .__eq__)
    }

    return Self.isEqual(py, zelf: zelf, other: other)
  }

  internal static func abstract__ne__(_ py: Py,
                                      zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.castZelf(py, zelf) else {
      return .invalidSelfArgument(zelf, Self.typeName, .__ne__)
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
                                      zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.castZelf(py, zelf) else {
      return .invalidSelfArgument(zelf, Self.typeName, .__lt__)
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
                                      zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.castZelf(py, zelf) else {
      return .invalidSelfArgument(zelf, Self.typeName, .__le__)
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
                                      zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.castZelf(py, zelf) else {
      return .invalidSelfArgument(zelf, Self.typeName, .__gt__)
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
                                      zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.castZelf(py, zelf) else {
      return .invalidSelfArgument(zelf, Self.typeName, .__ge__)
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

  internal static func abstract__hash__(_ py: Py, zelf: PyObject) -> HashResult {
    guard let zelf = Self.castZelf(py, zelf) else {
      return .invalidSelfArgument(zelf, Self.typeName)
    }

    return .unhashable(zelf.asObject)
  }

  // MARK: - __repr__

  internal static func abstract__repr__(
    _ py: Py,
    zelf: PyObject,
    elementRepr: (Py, Element) -> PyResult<String>
  ) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__repr__")
    }

    if zelf.hasReprLock {
      return PyResult(py, interned:  "...")
    }

    return zelf.withReprLock {
      var result = Self.typeName + "("
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
                                                zelf: PyObject,
                                                name: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - __len__

  internal static func abstract__len__(_ py: Py,
                                       zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castZelf(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__len__")
    }

    let result = zelf.elements.count
    return PyResult(py, result)
  }
}
