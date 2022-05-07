import VioletBytecode

extension PyFrame {

  public typealias FastLocal = PyObject?

  public struct FastLocalsProxy {

    private let ptr: BufferPtr<FastLocal>

    internal var first: FastLocal? {
      return self.ptr.first
    }

    public var count: Int {
      return self.ptr.count
    }

    internal init(frame: PyFrame) {
      let storage = frame.fastLocalsCellFreeBlockStackStorage
      self.ptr = storage.fastLocals
    }

    internal func initialize() {
      // 'FillFastLocals' will check if value was filled, so in the beginning
      // we will set all values to 'nil', otherwise we would read uninitialized
      // memory.
      self.ptr.initialize(repeating: nil)
    }

    // swiftlint:disable function_parameter_count
    public func fill(_ py: Py,
                     code: PyCode,
                     args: [PyObject],
                     kwargs: PyDict?,
                     defaults: [PyObject],
                     kwDefaults: PyDict?) -> PyBaseException? {
      // Filling args and locals is actually quite complicated,
      // so it was moved to separate struct.
      var helper = FillFastLocals(
        py,
        fastLocals: self,
        code: code,
        args: args,
        kwargs: kwargs,
        defaults: defaults,
        kwDefaults: kwDefaults
      )

      return helper.run()
    }

    public subscript(index: Int) -> FastLocal {
      get { return self.ptr[index] }
      nonmutating set { self.ptr[index] = newValue }
    }
  }
}

// MARK: - FillFastLocals

extension String {
  fileprivate mutating func append(_ elements: CustomStringConvertible...) {
    for element in elements {
      let string = String(describing: element)
      self.append(string)
    }
  }
}

/// Helper structure for filling `Frame.fastLocals`.
/// `Frame.fastLocals` holds function args and local variables.
///
/// Fast locals layout:
/// ```
///  args | varArgs | varKeywords | locals
///       ^ self.totalArgs
/// ```
private struct FillFastLocals {

  private let py: Py
  private let code: PyCode
  private let fastLocals: PyFrame.FastLocalsProxy
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

  fileprivate init(_ py: Py,
                   fastLocals: PyFrame.FastLocalsProxy,
                   code: PyCode,
                   args: [PyObject],
                   kwargs: PyDict?,
                   defaults: [PyObject],
                   kwDefaults: PyDict?) {
    self.py = py
    self.code = code
    self.fastLocals = fastLocals
    self.args = args
    self.kwargs = kwargs
    self.defaults = defaults
    self.kwDefaults = kwDefaults
  }

  // MARK: - Run

  /// PyObject *
  /// _PyEval_EvalCodeWithName(PyObject *_co, PyObject *globals, ...)
  fileprivate mutating func run() -> PyBaseException? {
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
    let value = self.fastLocals[index]
    return value != nil
  }

  private func set(index: Int, value: PyObject) {
    assert(!self.isSet(index: index))
    self.fastLocals[index] = value
  }

  /// *args
  private func setVarArgs(value: [PyObject]) {
    let tuple = self.py.newTuple(elements: value)
    self.set(index: self.totalArgs, value: tuple.asObject)
  }

