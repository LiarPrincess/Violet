import VioletBytecode
import VioletObjects

// swiftlint:disable file_length

/// Helper structure for filling `Frame.fastLocals`.
/// `Frame.fastLocals` holds function args and local variables.
///
/// Fast locals layout:
/// ```
///  args | varArgs | varKeywords | locals
///       ^ self.totalArgs
/// ```
internal struct FillFastLocals {

  private let frame: PyFrame
  /// Positional arguments as given by the user.
  private let args: [PyObject]
  /// Kwargs as given by the user.
  private let kwargs: PyDict?
  /// Default positional values to use if don't have this arg.
  private let defaults: [PyObject]
  /// Default keyword values, used when we don't have this kwarg.
  private let kwDefaults: PyDict?

  private var varKwargs: PyDict?

  private var totalArgs: Int {
    return self.code.argCount + self.code.kwOnlyArgCount
  }

  private var hasVarArgs: Bool {
    return self.code.codeFlags.contains(.varArgs)
  }

  private var hasVarKeywords: Bool {
    return self.code.codeFlags.contains(.varKeywords)
  }

  private var code: PyCode {
    return self.frame.code
  }

  internal init(frame: PyFrame,
                args: [PyObject],
                kwargs: PyDict?,
                defaults: [PyObject],
                kwDefaults: PyDict?) {
    self.frame = frame
    self.args = args
    self.kwargs = kwargs
    self.defaults = defaults
    self.kwDefaults = kwDefaults
  }

  // MARK: - Run

  /// PyObject *
  /// _PyEval_EvalCodeWithName(PyObject *_co, PyObject *globals, ...)
  internal mutating func run() -> PyBaseException? {
    self.fillFromArgs()

    // We could totally use '??' as monadic bind for errors and write this
    // as a single line with just 'return' statement.
    // But we are not monsters…

    if let e = self.fillFromKwargs() {
      return e
    }

    if let e = self.checkPositionalCount() {
      return e
    }

    if let e = self.fillFromArgsDefaults() {
      return e
    }

    if let e = self.fillFromKwArgsDefaults() {
      return e
    }

    return nil
  }

  // MARK: - Setters

  private func isSet(index: Int) -> Bool {
    let value = self.frame.fastLocals[index]
    return value != nil
  }

  private func set(index: Int, value: PyObject) {
    assert(!self.isSet(index: index))
    self.frame.fastLocals[index] = value
  }

  /// *args
  private func setVarArgs(value: [PyObject]) {
    let tuple = Py.newTuple(elements: value)
    self.set(index: self.totalArgs, value: tuple)
  }

  /// **kwargs
  private func setVarKwargs(value: PyDict) {
    let index = self.hasVarArgs ? self.totalArgs + 1 : self.totalArgs
    self.set(index: index, value: value)
  }

  // MARK: - Args

  private func fillFromArgs() {
    // Name taken from 'CPython'
    let n = Swift.min(self.args.count, self.code.argCount)

    // Copy positional arguments into local variables
    for index in 0..<n {
      let value = self.args[index]
      self.set(index: index, value: value)
    }

    // Pack other positional arguments into the *args argument
    if self.hasVarArgs {
      let value = Array(self.args[n...])
      self.setVarArgs(value: value)
    }
  }

  // MARK: - Kwargs

  // swiftlint:disable:next function_body_length
  private mutating func fillFromKwargs() -> PyBaseException? {
    // Create a dictionary for keyword parameters (**kwargs)
    // We have to do this even if we were not called with **kwargs.
    if self.hasVarKeywords {
      let dict = Py.newDict()
      self.varKwargs = dict
      self.setVarKwargs(value: dict)
    }

    guard let kwargs = self.kwargs else {
      return nil
    }

    // Handle keyword arguments
    // swiftlint:disable:next closure_body_length
    let e = Py.forEach(dict: kwargs) { key, value in
      guard let keyword = PyCast.asString(key) else {
        let name = self.code.name
        let e = Py.newTypeError(msg: "\(name)() keywords must be strings")
        return .error(e)
      }

      // Try to find entry in 'args'
      for index in 0..<self.totalArgs {
        let name = self.getName(self.code.variableNames[index])
        guard name == keyword.value else {
          continue
        }

        guard !self.isSet(index: index) else {
          let name = self.code.name
          let msg = "\(name)() got multiple values for argument '\(keyword)'"
          let e = Py.newTypeError(msg: msg)
          return .error(e)
        }

        self.set(index: index, value: value)
        return .goToNextElement
      }

      // Ok, this is proper 'kwarg', but do we even have 'kwargs'?
      if let dict = self.varKwargs {
        switch dict.set(key: keyword, to: value) {
        case .ok: return .goToNextElement
        case .error(let e): return .error(e)
        }
      }

      let name = self.code.name
      let msg = "\(name)() got an unexpected keyword argument '\(keyword)'"
      let e = Py.newTypeError(msg: msg)
      return .error(e)
    }

    // We could 'return Py.forEach' but this is better for debugging.
    return e
  }

  // MARK: - Args defaults

