import Foundation
import Core

extension PyContext {

  /// int PyObject_Print(PyObject *op, FILE *fp, int flags)
  public func print(value: PyObject,
                    file: FileHandle,
                    raw: Bool) -> PyResult<()> {
    // TODO: OutputStream
    let string: String

    if raw {
      string = self._str(value: value)
    } else {
      switch self.builtins.repr(value) {
      case let .value(s): string = s
      case let .error(e): return .error(e)
      }
    }

    let data = Data(string.utf8)
    file.write(data)

    return .value()
  }
}
