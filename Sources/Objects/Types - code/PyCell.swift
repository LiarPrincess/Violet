// cSpell:ignore namespaceobject

// In CPython:
// Objects -> namespaceobject.c

// sourcery: pytype = cell, isDefault, hasGC
/// `Cell` = source for `free` variable.
///
/// Cells will be shared between multiple frames, so that child frame
/// can interact with value in parent frame.
public struct PyCell: PyObjectMixin {

  // Layout will be automatically generated, from `Ptr` fields.
  // Just remember to initialize them in `initialize`!
  internal static let layout = PyMemory.PyCellLayout()

  // This has to be public for performance
  internal var contentPtr: Ptr<PyObject?> { self.ptr[Self.layout.contentOffset] }
  internal var content: PyObject? { self.contentPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(type: PyType, content: PyObject?) {
    self.header.initialize(type: type)
    self.contentPtr.initialize(to: content)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyCell(ptr: ptr)
    return "PyCell(type: \(zelf.typeName), flags: \(zelf.flags))"
  }
}

/* MARKER

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    return self.compare(with: other,
                        compareContent: Py.isEqualBool(left:right:),
                        whenSelfIsNil: false,
                        whenOtherIsNil: false,
                        whenBothNil: true)
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    return self.compare(with: other,
                        compareContent: Py.isLessBool(left:right:),
                        whenSelfIsNil: true,
                        whenOtherIsNil: false,
                        whenBothNil: false)
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    return self.compare(with: other,
                        compareContent: Py.isLessEqualBool(left:right:),
                        whenSelfIsNil: true,
                        whenOtherIsNil: false,
                        whenBothNil: true)
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    return self.compare(with: other,
                        compareContent: Py.isGreaterBool(left:right:),
                        whenSelfIsNil: false,
                        whenOtherIsNil: true,
                        whenBothNil: false)
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return self.compare(with: other,
                        compareContent: Py.isGreaterEqualBool(left:right:),
                        whenSelfIsNil: false,
                        whenOtherIsNil: true,
                        whenBothNil: true)
  }

  /// General rule: `nil` is less.
  private func compare(with other: PyObject,
                       compareContent: (PyObject, PyObject) -> PyResult<Bool>,
                       whenSelfIsNil: Bool,
                       whenOtherIsNil: Bool,
                       whenBothNil: Bool) -> CompareResult {
    guard let other = PyCast.asCell(other) else {
      return .notImplemented
    }

    switch (self.content, other.content) {
    case let (.some(selfContent), .some(otherContent)):
      let compareResult = compareContent(selfContent, otherContent)
      switch compareResult {
      case let .value(v): return .value(v)
      case let .error(e): return .error(e)
      }

    case (.some, nil):
      return .value(whenOtherIsNil)
    case (nil, .some):
      return .value(whenSelfIsNil)
    case (nil, nil):
      return .value(whenBothNil)
    }
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> String {
    let ptr = self.ptr

    guard let content = self.content else {
      return "<cell at \(ptr): empty>"
    }

    let type = content.typeName
    let contentPtr = content.ptr
    return "<cell at \(ptr): \(type) object at \(contentPtr)>"
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }
}

*/
