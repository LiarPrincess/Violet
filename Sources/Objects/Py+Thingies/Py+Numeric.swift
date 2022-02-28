/* MARKER
// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension PyInstance {

  // MARK: - Round

  /// round(number[, ndigits])
  /// See [this](https://docs.python.org/3/library/functions.html#round)
  public func round(number: PyObject,
                    nDigits: PyObject? = nil) -> PyResult<PyObject> {
    let nDigits = PyCast.isNilOrNone(nDigits) ? nil : nDigits

    if let result = PyStaticCall.__round__(number, nDigits: nDigits) {
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
      let msg = "type \(number.typeName) doesn't define __round__ method"
      return .typeError(msg)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }
}

*/