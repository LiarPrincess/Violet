// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// MARK: - Abstract

private enum StaticCallResult {
  case value(PyObject)
  case error(PyBaseException)
  /// Static call is not available
  case unavailable

  fileprivate init(_ value: PyResult<PyObject>?) {
    guard let v = value else {
      self = .unavailable
      return
    }

    switch v {
    case .value(let o):
      self = .value(o)
    case .error(let e):
      self = .error(e)
    }
  }
}

/// Basically a template for ternary operations (even though we have only one).
/// See `Py+Compare` for reasoning why we do it this way.
private protocol TernaryOp {

  /// Operator used to invoke given binary operation, for example '+'.
  /// Used for error messages.
  static var op: String { get }
  /// Operator used to invoke given binary operation, for example '+='.
  /// Used for error messages.
  static var inPlaceOp: String { get }

  /// Python selector, for example `__pow__`.
  static var selector: IdString { get }
  /// Python selector for reflected operation.
  /// For `__pow__` it is `__rpow__`.
  static var reflectedSelector: IdString { get }
  /// Python selector for in-place operation.
  /// For `__pow__` it is `__ipow__`.
  static var inPlaceSelector: IdString { get }

  /// Call op with fast protocol dispatch.
  static func callStatic(_ py: Py,
                         left: PyObject,
                         middle: PyObject,
                         right: PyObject) -> StaticCallResult
  /// Call reflected op with fast protocol dispatch.
  /// For `__pow__` it should call `__rpow__`.
  static func callStaticReflected(_ py: Py,
                                  left: PyObject,
                                  middle: PyObject,
                                  right: PyObject) -> StaticCallResult
  /// Call in-place op with fast protocol dispatch.
  /// For `__pow__` it should call `__ipow__`.
  static func callStaticInPlace(_ py: Py,
                                left: PyObject,
                                middle: PyObject,
                                right: PyObject) -> StaticCallResult
}

extension TernaryOp {

  // MARK: Call

