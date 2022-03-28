import BigInt
import VioletCore

// swiftlint:disable nesting

/// Helper for dealing with `__index__` Python method.
internal enum IndexHelper {

  // MARK: - Int

  internal enum IntIndex {
    case value(Int)
    case overflow(PyInt, LazyIntOverflowError)
    case notIndex(LazyNotIndexError)
    case error(PyBaseException)
  }

  internal struct OnIntOverflow {
    fileprivate enum ErrorKind {
      case overflow
      case index
    }

    fileprivate let errorKind: ErrorKind
    fileprivate let message: String?

    private init(errorKind: ErrorKind, message: String?) {
      self.errorKind = errorKind
      self.message = message
    }

    internal static var overflowError = Self.overflowError(message: nil)

    internal static func overflowError(message: String?) -> OnIntOverflow {
      return OnIntOverflow(errorKind: .overflow, message: message)
    }

    internal static var indexError = Self.indexError(message: nil)

    internal static func indexError(message: String?) -> OnIntOverflow {
      return OnIntOverflow(errorKind: .index, message: message)
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
    private let message: Message

    fileprivate init(convertedObject: PyObject, onOverflow: OnIntOverflow) {
      if let message = onOverflow.message {
        self.message = .string(value: message)
      } else {
        self.message = .generic(typeName: convertedObject.typeName)
      }

      self.errorKind = onOverflow.errorKind
    }

    internal func create(_ py: Py) -> PyBaseException {
      let message: String = {
        switch self.message {
        case let .generic(typeName: typeName):
          return "cannot fit '\(typeName)' into an index-sized integer"
        case let .string(value: s):
          return s
        }
      }()

      switch self.errorKind {
      case .overflow:
        let error = py.newOverflowError(message: message)
        return error.asBaseException
      case .index:
        let error = py.newIndexError(message: message)
        return error.asBaseException
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
  internal static func int(_ py: Py,
                           object: PyObject,
                           onOverflow: OnIntOverflow) -> IntIndex {
    let pyInt: PyInt
    switch Self.pyInt(py, object: object) {
    case .value(let i): pyInt = i
    case .notIndex(let i): return .notIndex(i)
    case .error(let e): return .error(e)
    }

    if let int = Int(exactly: pyInt.value) {
      return .value(int)
    }

    let e = LazyIntOverflowError(convertedObject: object, onOverflow: onOverflow)
    return .overflow(pyInt, e)
  }

  // MARK: - PyInt

  internal enum PyIntIndex {
    case value(PyInt)
    case notIndex(LazyNotIndexError)
    case error(PyBaseException)
  }

  /// Wrapper type error to avoid an actual error object allocation
  /// if this is not needed.
  internal struct LazyNotIndexError {
    fileprivate let typeName: String

    internal func create(_ py: Py) -> PyBaseException {
      let message = "'\(typeName)' object cannot be interpreted as an integer"
      let error = py.newTypeError(message: message)
      return error.asBaseException
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
  internal static func pyInt(_ py: Py, object: PyObject) -> PyIntIndex {
    if let int = py.cast.asExactlyInt(object) {
      return .value(int)
    }

    if let result = PyStaticCall.__index__(py, object: object) {
      switch result {
      case let .value(o): return Self.interpret__index__(py, object: o)
      case let .error(e): return .error(e)
      }
    }

    switch py.callMethod(object: object, selector: .__index__) {
    case .value(let o):
      return Self.interpret__index__(py, object: o)
    case .missingMethod:
      let e = LazyNotIndexError(typeName: object.typeName)
      return .notIndex(e)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  private static func interpret__index__(_ py: Py, object: PyObject) -> PyIntIndex {
    guard let int = py.cast.asInt(object) else {
      let message = "__index__ returned non-int (type \(object.typeName)"
      let error = py.newTypeError(message: message)
      return .error(error.asBaseException)
    }

    let isIntSubclass = !py.cast.isExactlyInt(int.asObject)
    if isIntSubclass {
      let message = "__index__ returned non-int (type \(int.typeName)).  " +
        "The ability to return an instance of a strict subclass of int " +
        "is deprecated, and may be removed in a future version of Python."

      if let e = py.warn(type: .deprecation, message: message) {
        return .error(e)
      }
    }

    return .value(int)
  }
}
