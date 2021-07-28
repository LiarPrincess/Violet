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

  internal struct OnIntOverflow {
    // swiftlint:disable:next nesting
    fileprivate enum ErrorKind {
      case overflow
      case index
    }

    fileprivate let errorKind: ErrorKind
    fileprivate let msg: String?

    private init(errorKind: ErrorKind, msg: String?) {
      self.errorKind = errorKind
      self.msg = msg
    }

    internal static var overflowError = Self.overflowError(msg: nil)

    internal static func overflowError(msg: String?) -> OnIntOverflow {
      return OnIntOverflow(errorKind: .overflow, msg: msg)
    }

    internal static var indexError = Self.indexError(msg: nil)

    internal static func indexError(msg: String?) -> OnIntOverflow {
      return OnIntOverflow(errorKind: .index, msg: msg)
    }
  }

  /// Try to extract `Int` index from `PyObject`.
  ///
  /// When object is not convertible to index it will return `.notIndex`.
  /// When index is out of range of an `int` it will return `.overflow`.
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

    let e: PyBaseException = {
      let t = value.typeName
      let msg = onOverflow.msg ?? "cannot fit '\(t)' into an index-sized integer"

      switch onOverflow.errorKind {
      case .overflow: return Py.newOverflowError(msg: msg)
      case .index: return Py.newIndexError(msg: msg)
      }
    }()

    return .overflow(bigInt, e)
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

    if let result = PyStaticCall.__index__(value) {
      return .value(result)
    }

    switch Py.callMethod(object: value, selector: .__index__) {
    case .value(let object):
      guard let int = PyCast.asInt(object) else {
        let msg = "__index__ returned non-int (type \(object.typeName)"
        return .error(Py.newTypeError(msg: msg))
      }

      let isIntSubclass = !PyCast.isExactlyInt(int)
      if isIntSubclass {
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
