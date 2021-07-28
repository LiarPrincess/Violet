import BigInt
import VioletCore

// swiftlint:disable nesting

/// Helper for dealing with `__index__` Python method.
internal enum IndexHelper {

  // MARK: - Int

  internal enum IntIndex {
    case value(Int)
    case overflow(BigInt, LazyIntOverflowError)
    case notIndex(LazyNotIndexError)
    case error(PyBaseException)
  }

  internal struct OnIntOverflow {
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

  /// Wrapper for Int overflow error to avoid an actual error object allocation
  /// if this is not needed.
  internal struct LazyIntOverflowError {
    private enum Message {
      case string(value: String)
      case generic(typeName: String)
    }

    private let errorKind: OnIntOverflow.ErrorKind
    private let msg: Message

    fileprivate init(convertedObject: PyObject, onOverflow: OnIntOverflow) {
      if let msg = onOverflow.msg {
        self.msg = .string(value: msg)
      } else {
        self.msg = .generic(typeName: convertedObject.typeName)
      }

      self.errorKind = onOverflow.errorKind
    }

    internal func create() -> PyBaseException {
      let msg: String = {
        switch self.msg {
        case let .generic(typeName: typeName):
          return "cannot fit '\(typeName)' into an index-sized integer"
        case let .string(value: s):
          return s
        }
      }()

      switch self.errorKind {
      case .overflow: return Py.newOverflowError(msg: msg)
      case .index: return Py.newIndexError(msg: msg)
      }
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
  internal static func int(_ object: PyObject,
                           onOverflow: OnIntOverflow) -> IntIndex {
    let bigInt: BigInt
    switch Self.bigInt(object) {
    case .value(let v): bigInt = v
    case .notIndex(let i): return .notIndex(i)
    case .error(let e): return .error(e)
    }

    if let int = Int(exactly: bigInt) {
      return .value(int)
    }

    let e = LazyIntOverflowError(convertedObject: object, onOverflow: onOverflow)
    return .overflow(bigInt, e)
  }

  // MARK: - BigInt

  internal enum BigIntIndex {
    case value(BigInt)
    case notIndex(LazyNotIndexError)
    case error(PyBaseException)
  }

  /// Wrapper type error to avoid an actual error object allocation
  /// if this is not needed.
  internal struct LazyNotIndexError {
    fileprivate let typeName: String

    internal func create() -> PyBaseException {
      let msg = "'\(typeName)' object cannot be interpreted as an integer"
      return Py.newTypeError(msg: msg)
    }
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
  internal static func bigInt(_ object: PyObject) -> BigIntIndex {
    if let int = PyCast.asInt(object) {
      return .value(int.value)
    }

    if let result = PyStaticCall.__index__(object) {
      return .value(result)
    }

    switch Py.callMethod(object: object, selector: .__index__) {
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
      let e = LazyNotIndexError(typeName: object.typeName)
      return .notIndex(e)

    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }
}
