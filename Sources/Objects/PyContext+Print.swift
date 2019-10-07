import Foundation
import Core

extension PyContext {

  /// int PyObject_Print(PyObject *op, FILE *fp, int flags)
  public func print(value: PyObject, file: FileHandle, raw: Bool) throws {
    let string = raw ?
      self.strString(value: value) :
      self.reprString(value: value)

    let data = Data(string.utf8)
    file.write(data)
  }
}
