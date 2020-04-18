import Core

// In CPython:
// Python -> traceback.c
// https://docs.python.org/3/library/traceback.html

// sourcery: pytype = traceback, default, hasGC
public class PyTraceback: PyObject {

  internal static let doc = """
    TracebackType(tb_next, tb_frame, tb_lasti, tb_lineno)
    --

    Create a new traceback object.
    """

  // MARK: - Init

  override internal init() {
    super.init(type: Py.types.traceback)
  }
}
