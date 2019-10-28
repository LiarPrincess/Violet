import Foundation
import Core

extension PyContext {

  /// int PyObject_Print(PyObject *op, FILE *fp, int flags)
  public func print(value: PyObject, file: FileHandle, raw: Bool) throws {
    // TODO: OutputStream
    let string = raw ?
      self._str(value: value) :
      self._repr(value: value)

    let data = Data(string.utf8)
    file.write(data)
  }
}
