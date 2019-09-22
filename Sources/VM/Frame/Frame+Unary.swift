import Bytecode
import Objects

extension Frame {

  /// Implements `TOS = +TOS`.
  internal func unaryPositive() throws {
    let value = self.top
    let result = self.numberType.positive(value)
    self.setTop(result)
  }

  /// Implements `TOS = -TOS`.
  internal func unaryNegative() throws {
    let value = self.top
    let result = self.numberType.negative(value)
    self.setTop(result)
  }

  /// Implements `TOS = not TOS`.
  internal func unaryNot() throws {
    let value = self.top
    switch self.PyObject_IsTrue(value) {
    case true:
      self.setTop(self.Py_False)
    case false:
      self.setTop(self.Py_True)
    }
    self.adjust(-1)
  }

  /// Implements `TOS = ~TOS`.
  internal func unaryInvert() throws {
    let value = self.top
    let result = self.numberType.invert(value)
    self.setTop(result)
  }
}
