// In CPython:
// Python -> _warnings.c
// https://docs.python.org/3/library/warnings.html

// swiftlint:disable nesting

extension UnderscoreWarnings {

  // MARK: - Registry

  public enum WarningRegistry {
    case dict(PyDict)
    /// Python `None`, not `nil` from `Swift.Optional`.
    case none
  }

  // MARK: - Warning

  internal struct Warning {
    /// Message as passed by the user.
    ///
    /// It may be `str`, or `Warning` subclass or anything else.
    internal let message: PyObject
    /// Text to print.
    ///
    /// Most of the time (but not always) it will be something similar
    /// to `str(self.message)`.
    internal let text: PyObject
    internal let category: PyType
    internal let filename: PyString
    internal let lineNo: PyInt
    internal let module: PyString
    internal let source: PyObject?
  }

  // swiftlint:disable function_parameter_count

  /// In CPython this is a part of:
  /// static PyObject *
  /// warn_explicit(PyObject *category, PyObject *message,
  internal func createWarning(message messageArg: PyObject,
                              category categoryArg: PyType,
                              filename: PyString,
                              lineNo: PyInt,
                              module moduleArg: PyString?,
                              source: PyObject?) -> PyResult<Warning> {
    // swiftlint:enable function_parameter_count

    let text: PyObject
    let message: PyObject
    let category: PyType

    let messageIsWarning = self.isWarningSubtype(type: messageArg.type)
    if messageIsWarning {
      // 'message' is 'Warning' subclass, as a 'text' we will just use 'str(message)'
      switch Py.types.str.call(args: [messageArg], kwargs: nil) {
      case let .value(t): text = t
      case let .error(e): return .error(e)
      }

      message = messageArg
      category = messageArg.type
    } else {
      // 'message' is probably 'str', we will just display it: 'text' = 'message'
      // 'category' is probably warning type -> 'message' = its instance
      text = messageArg

      switch Py.call(callable: categoryArg, arg: messageArg) {
      case let .value(m):
        message = m
      case let .notCallable(e),
           let .error(e):
        return .error(e)
      }

      category = categoryArg
    }

    let module = moduleArg ?? self.createModuleName(filename: filename)

    let result = Warning(
      message: message,
      text: text,
      category: category,
      filename: filename,
      lineNo: lineNo,
      module: module,
      source: source
    )

    return .value(result)
  }

  /// static PyObject *
  /// normalize_module(PyObject *filename)
  private func createModuleName(filename: PyString) -> PyString {
    if filename.isEmpty {
      return Py.intern(string: "<unknown>")
    }

    if filename.value.hasSuffix(".py") {
      let module = String(filename.value.dropLast(3))
      return Py.intern(string: module)
    }

    return filename
  }

  // MARK: - Filter

  internal struct Filter {

    /// What to do with this warning.
    internal let action: Action
    /// What to do with this warning.
    internal let actionObject: PyString
    /// Filter object (tuple with 5 elements).
    internal let object: Object

    internal enum Action: Equatable {
      /// Print the first occurrence of matching warnings for each location
      /// (module + line number) where the warning is issued
      case `default`
      /// Turn matching warnings into exceptions
      case error
      /// Never print matching warnings
      case ignore
      /// Always print matching warnings
      case always
      /// Print the first occurrence of matching warnings for each module
      /// where the warning is issued (regardless of line number)
      case module
      /// Print only the first occurrence of matching warnings, regardless of location
      case once
      /// Some other value
      case other
    }

    internal enum Object {
      case value(PyTuple)
      /// Python `None`, not `nil` from `Swift.Optional`.
      case none

      internal var py: PyObject {
        switch self {
        case .value(let t): return t
        case .none: return Py.none
        }
      }
    }

    internal init(action: PyString, object: Object) {
      // This should be detected before calling 'init'
      switch object {
      case .value(let tuple): assert(tuple.elements.count == 5)
      case .none: break
      }

      self.actionObject = action
      self.object = object

      self.action = {
        if action.isEqual("default") { return .default }
        if action.isEqual("error") { return .error }
        if action.isEqual("ignore") { return .ignore }
        if action.isEqual("always") { return .always }
        if action.isEqual("module") { return .module }
        if action.isEqual("once") { return .once }
        return .other
      }()
    }
  }
}
