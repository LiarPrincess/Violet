/* MARKER
import VioletCore

// In CPython:
// Python -> _warnings.c
// https://docs.python.org/3/library/warnings.html#warnings.warn

private let arguments = ArgumentParser.createOrTrap(
  arguments: ["message", "category", "stacklevel", "source"],
  format: "O|OOO:warn"
)

extension UnderscoreWarnings {

  internal static var warnDoc: String {
    return """
      warn($module, /, message, category=None, stacklevel=1, source=None)
      --

      Issue a warning, or maybe ignore it or raise an exception.
      """
  }

  /// Doc:
  /// https://docs.python.org/3/library/warnings.html#warnings.warn
  ///
  /// static PyObject *
  /// warnings_warn_impl(PyObject *module, PyObject *message, ...)
  internal func warn(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    switch arguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 1, "Invalid required argument count.")
      assert(binding.optionalCount == 3, "Invalid optional argument count.")

      let message = binding.required(at: 0)
      let category = binding.optional(at: 1)
      let stackLevel = binding.optional(at: 2)
      let source = binding.optional(at: 3)
      return self.warn(message: message,
                       category: category,
                       stackLevel: stackLevel,
                       source: source)

    case let .error(e):
      return .error(e)
    }
  }

  public func warn(message: PyObject,
                   category categoryArg: PyObject? = nil,
                   stackLevel stackLevelArg: PyObject? = nil,
                   source: PyObject? = nil) -> PyBaseException? {
    let category: PyType
    switch self.parseCategory(message: message, category: categoryArg) {
    case let .value(c): category = c
    case let .error(e): return .error(e)
    }

    let stackLevel: Int
    switch self.parseStackLevel(level: stackLevelArg) {
    case let .value(l): stackLevel = l
    case let .error(e): return .error(e)
    }

    let frame: PyFrame?
    switch self.getFrame(level: stackLevel) {
    case .value(let f): frame = f
    case .none: frame = nil
    case .levelTooBig: frame = nil
    case .error(let e): return .error(e)
    }

    let globals = self.getGlobals(frame: frame)
    let lineNo = Py.newInt(frame?.currentInstructionLine ?? SourceLocation.start.line)

    let registry: WarningRegistry
    switch self.getWarningRegistry(globals: globals) {
    case let .value(r): registry = r
    case let .error(e): return .error(e)
    }

    let module = self.getModuleName(globals: globals)
    let filename = self.getFilename(globals: globals, module: module)

    return self.warnExplicit(
      message: message,
      category: category,
      filename: filename,
      lineNo: lineNo,
      module: module,
      source: source,
      registry: registry
    )
  }

  private func getGlobals(frame: PyFrame?) -> PyDict {
    return frame?.globals ?? Py.sysModule.__dict__
  }

  // MARK: - Category

  /// static PyObject *
  /// get_category(PyObject *message, PyObject *category)
  private func parseCategory(message: PyObject,
                             category: PyObject?) -> PyResult<PyType> {
    if self.isWarningSubtype(type: message.type) {
      return .value(message.type)
    }

    // If 'category' is 'nil' or 'None' -> userWarning
    let userWarning = Py.errorTypes.userWarning
    assert(self.isWarningSubtype(type: userWarning))

    guard let category = category else {
      return .value(userWarning)
    }

    if PyCast.isNone(category) {
      return .value(userWarning)
    }

    if let type = PyCast.asType(category), self.isWarningSubtype(type: type) {
      return .value(type)
    }

    let t = category.typeName
    return .typeError("category must be a Warning subclass, not '\(t)'")
  }

  internal func isWarningSubtype(type: PyType) -> Bool {
    return type.isSubtype(of: Py.errorTypes.warning)
  }

  // MARK: - Stack level

  private func parseStackLevel(level: PyObject?) -> PyResult<Int> {
    guard let level = level else {
      return .value(1)
    }

    if let pyInt = PyCast.asInt(level) {
      if let int = Int(exactly: pyInt.value) {
        return .value(int)
      }

      return .typeError("warn(): stackLevel too big")
    }

    return .typeError("warn(): stackLevel must be an int, not \(level.typeName)")
  }

  // MARK: - Get frame

  private enum GetFrameResult {
    case value(PyFrame)
    case none
    case levelTooBig
    case error(PyBaseException)
  }

  private func getFrame(level levelArg: Int) -> GetFrameResult {
    guard let topFrame = Py.delegate.frame else {
      return .none
    }

    var frame = topFrame
    var level = Swift.abs(levelArg)

    let showAllFrames = levelArg <= 0 || self.isInternalFrame(frame: topFrame)
    if showAllFrames {
      while let parent = frame.parent, level > 0 {
        frame = parent
        level -= 1
      }
    } else {
      while let parent = self.getExternalParent(frame: frame), level > 0 {
        frame = parent
        level -= 1
      }
    }

    return level == 0 ? .value(frame) : .levelTooBig
  }

  /// static PyFrameObject *
  /// next_external_frame(PyFrameObject *frame)
  private func getExternalParent(frame: PyFrame) -> PyFrame? {
    var result = frame.parent

    while let f = result, self.isInternalFrame(frame: f) {
      result = f.parent
    }

    return result
  }

  /// static int
  /// is_internal_frame(PyFrameObject *frame)
  private func isInternalFrame(frame: PyFrame) -> Bool {
    let filename = frame.code.filename
    // CPython uses '&&', but this seems kind of weird…
    return filename.contains(value: "importlib")
        || filename.contains(value: "_bootstrap")
  }

  // MARK: - Warning registry

  public func getWarningRegistry(frame: PyFrame?) -> PyResult<WarningRegistry> {
    let globals = self.getGlobals(frame: frame)
    return self.getWarningRegistry(globals: globals)
  }

  public func getWarningRegistry(globals: PyDict) -> PyResult<WarningRegistry> {
    if let object = globals.get(id: .__warningregistry__) {
      if PyCast.isNone(object) {
        return .value(.none)
      }

      if let dict = PyCast.asDict(object) {
        return .value(.dict(dict))
      }

      let e = Py.newTypeError(msg: "'registry' must be a dict or None")
      return .error(e)
    }

    let registry = Py.newDict()
    globals.set(id: .__warningregistry__, to: registry)
    return .value(.dict(registry))
  }

  // MARK: - Module name

  private func getModuleName(globals: PyDict) -> PyString {
    if let object = globals.get(id: .__name__),
       let string = PyCast.asString(object) {
      return string
    }

    return Py.intern(string: "<string>")
  }

  // MARK: - File name

  private func getFilename(globals: PyDict, module: PyString) -> PyString {
    if let object = globals.get(id: .__file__),
       let str = PyCast.asString(object) {
      return str
    }

    // If we are in '__main__' module, then we have to take filename
    // from arg0.
    if module.isEqual("__main__") {
      switch Py.sys.getArgv0() {
      case .value(let string) where !string.isEmpty:
        return string
      case .value,
           .error:
        break // whatever, just use default
      }
    }

    return Py.intern(string: "__main__")
  }
}

*/
