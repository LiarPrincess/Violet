import Bytecode

// In CPython:
// Objects -> codeobject.c

// sourcery: pytype = code
internal final class PyCode: PyObject {

  internal static let doc: String = """
    Create a code object. Not for the faint of heart.
    """

  internal let _code: CodeObject

  // TODO: Add 'filename' to CodeObject
  private let filename: String = ""

  internal init(_ context: PyContext, code: CodeObject) {
    self._code = code
    #warning("Add to PyContext")
    super.init()
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .value(self === other)
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> PyResultOrNot<PyHash> {
    // Not the best, but PyCodes are not used often
    let name = HashHelper.hash(self._code.name)
    let qualifiedName = HashHelper.hash(self._code.qualifiedName)
    return .value(name ^ qualifiedName)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> String {
    return "<code object \(self._code.name) at \(self.ptrString), " +
           "file '\(self.filename)', line \(self._code.firstLine)>"
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }
}
