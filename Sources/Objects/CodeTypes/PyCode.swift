import Bytecode

// TODO: Code
// __getattribute__
// __sizeof__
// co_argcount
// co_cellvars
// co_code
// co_consts
// co_filename
// co_firstlineno
// co_flags
// co_freevars
// co_kwonlyargcount
// co_lnotab
// co_name
// co_names
// co_nlocals
// co_stacksize
// co_varnames

// sourcery: pytype = code
internal final class PyCode: PyObject,
  ComparableTypeClass, HashableTypeClass, ReprTypeClass {

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

  internal func isEqual(_ other: PyObject) -> EquatableResult {
    return .value(self === other)
  }

  // MARK: - Comparable

  internal func isLess(_ other: PyObject) -> ComparableResult {
    return .notImplemented
  }

  internal func isLessEqual(_ other: PyObject) -> ComparableResult {
    return .notImplemented
  }

  internal func isGreater(_ other: PyObject) -> ComparableResult {
    return .notImplemented
  }

  internal func isGreaterEqual(_ other: PyObject) -> ComparableResult {
    return .notImplemented
  }

  // MARK: - Hashable

  internal func hash() -> HashableResult {
    // Not the best, but PyCodes are not used often
    let hasher = self.context.hasher
    let name = hasher.hash(self._code.name)
    let qualifiedName = hasher.hash(self._code.qualifiedName)
    return .value(name ^ qualifiedName)
  }

  // MARK: - String

  internal func repr() -> String {
    return "<code object \(self._code.name) at \(self.ptrString), " +
           "file '\(self.filename)', line \(self._code.firstLine)>"
  }
}
