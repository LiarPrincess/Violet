import BigInt
import VioletCore

/// Helper for dealing with `__index__` Python method.
internal enum IndexHelper {

  // MARK: - Int

  internal enum IntIndex {
    case value(Int)
    case overflow(BigInt, PyBaseException)
    case notIndex(PyBaseException)
    case error(PyBaseException)
  }

  // We model this as '(1 * 2) + (1 * 2)' instead of '2 * 2' (errorKind * message),
  // so that our users can just type '.overflowError' without parens.
  internal enum OnIntOverflow {
    case overflowError(msg: String?)
    case indexError(msg: String?)

    /// .default = .overflow
    internal static let `default` = OnIntOverflow.overflowError(msg: nil)
    internal static let overflowError = OnIntOverflow.overflowError(msg: nil)
    internal static let indexError = OnIntOverflow.indexError(msg: nil)
  }

  /// Try to extract `Int` index from `PyObject`.
  ///
  /// When object is not convertible to index it will return `.notIndex`.
  /// When index is out of range of `int` it will return `.overflow`.
  ///
  /// CPython:
  /// ```
  /// Py_ssize_t PyNumber_AsSsize_t(PyObject *item, PyObject *err)
  /// _PyEval_SliceIndexNotNone
  /// ```
  internal static func int(_ value: PyObject,
                           onOverflow: OnIntOverflow) -> IntIndex {
    let bigInt: BigInt
    switch Self.bigInt(value) {
    case .value(let v): bigInt = v
    case .notIndex(let i): return .notIndex(i)
    case .error(let e): return .error(e)
    }

    if let int = Int(exactly: bigInt) {
      return .value(int)
    }

    let e = Self.createOverflowError(object: value, type: onOverflow)
    return .overflow(bigInt, e)
  }

  private static func createOverflowError(object: PyObject,
                                          type: OnIntOverflow) -> PyBaseException {
    switch type {
    case let .overflowError(msg):
      let defaultMsg = "Python int too large to convert to Swift int"
      return Py.newOverflowError(msg: msg ?? defaultMsg)

    case let .indexError(msg):
      let typeName = object.typeName
      let defaultMsg = "cannot fit '\(typeName)' into an index-sized integer"
      return Py.newIndexError(msg: msg ?? defaultMsg)
    }
  }

  // MARK: - BigInt

  internal enum BigIntIndex {
    case value(BigInt)
    case notIndex(PyBaseException)
    case error(PyBaseException)
  }

  /// Try to extract `BigInt` index from `PyObject`.
  ///
  /// When object is not convertible to index it will return `.notIndex`.
  ///
  /// CPython:
  /// ```
  /// PyObject *
  /// PyNumber_Index(PyObject *item)
  /// ```
  internal static func bigInt(_ value: PyObject) -> BigIntIndex {
    if let int = PyCast.asInt(value) {
      return .value(int.value)
    }

    if let result = Fast.__index__(value) {
      return .value(result)
    }

    switch Py.callMethod(object: value, selector: .__index__) {
    case .value(let object):
      guard let int = PyCast.asInt(object) else {
        let msg = "__index__ returned non-int (type \(object.typeName)"
        return .error(Py.newTypeError(msg: msg))
      }

      let isExactlyIntNotSubclass = PyCast.isExactlyInt(int)
      let isSubclass = !isExactlyIntNotSubclass
      if isSubclass {
        let msg = "__index__ returned non-int (type \(int.typeName)).  " +
          "The ability to return an instance of a strict subclass of int " +
          "is deprecated, and may be removed in a future version of Python."

        if let e = Py.warn(type: .deprecation, msg: msg) {
          return .error(e)
        }
      }

      return .value(int.value)

    case .missingMethod:
      let typeName = value.typeName
      let msg = "'\(typeName)' object cannot be interpreted as an integer"
      return .notIndex(Py.newTypeError(msg: msg))

    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }
}
