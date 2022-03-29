import Foundation
import BigInt
import VioletCore

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Py {

  // MARK: - Int

  public func newInt<I: BinaryInteger>(_ value: I) -> PyInt {
    let big = BigInt(value)
    return self.newInt(big)
  }

  public func newInt(_ value: Int) -> PyInt {
    if let interned = self.getInterned(int: value) {
      return interned
    }

    let big = BigInt(value)
    let type = self.types.int
    return self.memory.newInt(type: type, value: big)
  }

  public func newInt(_ value: BigInt) -> PyInt {
    if let interned = self.getInterned(int: value) {
      return interned
    }

    let type = self.types.int
    return self.memory.newInt(type: type, value: value)
  }

  /// PyObject *
  /// PyLong_FromDouble(double dval)
  public func newInt(double value: Double) -> PyResultGen<PyInt> {
    if value.isInfinite {
      return .overflowError(self, message: "cannot convert float infinity to integer")
    }

    if value.isNaN {
      return .valueError(self, message: "cannot convert float NaN to integer")
    }

    if let int = BigInt(exactly: value) {
      return .value(self.newInt(int))
    }

    return .valueError(self, message: "cannot convert \(value) to integer")
  }

  // MARK: - Float

  public func newFloat(_ value: Double) -> PyFloat {
    let type = self.types.float
    return self.memory.newFloat(type: type, value: value)
  }

  // MARK: - Complex

  public func newComplex(real: Double, imag: Double) -> PyComplex {
    let type = self.types.complex
    return self.memory.newComplex(type: type, real: real, imag: imag)
  }

  // MARK: - Round

  /// round(number[, ndigits])
  /// See [this](https://docs.python.org/3/library/functions.html#round)
  public func round(number: PyObject, nDigits: PyObject? = nil) -> PyResult {
    let nDigits = self.cast.isNilOrNone(nDigits) ? nil : nDigits

    if let result = PyStaticCall.__round__(self, object: number, nDigits: nDigits) {
      return result
    }

    let args: [PyObject] = {
      guard let n = nDigits else {
        return []
      }

      return [n]
    }()

    let result = self.callMethod(object: number, selector: .__round__, args: args)
    switch result {
    case .value(let o):
      return .value(o)
    case .missingMethod:
      let message = "type \(number.typeName) doesn't define __round__ method"
      return .typeError(self, message: message)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }
}
