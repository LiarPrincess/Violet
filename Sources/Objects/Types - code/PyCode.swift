import Bytecode

// In CPython:
// Objects -> codeobject.c

// sourcery: pytype = code, default
public class PyCode: PyObject {

  internal static let doc: String = """
    Create a code object. Not for the faint of heart.
    """

  internal let codeObject: CodeObject
  internal let filename = "" // TODO: Add 'filename' to CodeObject

  internal init(_ context: PyContext, code: CodeObject) {
    self.codeObject = code
    super.init(type: context.builtins.types.code)
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
    let name = self.hasher.hash(self.codeObject.name)
    let qualifiedName = self.hasher.hash(self.codeObject.qualifiedName)
    return .value(name ^ qualifiedName)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    let name = self.codeObject.name
    let ptr = self.ptrString
    let file = self.filename
    let line = self.codeObject.firstLine
    return .value("<code object \(name) at \(ptr), file '\(file)', line \(line)>")
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }
}