  fileprivate static func call(_ py: Py,
                               left: PyObject,
                               middle: PyObject,
                               right: PyObject) -> PyResult<PyObject> {
    switch self.callInner(py, left: left, middle: middle, right: right) {
    case let .value(result):
      if py.cast.isNotImplemented(result) {
        let message = "unsupported operand type(s) for \(op): " +
          "\(left.typeName), \(middle.typeName) and \(right.typeName)"
        return .typeError(py, message: message)
      }

      return .value(result)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: Call in place

  fileprivate static func callInPlace(_ py: Py,
                                      left: PyObject,
                                      middle: PyObject,
                                      right: PyObject) -> PyResult<PyObject> {
    switch self.callInPlaceOp(py, left: left, middle: middle, right: right) {
    case let .value(result):
      if py.cast.isNotImplemented(result) {
        break // try other options
      }

      return .value(result)

    case let .error(e):
      return .error(e)
    }

    // Try standard operation, for example '**'
    switch self.callInner(py, left: left, middle: middle, right: right) {
    case let .value(result):
      if py.cast.isNotImplemented(result) {
        let message = "unsupported operand type(s) for \(inPlaceOp): " +
          "\(left.typeName), \(middle.typeName) and \(right.typeName)"
        return .typeError(py, message: message)
      }

      return .value(result)

    case let .error(e):
      return .error(e)
    }
  }

  /// Standard operation call.
  /// Basically code shared between normal and in-place call.
  fileprivate static func callInner(_ py: Py,
                                    left: PyObject,
                                    middle: PyObject,
                                    right: PyObject) -> PyResult<PyObject> {
    var checkedReflected = false

    // Check if middle is subtype of left, if so then use middle.
    if left.type !== middle.type && middle.type.isSubtype(of: left.type) {
      checkedReflected = true

      switch self.callReflectedOp(py, left: left, middle: middle, right: right) {
      case .value(let result):
        if py.cast.isNotImplemented(result) {
          break // try other options
        }
        return .value(result)
      case .error(let e):
        return .error(e)
      }
    }

    // Try left `op` middle, right (default path)
    switch self.callOp(py, left: left, middle: middle, right: right) {
    case .value(let result):
      if py.cast.isNotImplemented(result) {
        break // try other options
      }
      return .value(result)
    case .error(let e):
      return .error(e)
    }

    // Try reflected on middle
    if !checkedReflected {
      switch self.callReflectedOp(py, left: left, middle: middle, right: right) {
      case .value(let result):
        if py.cast.isNotImplemented(result) {
          break // try other options
        }
        return .value(result)
      case .error(let e):
        return .error(e)
      }
    }

    // No hope left! We are doomed!
    return .notImplemented(py)
  }

  // MARK: Call op

  private static func callOp(_ py: Py,
                             left: PyObject,
                             middle: PyObject,
                             right: PyObject) -> PyResult<PyObject> {
    // Fast path: we know the method at compile time
    switch self.callStatic(py, left: left, middle: middle, right: right) {
    case .value(let result):
      return .value(result)
    case .unavailable:
      break // Try normal/slow path…
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    switch py.callMethod(object: left, selector: selector, args: [middle, right]) {
    case .value(let result):
      return .value(result)
    case .missingMethod:
      return .notImplemented(py)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  private static func callReflectedOp(_ py: Py,
                                      left: PyObject,
                                      middle: PyObject,
                                      right: PyObject) -> PyResult<PyObject> {
    // Fast path: we know the method at compile time
    switch self.callStaticReflected(py, left: left, middle: middle, right: right) {
    case .value(let result):
      return .value(result)
    case .unavailable:
      break // Try other options…
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    switch py.callMethod(object: middle, selector: reflectedSelector, args: [left, right]) {
    case .value(let result):
      return .value(result)
    case .missingMethod:
      return .notImplemented(py)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  private static func callInPlaceOp(_ py: Py,
                                    left: PyObject,
                                    middle: PyObject,
                                    right: PyObject) -> PyResult<PyObject> {
    // Fast path: we know the method at compile time
    switch self.callStaticInPlace(py, left: left, middle: middle, right: right) {
    case .value(let result):
      return .value(result)
    case .unavailable:
      break // Try normal/slow path…
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    let args = [middle, right]
    switch py.callMethod(object: left, selector: inPlaceSelector, args: args) {
    case .value(let result):
      return .value(result)
    case .missingMethod:
      return .notImplemented(py)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }
}

// MARK: - Pow

private enum PowOp: TernaryOp {

  fileprivate static var op = "** or pow()"
  fileprivate static var inPlaceOp = "**="

  fileprivate static var selector = IdString.__pow__
  fileprivate static var reflectedSelector = IdString.__rpow__
  fileprivate static var inPlaceSelector = IdString.__ipow__

  fileprivate static func callStatic(_ py: Py,
                                     left: PyObject,
                                     middle: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__pow__(py, base: left, exp: middle, mod: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(_ py: Py,
                                              left: PyObject,
                                              middle: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rpow__(py, base: middle, exp: left, mod: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(_ py: Py,
                                            left: PyObject,
                                            middle: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__ipow__(py, base: left, exp: middle, mod: right)
    return StaticCallResult(result)
  }
}

extension Py {

  /// pow(base, exp[, mod])
  /// See [this](https://docs.python.org/3/library/functions.html#pow)
  ///
  /// PyObject *
  /// PyNumber_Power(PyObject *v, PyObject *w, PyObject *z)
  public func pow(base: PyObject,
                  exp: PyObject,
                  mod: PyObject? = nil) -> PyResult<PyObject> {
    let mod = mod ?? self.none.asObject
    return PowOp.call(self, left: base, middle: exp, right: mod)
  }

  public func powInPlace(base: PyObject,
                         exp: PyObject,
                         mod: PyObject? = nil) -> PyResult<PyObject> {
    let mod = mod ?? self.none.asObject
    return PowOp.callInPlace(self, left: base, middle: exp, right: mod)
  }
}
