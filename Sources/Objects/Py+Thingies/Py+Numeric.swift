// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension PyInstance {

  // MARK: - Round

  /// round(number[, ndigits])
  /// See [this](https://docs.python.org/3/library/functions.html#round)
  public func round(number: PyObject,
                    nDigits: PyObject? = nil) -> PyResult<PyObject> {
    if let owner = number as? __round__Owner {
      return owner.round(nDigits: nDigits)
    }

    let args = self.get__round__Args(nDigits: nDigits)

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

  private func get__round__Args(nDigits: PyObject?) -> [PyObject] {
    guard let nDigits = nDigits else {
      return []
    }

    if nDigits is PyNone {
      return []
    }

    return [nDigits]
  }
}
