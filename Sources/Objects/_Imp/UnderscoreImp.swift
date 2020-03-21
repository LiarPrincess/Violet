// In CPython:
// Python -> import.c

// Docs:
// https://docs.python.org/3.7/reference/import.html
// https://docs.python.org/3.7/library/importlib.html

// sourcery: pymodule = _imp
/// (Extremely) low-level import machinery bits as used by importlib and imp.
/// Nuff said...
public final class UnderscoreImp {

  internal static let doc = """
    (Extremely) low-level import machinery bits as used by importlib and imp.
    """

  // MARK: - Dict

  /// This dict will be used inside our `PyModule` instance.
  internal private(set) lazy var __dict__ = Py.newDict()

  // MARK: - Spec helpers

  internal func getName(spec: PyObject) -> PyResult<PyString> {
    switch Py.getAttribute(spec, name: .name) {
    case let .value(object):
      guard let str = object as? PyString else {
        return .typeError("Module name must be a str, not \(object.typeName)")
      }

      return .value(str)

    case let .error(e):
      return .error(e)
    }
  }

  internal func getPath(spec: PyObject) -> PyResult<PyString> {
    switch Py.getAttribute(spec, name: .origin) {
    case let .value(object):
      guard let str = object as? PyString else {
        return .typeError("Module origin must be a str, not \(object.typeName)")
      }

      return .value(str)

    case let .error(e):
      return .error(e)
    }
  }
}