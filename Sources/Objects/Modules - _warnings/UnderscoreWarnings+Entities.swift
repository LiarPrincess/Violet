// In CPython:
// Python -> _warnings.c
// https://docs.python.org/3/library/warnings.html

// swiftlint:disable nesting

extension UnderscoreWarnings {

  // MARK: - Registry

  internal enum WarningRegistry {
    case value(PyDict)
    /// Python `None`, not `nil` from `Swift.Optional`.
    case none
  }

  // MARK: - Warning

  internal struct Warning {
    /// Message as passed by the user
    let message: PyObject
    /// Text to print (most of the time it will be `str(self.message)`)
    let text: PyObject
    let category: PyType
    let filename: PyString
    let lineNo: PyInt
    let module: PyString
    let source: PyObject?
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

    if messageArg.type.isSubtype(of: Py.errorTypes.warning) {
      // We have to artificially create message based on the type.
      switch Py.types.str.call(args: [messageArg], kwargs: nil) {
      case let .value(t): text = t
      case let .error(e): return .error(e)
      }

      message = messageArg
      category = messageArg.type
    } else {
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
    if filename.value.isEmpty {
      return Py.intern("<unknown>")
    }

    if filename.value.hasSuffix(".py") {
      let module = String(filename.value.dropLast(3))
      return Py.intern(module)
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
        if Self.isEqual(action: action, to: "default") { return .default }
        if Self.isEqual(action: action, to: "error") { return .error }
        if Self.isEqual(action: action, to: "ignore") { return .ignore }
        if Self.isEqual(action: action, to: "always") { return .always }
        if Self.isEqual(action: action, to: "module") { return .module }
        if Self.isEqual(action: action, to: "once") { return .once }
        return .other
      }()
    }

    private static func isEqual(action: PyString, to value: String) -> Bool {
      return action.compare(with: value) == .equal
    }
  }
}
