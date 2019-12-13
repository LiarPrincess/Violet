import Foundation

extension Builtins {

  internal var stdout: StandardOutput {
    return self.context.stdout
  }

  public func print(value: PyObject, raw: Bool) -> PyResult<PyNone> {
    let stringResult = raw ? self.strValue(value) : self.repr(value)
    switch stringResult {
    case let .value(s):
      self.stdout.write(s)
      return .value(self.none)
    case let .error(e):
      return .error(e)
    }
  }
}
