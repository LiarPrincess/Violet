import Objects
import Bytecode

// swiftlint:disable file_length

/// Helper structure for filling `Frame.fastLocals`.
///
/// Fast locals layout:
/// ```
///  [object] | varArgs | varKeywords
///           ^ totalArgs
/// ```
internal struct FillFastLocals {

  private let frame: Frame
  private let args: [PyObject]
  private let kwargs: PyDict?
  private let defaults: [PyObject]
  private let kwDefaults: PyDict?

  private var varKwargs: PyDict?

  private var totalArgs: Int {
    return self.code.argCount + self.code.kwOnlyArgCount
  }

  private var hasVarArgs: Bool {
    return self.code.flags.contains(.varArgs)
  }

  private var hasVarKeywords: Bool {
    return self.code.flags.contains(.varKeywords)
  }

  private var code: CodeObject {
    return self.frame.code
  }

  internal init(frame: Frame,
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
  internal mutating func run() -> PyResult<PyNone> {
    self.fillFromArgs()

    if let e = self.fillFromKwargs() {
      return .error(e)
    }

    if let e = self.checkPositionalCount() {
      return .error(e)
    }

    if let e = self.fillFromArgsDefaults() {
      return .error(e)
    }

    if let e = self.fillFromKwArgsDefaults() {
      return .error(e)
    }

    return .value(Py.none)
  }

  // MARK: - Setters

  fileprivate func isSet(index: Int) -> Bool {
    let value = self.frame.fastLocals[index]
    return value != nil
  }

  fileprivate func set(index: Int, value: PyObject) {
    assert(!self.isSet(index: index))
    self.frame.fastLocals[index] = value
  }

  /// *args
  fileprivate func setVarArgs(value: [PyObject]) {
    let tuple = Py.newTuple(value)
    self.set(index: self.totalArgs, value: tuple)
  }

  /// **kwags
  fileprivate func setVarKwargs(value: PyDict) {
    let index = self.hasVarArgs ? totalArgs + 1 : totalArgs
    self.set(index: index, value: value)
  }

  // MARK: - Args

  private var n: Int {
    return Swift.min(self.args.count, self.code.argCount)
  }

  private func fillFromArgs() {
    // Copy positional arguments into local variables
    for index in 0..<self.n {
      let value = self.args[index]
      self.set(index: index, value: value)
    }

    // Pack other positional arguments into the *args argument
    if self.hasVarArgs {
      let value = Array(self.args[self.n...])
      self.setVarArgs(value: value)
    }
  }

  // MARK: - Kwargs

  private mutating func fillFromKwargs() -> PyBaseException? {
    guard let kwargs = self.kwargs else {
      return nil
    }

    // Create a dictionary for keyword parameters (**kwags)
    if self.hasVarKeywords {
      let dict = Py.newDict()
      self.setVarKwargs(value: dict)
      self.varKwargs = dict
    }

    // Handle keyword arguments
    nextKwarg: for entry in kwargs.data {
      guard let keyword = entry.key.object as? PyString else {
        let name = self.code.name
        return Py.newTypeError(msg: "\(name)() keywords must be strings")
      }

      // Try to find proper index in locals
      for index in 0..<self.totalArgs {
        let name = self.getName(self.code.variableNames[index])
        guard name == keyword.value else {
          continue
        }

        guard !self.isSet(index: index) else {
          let name = self.code.name
          let msg = "\(name)() got multiple values for argument '\(keyword)'"
          return Py.newTypeError(msg: msg)
        }

        self.set(index: index, value: entry.value)
        continue nextKwarg
      }

      // If none of the 'code.variableNames' fit:
      if let dict = self.varKwargs {
        switch dict.setItem(at: keyword, to: entry.value) {
        case .value: break
        case .error(let e): return e
        }
      } else {
        let name = self.code.name
        let msg = "\(name)() got an unexpected keyword argument '\(keyword)'"
        return Py.newTypeError(msg: msg)
      }
    }

    return nil
  }

  // MARK: - Args defaults

  private func fillFromArgsDefaults() -> PyBaseException? {
    // Add missing positional arguments (copy default values from defs)

    // It can be '>' because of *args
    let hasAllArgs = self.args.count >= self.code.argCount
    if hasAllArgs {
      return nil
    }

    /// CPython: `m`
    let argsWithoutDefault = self.code.argCount - self.defaults.count

    var missing = 0
    for index in self.args.count..<argsWithoutDefault {
      if !self.isSet(index: index) {
        missing += 1
      }
    }

    if missing > 0 {
      return self.missingArguments(missing: missing, mode: .positional)
    }

    let iStart = self.n > argsWithoutDefault ? self.n - argsWithoutDefault : 0

    for i in iStart..<self.defaults.count {
      let index = argsWithoutDefault + i
      if !self.isSet(index: index) {
        let value = self.defaults[i]
        self.set(index: index, value: value)
      }
    }

    return nil
  }

  // MARK: - Kwargs defaults

  private func fillFromKwArgsDefaults() -> PyBaseException? {
    // Add missing keyword arguments (copy default values from kwdefs)

    guard let kwDefaults = kwDefaults else {
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
      let interned = Py.getInterned(name)

      switch kwDefaults.getItem(at: interned) {
      case let .value(defaultValue):
        self.set(index: index, value: defaultValue)
      case let .error(e):
        if e.isKeyError {
          missing += 1
          continue // not found -> go to next kwarg
        }

        return e
      }
    }

    if missing > 0 {
      return self.missingArguments(missing: missing, mode: .kwarg)
    }

    return nil
  }

  // MARK: - Errors

  /// static void
  /// too_many_positional(PyCodeObject *co, Py_ssize_t given, ...)
  private func checkPositionalCount() -> PyBaseException? {
    guard self.args.count > self.code.argCount && !self.hasVarArgs else {
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
    var msg = "\(self.code.name)() takes "

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
  private func missingArguments(missing: Int,
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

    assert(missingNames.count == missing)

    let name = self.code.name
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
    return name.base
  }
}