  /// CPython: `m`
  private var argsWithoutDefault: Int {
    return self.code.argCount - self.defaults.count
  }

  /// Add missing positional arguments (copy default values from defs)
  private func fillFromArgsDefaults() -> PyBaseException? {
    // It can be '>' because of '*args'
    let hasAllArgs = self.args.count >= self.code.argCount
    if hasAllArgs {
      return nil
    }

    if let e = self.checkNotFilledArgWithoutDefault() {
      return e
    }

    for defaultIndex in 0..<self.defaults.count {
      let argumentIndex = self.argsWithoutDefault + defaultIndex
      if !self.isSet(index: argumentIndex) {
        let value = self.defaults[defaultIndex]
        self.set(index: argumentIndex, value: value)
      }
    }

    return nil
  }

  private func checkNotFilledArgWithoutDefault() -> PyBaseException? {
    var missingCount = 0

    for index in 0..<self.argsWithoutDefault {
      if !self.isSet(index: index) {
        missingCount += 1
      }
    }

    if missingCount == 0 {
      return nil
    }

    return self.missingArguments(count: missingCount, mode: .positional)
  }

  // MARK: - Kwargs defaults

  /// Add missing keyword arguments (copy default values from kwDefaults).
  private func fillFromKwArgsDefaults() -> PyBaseException? {
    guard let kwDefaults = self.kwDefaults else {
      return nil
    }

    if self.code.kwOnlyArgCount == 0 {
      return nil
    }

    var missing = 0
    for index in self.code.argCount..<self.totalArgs {
      if self.isSet(index: index) {
        continue
      }

      let name = self.getName(self.code.variableNames[index])
      let interned = Py.intern(string: name)

      switch kwDefaults.get(key: interned) {
      case .value(let defaultValue):
        self.set(index: index, value: defaultValue)
      case .notFound:
        missing += 1
      case .error(let e):
        return e
      }
    }

    if missing > 0 {
      return self.missingArguments(count: missing, mode: .kwarg)
    }

    return nil
  }

  // MARK: - Errors

  /// static void
  /// too_many_positional(PyCodeObject *co, Py_ssize_t given, ...)
  private func checkPositionalCount() -> PyBaseException? {
    let hasTooMuchArgs = self.args.count > self.code.argCount
    guard hasTooMuchArgs && !self.hasVarArgs else {
      return nil
    }

    let argCount = self.code.argCount
    let kwOnlyArgCount = self.code.kwOnlyArgCount

    // Count missing keyword-only args.
    var kwOnlyGiven = 0
    for i in argCount..<(argCount + kwOnlyArgCount) {
      if self.isSet(index: i) {
        kwOnlyGiven += 1
      }
    }

    let given = self.args.count
    let defCount = self.defaults.count
    let fnName = self.code.name.value
    var msg = "\(fnName)() takes "

    if defCount > 0 {
      msg += "from \(argCount - defCount) to \(argCount) positional arguments "
    } else {
      let s = argCount != 1 ? "s" : ""
      msg += "\(argCount) positional argument\(s) "
    }

    msg += "but \(given) "

    if kwOnlyGiven > 0 {
      let s0 = given != 1 ? "s" : ""
      let s1 = kwOnlyGiven != 1 ? "s" : ""
      msg += "positional argument\(s0) "
      msg += "(and %\(kwOnlyGiven) keyword-only argument\(s1)) "
    }

    let was = given == 1 && kwOnlyGiven == 0 ? "was" : "where"
    msg += "\(was) given"

    return Py.newTypeError(msg: msg)
  }

  private enum MissingArguments {
    case positional
    case kwarg
  }

  /// static void
  /// missing_arguments(PyCodeObject *co, Py_ssize_t missing, ...)
  private func missingArguments(count: Int,
                                mode: MissingArguments) -> PyBaseException {
    let start: Int
    let end: Int
    let kind: String
    switch mode {
    case .positional:
      start = 0
      end = self.code.argCount - self.defaults.count
      kind = "positional"
    case .kwarg:
      start = self.code.argCount
      end = start + self.code.kwOnlyArgCount
      kind = "keyword-only"
    }

    var missingNames = [String]()
    for index in start..<end {
      let isMissing = !self.isSet(index: index)
      guard isMissing else { continue }

      let name = self.getName(self.code.variableNames[index])
      missingNames.append(name)
    }

    assert(missingNames.count == count)

    let name = self.code.name.value
    let count = missingNames.count
    let s = missingNames.count != 1 ? "s" : ""
    let names = self.formatNames(names: missingNames)
    let msg = "\(name)() missing \(count) required \(kind) argument\(s): \(names)"

    return Py.newTypeError(msg: msg)
  }

  private func formatNames(names: [String]) -> String {
    assert(names.any)

    switch names.count {
    case 1:
      return names[0]
    case 2:
      return "\(names[0]) and \(names[1])"
    default:
      let withoutLast = names.dropLast().joined(separator: ",")
      let last = " and \(names[names.count - 1])"
      return withoutLast + last
    }
  }

  // MARK: - Helpers

  private func getName(_ name: MangledName) -> String {
    return name.beforeMangling
  }
}
