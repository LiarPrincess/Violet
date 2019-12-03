import Foundation
import Core

extension PyContext {

  /// int PyObject_Print(PyObject *op, FILE *fp, int flags)
  public func print(value: PyObject,
                    file: FileHandle,
                    raw: Bool) -> PyResult<()> {
    // TODO: OutputStream
    let stringRaw = raw ? self.builtins.strValue(value) : self.builtins.repr(value)

    let string: String
    switch stringRaw {
    case let .value(s): string = s
    case let .error(e): return .error(e)
    }

    let data = Data(string.utf8)
    file.write(data)
    return .value()
  }
}
