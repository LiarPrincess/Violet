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
  static func callStatic(left: PyObject,
                         middle: PyObject,
                         right: PyObject) -> StaticCallResult
  /// Call reflected op with fast protocol dispatch.
  /// For `__pow__` it should call `__rpow__`.
  static func callStaticReflected(left: PyObject,
                                  middle: PyObject,
                                  right: PyObject) -> StaticCallResult
  /// Call in-place op with fast protocol dispatch.
  /// For `__pow__` it should call `__ipow__`.
  static func callStaticInPlace(left: PyObject,
                                middle: PyObject,
                                right: PyObject) -> StaticCallResult
}

extension TernaryOp {

  // MARK: Call

  fileprivate static func call(left: PyObject,
                               middle: PyObject,
                               right: PyObject) -> PyResult<PyObject> {
    switch self.callInner(left: left, middle: middle, right: right) {
    case let .value(result):
      if PyCast.isNotImplemented(result) {
        let msg = "unsupported operand type(s) for \(op): " +
          "\(left.typeName), \(middle.typeName) and \(right.typeName)"
        return .typeError(msg)
      }

      return .value(result)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: Call in place

  fileprivate static func callInPlace(left: PyObject,
                                      middle: PyObject,
                                      right: PyObject) -> PyResult<PyObject> {
    switch self.callInPlaceOp(left: left, middle: middle, right: right) {
    case let .value(result):
      if PyCast.isNotImplemented(result) {
        break // try other options
      }

      return .value(result)

    case let .error(e):
      return .error(e)
    }

    // Try standard operation, for example '**'
    switch self.callInner(left: left, middle: middle, right: right) {
    case let .value(result):
      if PyCast.isNotImplemented(result) {
        let msg = "unsupported operand type(s) for \(inPlaceOp): " +
          "\(left.typeName), \(middle.typeName) and \(right.typeName)"
        return .typeError(msg)
      }

      return .value(result)

    case let .error(e):
      return .error(e)
    }
  }

  /// Standard operation call.
  /// Basically code shared between normal and in-place call.
  fileprivate static func callInner(left: PyObject,
                                    middle: PyObject,
                                    right: PyObject) -> PyResult<PyObject> {
    var checkedReflected = false

    // Check if middle is subtype of left, if so then use middle.
    if left.type !== middle.type && middle.type.isSubtype(of: left.type) {
      checkedReflected = true

      switch self.callReflectedOp(left: left, middle: middle, right: right) {
      case .value(let result):
        if PyCast.isNotImplemented(result) {
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
      if PyCast.isNotImplemented(result) {
        break // try other options
      }
      return .value(result)
    case .error(let e):
      return .error(e)
    }

    // Try reflected on middle
    if !checkedReflected {
      switch self.callReflectedOp(left: left, middle: middle, right: right) {
      case .value(let result):
        if PyCast.isNotImplemented(result) {
          break // try other options
        }
        return .value(result)
      case .error(let e):
        return .error(e)
      }
    }

    // No hope left! We are doomed!
    return .value(Py.notImplemented)
  }

  // MARK: Call op

  private static func callOp(left: PyObject,
                             middle: PyObject,
                             right: PyObject) -> PyResult<PyObject> {
    // Fast path: we know the method at compile time
    switch self.callStatic(left: left, middle: middle, right: right) {
    case .value(let result):
      return .value(result)
    case .unavailable:
      break // Try normal/slow path…
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    switch Py.callMethod(object: left, selector: selector, args: [middle, right]) {
    case .value(let result):
      return .value(result)
    case .missingMethod:
      return .value(Py.notImplemented)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  private static func callReflectedOp(left: PyObject,
                                      middle: PyObject,
                                      right: PyObject) -> PyResult<PyObject> {
    // Fast path: we know the method at compile time
    switch self.callStaticReflected(left: left, middle: middle, right: right) {
    case .value(let result):
      return .value(result)
    case .unavailable:
      break // Try other options…
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    switch Py.callMethod(object: middle, selector: reflectedSelector, args: [left, right]) {
    case .value(let result):
      return .value(result)
    case .missingMethod:
      return .value(Py.notImplemented)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  private static func callInPlaceOp(left: PyObject,
                                    middle: PyObject,
                                    right: PyObject) -> PyResult<PyObject> {
    // Fast path: we know the method at compile time
    switch self.callStaticInPlace(left: left, middle: middle, right: right) {
    case .value(let result):
      return .value(result)
    case .unavailable:
      break // Try normal/slow path…
    case .error(let e):
      return .error(e)
    }

    // Try standard Python dispatch
    let args = [middle, right]
    switch Py.callMethod(object: left, selector: inPlaceSelector, args: args) {
    case .value(let result):
      return .value(result)
    case .missingMethod:
      return .value(Py.notImplemented)
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

  fileprivate static func callStatic(left: PyObject,
                                     middle: PyObject,
                                     right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__pow__(base: left, exp: middle, mod: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticReflected(left: PyObject,
                                              middle: PyObject,
                                              right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__rpow__(base: middle, exp: left, mod: right)
    return StaticCallResult(result)
  }

  fileprivate static func callStaticInPlace(left: PyObject,
                                            middle: PyObject,
                                            right: PyObject) -> StaticCallResult {
    let result = PyStaticCall.__ipow__(base: left, exp: middle, mod: right)
    return StaticCallResult(result)
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
    let mod = mod ?? self.none
    return PowOp.callInPlace(left: base, middle: exp, right: mod)
  }
}
