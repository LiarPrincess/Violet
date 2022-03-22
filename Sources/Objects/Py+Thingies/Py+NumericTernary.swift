// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Py {

  /// pow(base, exp[, mod])
  /// See [this](https://docs.python.org/3/library/functions.html#pow)
  ///
  /// PyObject *
  /// PyNumber_Power(PyObject *v, PyObject *w, PyObject *z)
  public func pow(base: PyObject,
                  exp: PyObject,
                  mod: PyObject? = nil) -> PyResult {
    let _mod = mod ?? self.none.asObject

    switch self.callCommon(left: base, middle: exp, right: _mod) {
    case let .value(result):
      if self.cast.isNotImplemented(result) {
        let op = self.cast.isNone(_mod) ? "** or pow()" : "pow()"
        let message = self.createErrorMessage(op: op, base: base, exp: exp, mod: _mod)
        return .typeError(self, message: message)
      }

      return .value(result)
    case let .error(e):
      return .error(e)
    }
  }

  public func powInPlace(base: PyObject,
                         exp: PyObject,
                         mod: PyObject? = nil) -> PyResult {
    let _mod = mod ?? self.none.asObject

    switch self.callInPlaceOp(base: base, exp: exp, mod: _mod) {
    case let .value(result):
      if self.cast.isNotImplemented(result) {
        break // try other options
      }
      return .value(result)

    case let .error(e):
      return .error(e)
    }

    // Try standard operation, for example '**'
    switch self.callCommon(left: base, middle: exp, right: _mod) {
    case let .value(result):
      if self.cast.isNotImplemented(result) {
        let message = self.createErrorMessage(op: "**=", base: base, exp: exp, mod: _mod)
        return .typeError(self, message: message)
      }

      return .value(result)

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Common

  /// Standard operation call.
  /// Basically code shared between normal and in-place call.
  private func callCommon(left: PyObject,
                          middle: PyObject,
                          right: PyObject) -> PyResult {
    var checkedReflected = false

    // Check if middle is subtype of left, if so then use middle.
    if left.type !== middle.type && middle.type.isSubtype(of: left.type) {
      checkedReflected = true

      switch self.callReflectedOp(exp: left, base: middle, mod: right) {
      case .value(let result):
        if self.cast.isNotImplemented(result) {
          break // try other options
        }
        return .value(result)
      case .error(let e):
        return .error(e)
      }
    }

    // Try left `op` middle, right (default path)
    switch self.callOp(base: left, exp: middle, mod: right) {
    case .value(let result):
      if self.cast.isNotImplemented(result) {
        break // try other options
      }
      return .value(result)
    case .error(let e):
      return .error(e)
    }

    // Try reflected on middle
    if !checkedReflected {
      switch self.callReflectedOp(exp: left, base: middle, mod: right) {
      case .value(let result):
        if self.cast.isNotImplemented(result) {
          break // try other options
        }
        return .value(result)
      case .error(let e):
        return .error(e)
      }
    }

    // No hope left! We are doomed!
    return .notImplemented(self)
  }

  private func createErrorMessage(op: String,
                                  base: PyObject,
                                  exp: PyObject,
                                  mod: PyObject) -> String {
    var result = "unsupported operand type(s) for \(op): '\(base.typeName)'"

    if self.cast.isNone(mod) {
      result.append(" and '\(exp.typeName)'")
    } else {
      result.append(", '\(exp.typeName)', '\(mod.typeName)'")
    }

    return result
  }

  // MARK: - Call

  private func callOp(base: PyObject,
                      exp: PyObject,
                      mod: PyObject) -> PyResult {
    // Fast path: we know the method at compile time
    if let result = PyStaticCall.__pow__(self, base: base, exp: exp, mod: mod) {
      return result
    }

    // Try standard Python dispatch
    switch self.callMethod(object: base, selector: .__pow__, args: [exp, mod]) {
    case .value(let result):
      return .value(result)
    case .missingMethod:
      return .notImplemented(self)
    case .error(let e),
        .notCallable(let e):
      return .error(e)
    }
  }

  private func callReflectedOp(exp: PyObject,
                               base: PyObject,
                               mod: PyObject) -> PyResult {
    // Fast path: we know the method at compile time
    if let result = PyStaticCall.__rpow__(self, base: base, exp: exp, mod: mod) {
      return result
    }

    // Try standard Python dispatch
    switch self.callMethod(object: base, selector: .__rpow__, args: [exp, mod]) {
    case .value(let result):
      return .value(result)
    case .missingMethod:
      return .notImplemented(self)
    case .error(let e),
        .notCallable(let e):
      return .error(e)
    }
  }

  private func callInPlaceOp(base: PyObject,
                             exp: PyObject,
                             mod: PyObject) -> PyResult {
    // Fast path: we know the method at compile time
    if let result = PyStaticCall.__ipow__(self, base: base, exp: exp, mod: mod) {
      return result
    }

    // Try standard Python dispatch
    switch self.callMethod(object: base, selector: .__ipow__, args: [exp, mod]) {
    case .value(let result):
      return .value(result)
    case .missingMethod:
      return .notImplemented(self)
    case .error(let e),
        .notCallable(let e):
      return .error(e)
    }
  }
}
