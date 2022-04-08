// cSpell:ignore namespaceobject

// In CPython:
// Objects -> namespaceobject.c

// sourcery: pytype = cell, isDefault, hasGC
/// `Cell` = source for `free` variable.
///
/// Cells will be shared between multiple frames, so that child frame
/// can interact with value in parent frame.
public struct PyCell: PyObjectMixin {

  // sourcery: storedProperty
  // This has to be public for performance
  public var content: PyObject? {
    get { self.contentPtr.pointee }
    nonmutating set { self.contentPtr.pointee = newValue }
  }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, content: PyObject?) {
    self.initializeBase(py, type: type)
    self.contentPtr.initialize(to: content)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyCell(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "content", value: zelf.content as Any)
    return result
  }

  // MARK: - Equatable, comparable

  // sourcery: pymethod = __eq__
  internal static func __eq__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.isEqual(py, zelf: zelf, other: other, operation: .__eq__)
  }

  // sourcery: pymethod = __ne__
  internal static func __ne__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    let isEqual = Self.isEqual(py, zelf: zelf, other: other, operation: .__ne__)
    return isEqual.not
  }

  private static func isEqual(_ py: Py,
                              zelf: PyObject,
                              other: PyObject,
                              operation: CompareResult.Operation) -> CompareResult {
    switch Self.compare(py, zelf: zelf, other: other) {
    case .invalidSelfArgument:
      return .invalidSelfArgument(zelf, Self.pythonTypeName, operation)
    case .notImplemented:
      return .notImplemented

    case let .bothWithContent(zelfContent: z, otherContent: o):
      let result = py.isEqualBool(left: z, right: o)
      return CompareResult(result)

    case .zelfContentIsNil:
      return .value(false)
    case .otherContentIsNil:
      return .value(false)
    case .bothContentNil:
      return .value(true)
    }
  }

  // sourcery: pymethod = __lt__
  internal static func __lt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    switch Self.compare(py, zelf: zelf, other: other) {
    case .invalidSelfArgument:
      return .invalidSelfArgument(zelf, Self.pythonTypeName, .__lt__)
    case .notImplemented:
      return .notImplemented

    case let .bothWithContent(zelfContent: z, otherContent: o):
      let result = py.isLessBool(left: z, right: o)
      return CompareResult(result)

    case .zelfContentIsNil:
      return .value(true)
    case .otherContentIsNil:
      return .value(false)
    case .bothContentNil:
      return .value(false)
    }
  }

  // sourcery: pymethod = __le__
  internal static func __le__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    switch Self.compare(py, zelf: zelf, other: other) {
    case .invalidSelfArgument:
      return .invalidSelfArgument(zelf, Self.pythonTypeName, .__le__)
    case .notImplemented:
      return .notImplemented

    case let .bothWithContent(zelfContent: z, otherContent: o):
      let result = py.isLessEqualBool(left: z, right: o)
      return CompareResult(result)

    case .zelfContentIsNil:
      return .value(true)
    case .otherContentIsNil:
      return .value(false)
    case .bothContentNil:
      return .value(true)
    }
  }

  // sourcery: pymethod = __gt__
  internal static func __gt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    switch Self.compare(py, zelf: zelf, other: other) {
    case .invalidSelfArgument:
      return .invalidSelfArgument(zelf, Self.pythonTypeName, .__gt__)
    case .notImplemented:
      return .notImplemented

    case let .bothWithContent(zelfContent: z, otherContent: o):
      let result = py.isGreaterBool(left: z, right: o)
      return CompareResult(result)

    case .zelfContentIsNil:
      return .value(false)
    case .otherContentIsNil:
      return .value(true)
    case .bothContentNil:
      return .value(false)
    }
  }

  // sourcery: pymethod = __ge__
  internal static func __ge__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    switch Self.compare(py, zelf: zelf, other: other) {
    case .invalidSelfArgument:
      return .invalidSelfArgument(zelf, Self.pythonTypeName, .__ge__)
    case .notImplemented:
      return .notImplemented

    case let .bothWithContent(zelfContent: z, otherContent: o):
      let result = py.isGreaterEqualBool(left: z, right: o)
      return CompareResult(result)

    case .zelfContentIsNil:
      return .value(false)
    case .otherContentIsNil:
      return .value(true)
    case .bothContentNil:
      return .value(true)
    }
  }

  private enum CellCompareResult {
    case invalidSelfArgument
    case notImplemented
    case bothWithContent(zelfContent: PyObject, otherContent: PyObject)
    case zelfContentIsNil
    case otherContentIsNil
    case bothContentNil
  }

  /// Btw. general rule: `nil` is less.
  private static func compare(_ py: Py,
                              zelf _zelf: PyObject,
                              other: PyObject) -> CellCompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument
    }

    guard let other = Self.downcast(py, other) else {
      return .notImplemented
    }

    switch (zelf.content, other.content) {
    case let (.some(z), .some(o)):
      return .bothWithContent(zelfContent: z, otherContent: o)
    case (.some, nil):
      return .otherContentIsNil
    case (nil, .some):
      return .zelfContentIsNil
    case (nil, nil):
      return .bothContentNil
    }
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__repr__")
    }

    let ptr = zelf.ptr

    guard let content = zelf.content else {
      return PyResult(py, "<cell at \(ptr): empty>")
    }

    let type = content.typeName
    let contentPtr = content.ptr
    return PyResult(py, "<cell at \(ptr): \(type) object at \(contentPtr)>")
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf _zelf: PyObject,
                                        name: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }
}