  /// **kwargs
  private func setVarKwargs(value: PyDict) {
    let index = self.hasVarArgs ? self.totalArgs + 1 : self.totalArgs
    self.set(index: index, value: value.asObject)
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

  private mutating func fillFromKwargs() -> PyBaseException? {
    // Create a dictionary for keyword parameters (**kwargs)
    // We have to do this even if we were not called with **kwargs.
    if self.hasVarKeywords {
      let dict = self.py.newDict()
      self.varKwargs = dict
      self.setVarKwargs(value: dict)
    }

    guard let kwargs = self.kwargs else {
      return nil
    }

    // swiftlint:disable:next closure_body_length
    return self.py.forEach(dict: kwargs) { key, value in
      guard let keyword = self.py.cast.asString(key) else {
        let error = self.newTypeError("keywords must be strings")
        return .error(error)
      }

      // Try to find entry in 'args'
      let keywordString = self.py.strString(keyword)
      for index in 0..<self.totalArgs {
        let name = self.getName(self.code.variableNames[index])
        guard name == keywordString else {
          continue
        }

        guard index >= self.code.posOnlyArgCount else {
          let msg = "got some positional-only arguments passed as keyword arguments: '\(keyword)'"
          let error = self.newTypeError(msg)
          return .error(error)
        }

        guard !self.isSet(index: index) else {
          let error = self.newTypeError("got multiple values for argument '\(keyword)'")
          return .error(error)
        }

        self.set(index: index, value: value)
        return .goToNextElement
      }

      // Ok, this is proper 'kwarg', but do we even have 'kwargs'?
      if let dict = self.varKwargs {
        switch dict.set(self.py, key: keyword, value: value) {
        case .ok: return .goToNextElement
        case .error(let e): return .error(e)
        }
      }

      let error = self.newTypeError("got an unexpected keyword argument '\(keyword)'")
      return .error(error)
    }
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
      let interned = self.py.intern(string: name)

      switch kwDefaults.get(self.py, key: interned) {
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
    let hasTooManyArgs = self.args.count > self.code.argCount
    guard hasTooManyArgs && !self.hasVarArgs else {
      return nil
    }

    let argCount = self.code.argCount
    let defaultsCount = self.defaults.count
    var message = "takes "

    if defaultsCount == 0 {
      let s = argCount == 0 ? "" : "s"
      message.append(argCount, " positional argument", s)
    } else {
      let minCount = argCount - defaultsCount
      message.append("from ", minCount, " to ", argCount, " positional arguments ")
    }

    let givenArgCount = self.args.count
    message.append("but ", givenArgCount, " ")

    // Count missing keyword-only args.
    let keywordOnlyCount = self.code.kwOnlyArgCount
    var keywordOnlyGivenCount = 0
    for i in argCount..<(argCount + keywordOnlyCount) {
      if self.isSet(index: i) {
        keywordOnlyGivenCount += 1
      }
    }

    if keywordOnlyGivenCount > 0 {
      let s0 = givenArgCount == 0 ? "" : "s"
      message.append("positional argument", s0)

      let s1 = keywordOnlyGivenCount == 0 ? "" : "s"
      message.append("(and ", keywordOnlyGivenCount, " keyword-only argument", s1, ") ")
    }

    let was = givenArgCount == 1 && keywordOnlyGivenCount == 0 ? "was" : "where"
    message.append(was, " given")
    return self.newTypeError(message)
  }

  private enum MissingArguments {
    case positional
    case kwarg
  }

  /// static void
  /// missing_arguments(PyCodeObject *co, Py_ssize_t missing, ...)
  private func missingArguments(count: Int, mode: MissingArguments) -> PyBaseException {
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
      if !self.isSet(index: index) {
        let name = self.getName(self.code.variableNames[index])
        missingNames.append(name)
      }
    }

    assert(missingNames.count == count)

    var message = ""
    let missingCount = missingNames.count
    let s = missingNames.isEmpty ? "" : "s"
    message.append("missing ", missingCount, " required ", kind, " argument", s, ": ")

    self.appendNames(string: &message, names: missingNames)
    return self.newTypeError(message)
  }

  private func appendNames(string: inout String, names: [String]) {
    assert(names.any)

    switch names.count {
    case 1:
      string.append(names[0])
    case 2:
      string.append(names[0], " and ", names[1])
    default:
      for name in names.dropLast() {
        if !string.isEmpty {
          string.append(", ")
        }

        string.append(name)
      }

      let last = names[names.count - 1]
      string.append(" and ", last)
    }
  }

  /// Will automatically prepend the function name.
  private func newTypeError(_ message: String) -> PyBaseException {
    var messageWithFn = self.py.strString(self.code.name)
    messageWithFn.append("() ")
    messageWithFn.append(message)

    let error = self.py.newTypeError(message: messageWithFn)
    return error.asBaseException
  }

  // MARK: - Helpers

  private func getName(_ name: MangledName) -> String {
    return name.beforeMangling
  }
}
