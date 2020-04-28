// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// MARK: - Abstract

private enum FastCallResult {
  case value(PyObject)
  case error(PyBaseException)
  /// Fast call is not available
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

  /// Python selector, for example `__pow__`.
  static var selector: IdString { get }
  /// Python selector for reflected operation.
  /// For `__pow__` it is `__rpow__`.
  static var reflectedSelector: IdString { get }

  /// Call op with fast protocol dispatch.
  static func callFastOp(left: PyObject,
                         middle: PyObject,
                         right: PyObject) -> FastCallResult
  /// Call reflected op with fast protocol dispatch.
  /// For `__pow__` it should call `__rpow__`.
  static func callFastReflected(left: PyObject,
                                middle: PyObject,
                                right: PyObject) -> FastCallResult
}

extension TernaryOp {

  fileprivate static func call(left: PyObject,
                               middle: PyObject,
                               right: PyObject) -> PyResult<PyObject> {
    var checkedReflected = false

    // Check if middle is subtype of left, if so then use middle.
    if left.type !== middle.type && middle.type.isSubtype(of: left.type) {
      checkedReflected = true

      switch self.callReflected(left: left, middle: middle, right: right) {
      case .value(let result):
        if result.isNotImplemented {
          break // try other options
        }
        return .value(result)
      case .error(let e):
        return .error(e)
      }
    }

    // Try left `op` middle, right (default path)
    switch self.callOp(left: left, middle: middle, right: right) {
    case .value(let result):
      if result.isNotImplemented {
        break // try other options
      }
      return .value(result)
    case .error(let e):
      return .error(e)
    }

    // Try reflected on middle
    if !checkedReflected {
      switch self.callReflected(left: left, middle: middle, right: right) {
      case .value(let result):
        if result.isNotImplemented {
          break // try other options
        }
        return .value(result)
      case .error(let e):
        return .error(e)
      }
    }

    // No hope left! We are doomed!
    let operands = "\(left.typeName), \(middle.typeName) and \(right.typeName)"
    return .typeError("unsupported operand type(s) for \(op): \(operands).")
  }

  private static func callOp(left: PyObject,
                             middle: PyObject,
                             right: PyObject) -> PyResult<PyObject> {
    // Try fast protocol-based dispach
    switch callFastOp(left: left, middle: middle, right: right) {
    case .value(let result):
      return .value(result)
    case .unavailable:
      break // Try normal/slow path...
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    switch Py.callMethod(object: left, selector: selector, args: [middle, right]) {
    case .value(let result):
      return .value(result)
    case .missingMethod:
      return .value(Py.notImplemented)
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  private static func callReflected(left: PyObject,
                                    middle: PyObject,
                                    right: PyObject) -> PyResult<PyObject> {
    // Try fast protocol-based dispach
    switch callFastReflected(left: left, middle: middle, right: right) {
    case .value(let result):
      return .value(result)
    case .unavailable:
      break // Try other options...
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    switch Py.callMethod(object: middle, selector: reflectedSelector, args: [left, right]) {
    case .value(let result):
      return .value(result)
    case .missingMethod:
      return .value(Py.notImplemented)
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }
}

// MARK: - Pow

private enum PowOp: TernaryOp {
  fileprivate static var op = "** or pow()"
  fileprivate static var selector = IdString.__pow__
  fileprivate static var reflectedSelector = IdString.__rpow__

  fileprivate static func callFastOp(left: PyObject,
                                     middle: PyObject,
                                     right: PyObject) -> FastCallResult {
    let result = Fast.__pow__(left, exp: middle, mod: right)
    return FastCallResult(result)
  }

  fileprivate static func callFastReflected(left: PyObject,
                                            middle: PyObject,
                                            right: PyObject) -> FastCallResult {
    let result = Fast.__rpow__(middle, base: left, mod: right)
    return FastCallResult(result)
  }
}

extension PyInstance {

  /// pow(base, exp[, mod])
  /// See [this](https://docs.python.org/3/library/functions.html#pow)
  public func pow(base: PyObject,
                  exp: PyObject,
                  mod: PyObject? = nil) -> PyResult<PyObject> {
    let mod = mod ?? self.none
    return PowOp.call(left: base, middle: exp, right: mod)
  }

  public func powInPlace(base: PyObject,
                         exp: PyObject,
                         mod: PyObject? = nil) -> PyResult<PyObject> {
    return self.pow(base: base, exp: exp, mod: mod)
  }
}
