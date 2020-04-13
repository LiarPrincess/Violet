// In CPython:
// Objects -> namespaceobject.c

// sourcery: pytype = cell, default, hasGC
/// `Cell` = source for `free` variable.
///
/// Cells will be shared between multiple frames, so that child frame
/// can interact with value in parent frame.
public class PyCell: PyObject {

  public var content: PyObject?

  override public var description: String {
    let c = self.content.map(String.init(describing:)) ?? "nil"
    return "PyCell(content: \(c)"
  }

  internal init(content: PyObject?) {
    self.content = content
    super.init(type: Py.types.cell)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  public func isEqual(_ other: PyObject) -> CompareResult {
    return self.compare(
      with: other,
      bothHaveContent: Py.isEqualBool(left:right:),
      oneIsNil: self.bothNil(zelf:other:)
    )
  }

  private func bothNil(zelf: PyObject?, other: PyObject?) -> Bool {
    return zelf == nil && other == nil
  }

  // sourcery: pymethod = __ne__
  public func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  public func isLess(_ other: PyObject) -> CompareResult {
    return self.compare(
      with: other,
      bothHaveContent: Py.isLessBool(left:right:),
      oneIsNil: self.zelfIsNil(zelf:other:)
    )
  }

  private func zelfIsNil(zelf: PyObject?, other: PyObject?) -> Bool {
    return zelf == nil && other != nil
  }

  // sourcery: pymethod = __le__
  public func isLessEqual(_ other: PyObject) -> CompareResult {
    return self.compare(
      with: other,
      bothHaveContent: Py.isLessEqualBool(left:right:),
      oneIsNil: self.zelfOrBothAreNil(zelf:other:)
    )
  }

  private func zelfOrBothAreNil(zelf: PyObject?, other: PyObject?) -> Bool {
    return self.zelfIsNil(zelf: zelf, other: other)
        || self.bothNil(zelf: zelf, other: other)
  }

  // sourcery: pymethod = __gt__
  public func isGreater(_ other: PyObject) -> CompareResult {
    return self.compare(
      with: other,
      bothHaveContent: Py.isGreaterBool(left:right:),
      oneIsNil: self.otherIsNil(zelf:other:)
    )
  }

  private func otherIsNil(zelf: PyObject?, other: PyObject?) -> Bool {
    return zelf != nil && other == nil
  }

  // sourcery: pymethod = __ge__
  public func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return self.compare(
      with: other,
      bothHaveContent: Py.isGreaterEqualBool(left:right:),
      oneIsNil: self.otherOrBothAreNil(zelf:other:)
    )
  }

  private func otherOrBothAreNil(zelf: PyObject?, other: PyObject?) -> Bool {
    return self.otherIsNil(zelf: zelf, other: other)
        || self.bothNil(zelf: zelf, other: other)
  }

  private func compare(
    with other: PyObject,
    bothHaveContent: (PyObject, PyObject) -> PyResult<Bool>,
    oneIsNil: (PyObject?, PyObject?) -> Bool
  ) -> CompareResult {
    guard let other = other as? PyCell else {
      return .notImplemented
    }

    if let selfContent = self.content, let otherContent = other.content {
      switch bothHaveContent(selfContent, otherContent) {
      case let .value(v): return .value(v)
      case let .error(e): return .error(e)
      }
    }

    let result = oneIsNil(self.content, other.content)
    return .value(result)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  public func repr() -> PyResult<String> {
    let ptr = self.ptr

    guard let content = self.content else {
      return .value("<cell at \(ptr): empty>")
    }

    let type = content.typeName
    let contentPtr = content.ptr
    return .value("<cell at \(ptr): \(type) object at \(contentPtr)>")
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  public func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }
}
