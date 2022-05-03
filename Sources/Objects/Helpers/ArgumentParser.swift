import VioletCore

// cSpell:ignore modsupport vgetargskeywordsfast kwnames kwtuple

// In CPython:
// Python -> modsupport.h
// Python -> getargs.c

// WARNING: This code is quite complicated!
// And it is easily the ugliest/most tangled part of CPython.
// Like really, it will break your mind when you go into it!

/// Structure responsible for binding runtime parameters to function signature.
/// In CPython `typedef struct _PyArg_Parser`.
///
/// We will reuse CPython format/convention.
/// Mostly because this way we can just compare code/format specifiers
/// to check for errors. We could write this ourselves, but why?
///
/// For example for `int(value, base)`:
/// ```C
/// static const char * const _keywords[] = {"", "base", NULL};
/// static _PyArg_Parser _parser = {"|OO:int", _keywords, 0};
/// ```
/// And then:
/// ```C
/// static int parser_init(struct _PyArg_Parser *parser)
/// ```
/// - Parameter arguments: Argument names. But only for keyword arguments.
///                        Positional arguments should use empty string.
/// - Parameter format: Argument format:
///                     - `O` - Python object
///                     - `|` - end of the required arguments (`minArgCount`)
///                     - `$` - end of the positional arguments (`maxPositionalArgCount`)
///                     - `:` - end of the argument format, what follows is a function name
///                     - other - ignored
///
/// For example (this is `int.__new__`):
/// ```
/// let parser = ArgumentParser.create(
///   arguments: ["", "base"],
///   format: "|OO:int"
/// )
/// ```
///
/// Means:
/// - 1st argument is a positional argument without name (1st entry in `arguments`)
/// - 2nd argument is a keyword argument called `base` (2nd entry in `arguments`)
/// - both arguments are Python objects (`format` has `OO`)
/// - none of the arguments are required (`format` starts with `|`)
/// - function name is `int` (part of the `format` after `:`)
///
/// Most of the time it should use static allocation.
internal struct ArgumentParser {

  /// Function name
  private let fnName: String
  /// Minimal number of arguments needed to call the function.
  /// `min` in Cpython.
  private let requiredArgCount: Int
  /// Number of positional-only arguments.
  /// `pos` in CPython.
  private let positionalOnlyArgCount: Int
  /// Maximal number of positional-only arguments.
  /// `max` in CPython.
  private let maxPositionalArgCount: Int
  /// Keyword parameter names.
  /// `kwtuple` in CPython.
  private let keywordArgNames: [String]

  /// `len` in CPython.
  /// `self.positionalArgCount + self.keywordArgNames.count`
  private var argumentCount: Int {
    return self.positionalOnlyArgCount + self.keywordArgNames.count
  }

  private init(fnName: String,
               requiredArgCount: Int,
               positionalOnlyArgCount: Int,
               maxPositionalArgCount: Int,
               keywordArgNames: [String]) {
    self.fnName = fnName
    self.requiredArgCount = requiredArgCount
    self.positionalOnlyArgCount = positionalOnlyArgCount
    self.maxPositionalArgCount = maxPositionalArgCount
    self.keywordArgNames = keywordArgNames
  }

  internal enum CreateResult {
    case value(ArgumentParser)
    case error(String)
  }

  internal static func create(arguments: [String], format: String) -> CreateResult {
    let name: String
    switch ArgumentParser.extractFunctionName(format: format) {
    case let .value(n): name = n
    case let .error(message): return .error(message)
    }

    let firstKeywordArgIndex = arguments.firstIndex { !$0.isEmpty }
    let positionalArgCount = firstKeywordArgIndex ?? arguments.count

    var keywordArgumentNames = [String]()
    if let keywordStart = firstKeywordArgIndex {
      keywordArgumentNames = Array(arguments[keywordStart...])
      let hasKeywordWithoutName = keywordArgumentNames.contains { $0.isEmpty }
      if hasKeywordWithoutName {
        return .error("Empty keyword parameter name")
      }
    }

    let minArgCount: Int
    let maxPositionalArgCount: Int
    switch ArgumentParser.parseFormat(format: format,
                                      argCount: arguments.count,
                                      positionalArgCount: positionalArgCount) {
    case let .value(minArgCount: min, maxPositionalArgCount: max):
      minArgCount = min
      maxPositionalArgCount = max
    case let .error(message):
      return .error(message)
    }

    let result = ArgumentParser(
      fnName: name,
      requiredArgCount: min(minArgCount, arguments.count),
      positionalOnlyArgCount: positionalArgCount,
      maxPositionalArgCount: min(maxPositionalArgCount, arguments.count),
      keywordArgNames: keywordArgumentNames
    )

    return .value(result)
  }

  internal static func createOrTrap(arguments: [String],
                                    format: String) -> ArgumentParser {
    switch Self.create(arguments: arguments, format: format) {
    case let .value(parser):
      return parser
    case let .error(message):
      trap(message)
    }
  }

  private enum FunctionNameResult {
    case value(String)
    case error(String)
  }

  /// Function name starts after ':' in format.
  private static func extractFunctionName(format: String) -> FunctionNameResult {
    guard var startIndex = format.firstIndex(of: ":") else {
      return .error("Format does not contain a function name")
    }

    // Go after ':'
    format.formIndex(after: &startIndex) // after ':'
    if startIndex == format.endIndex {
      return .error("Format does not contain a function name")
    }

    return .value(String(format[startIndex...]))
  }

  private enum ParseFormatResult {
    case value(minArgCount: Int, maxPositionalArgCount: Int)
    case error(String)
  }

  private static func parseFormat(format: String,
                                  argCount: Int,
                                  positionalArgCount: Int) -> ParseFormatResult {
    var minArgCount = Int.max
    var maxPositionalArgCount = Int.max

    var formatIndex = format.startIndex
    for i in 0..<argCount {
      if formatIndex == format.endIndex {
        return .error("More keyword list entries (\(argCount)) than format specifiers (\(i))")
      }

      if format[formatIndex] == "|" {
        if minArgCount != Int.max {
          return .error("Invalid format string (| specified twice)")
        }
        if maxPositionalArgCount != Int.max {
          return .error("Invalid format string ($ before |)")
        }

        minArgCount = i
        format.formIndex(after: &formatIndex)
      }

      if format[formatIndex] == "$" {
        if maxPositionalArgCount != Int.max {
          return .error("Invalid format string ($ specified twice)")
        }
        if i < positionalArgCount {
          return .error("Empty parameter name after $")
        }

        maxPositionalArgCount = i
        format.formIndex(after: &formatIndex)
      }

      // We expect argument formatter (for example 'O') here
      if formatIndex == format.endIndex || self.isFormatEnd(format[formatIndex]) {
        return .error("More keyword list entries (\(argCount)) than format specifiers (\(i))")
      }

      format.formIndex(after: &formatIndex)
    }

    if formatIndex != format.endIndex && !self.isFormatEnd(format[formatIndex]) {
      return .error("More argument specifiers than keyword list entries")
    }

    return .value(minArgCount: minArgCount, maxPositionalArgCount: maxPositionalArgCount)
  }

  private static func isFormatEnd(_ c: Character) -> Bool {
    return c == ";" || c == ":"
  }

  // MARK: - Bind

  /// Assign values to an arguments.
  ///
  /// You can obtain argument value using its index.
  /// For example to obtain value of the 3rd argument use `3` as an index.
  ///
  /// There are 2 types of arguments:
  /// - required - arguments that have to be present to be able call a function.
  /// If a `required` argument was not provided then `bind` will throw.
  /// They are before `|` in `ArgumentParser.format` specifier.
  /// - optional - arguments not needed to call a function (they probably have
  /// some default value). `nil` means that this argument was not provided.
  /// They are after `|` in `ArgumentParser.format` specifier.
  ///
  /// Distinction between 'required' and 'optional' was introduced for additional
  /// type-safety (optional values can be nil, required can't).
  /// Otherwise we would have to check required for `nil` on every call site.
  internal struct Binding {
    fileprivate var _required = [PyObject]()
    fileprivate var _optional = [PyObject?]()

    internal var requiredCount: Int { return self._required.count }
    internal var optionalCount: Int { return self._optional.count }

    /// Get required argument at specified index.
    internal func required(at index: Int) -> PyObject {
      return self._required[index]
    }

    /// Get optional argument at specified index.
    /// Note that the optional arguments start after required.
    internal func optional(at index: Int) -> PyObject? {
      let optionalIndex = index - self._required.count
      assert(optionalIndex >= 0, "Accessing optional arg using required index")
      return self._optional[optionalIndex]
    }

    fileprivate mutating func addRequired(_ value: PyObject) {
      assert(self._optional.isEmpty, "Required after optional")
      self._required.append(value)
    }

    fileprivate mutating func addOptional(_ value: PyObject?) {
      self._optional.append(value)
    }
  }

  /// static int
  /// vgetargskeywordsfast_impl(PyObject *const *args, Py_ssize_t nargs,
  ///                           PyObject *kwargs, PyObject *kwnames,
  ///                           struct _PyArg_Parser *parser,
  ///                           va_list *p_va, int flags)
  internal func bind(_ py: Py,
                     args: PyObject,
                     kwargs: PyObject?) -> PyResultGen<Binding> {
    let argsArray: [PyObject]
    switch ArgumentParser.unpackArgsTuple(py, args: args) {
    case let .value(o): argsArray = o
    case let .error(e): return .error(e)
    }

    return self.bind(py, args: argsArray, kwargs: kwargs)
  }

  /// static int
  /// vgetargskeywordsfast_impl(PyObject *const *args, Py_ssize_t nargs,
  ///                           PyObject *kwargs, PyObject *kwnames,
  ///                           struct _PyArg_Parser *parser,
  ///                           va_list *p_va, int flags)
  internal func bind(_ py: Py,
                     args: [PyObject],
                     kwargs: PyObject?) -> PyResultGen<Binding> {
    let kwargsData: PyDict?
    switch ArgumentParser.unpackKwargsDict(py, kwargs: kwargs) {
    case let .value(o): kwargsData = o
    case let .error(e): return .error(e)
    }

    return self.bind(py, args: args, kwargs: kwargsData)
  }

  /// static int
  /// vgetargskeywordsfast_impl(PyObject *const *args, Py_ssize_t nargs,
  ///                           PyObject *kwargs, PyObject *kwnames,
  ///                           struct _PyArg_Parser *parser,
  ///                           va_list *p_va, int flags)
  internal func bind(_ py: Py,
                     args: [PyObject],
                     kwargs: PyDict?) -> PyResultGen<Binding> {
    // We do not expect large kwargs dictionaries,
    // so the allocation should be minimal.
    var kwargsDict: [String: PyObject]
    switch ArgumentParser.guaranteeStringKeywords(py, kwargs: kwargs) {
    case let .value(r): kwargsDict = r
    case let .error(e): return .error(e)
    }

    return self.bind(py, args: args, kwargs: kwargsDict)
  }

  /// static int
  /// vgetargskeywordsfast_impl(PyObject *const *args, Py_ssize_t nargs,
  ///                           PyObject *kwargs, PyObject *kwnames,
  ///                           struct _PyArg_Parser *parser,
  ///                           va_list *p_va, int flags)
  internal func bind(_ py: Py,
                     args: [PyObject],
                     kwargs: [String: PyObject]) -> PyResultGen<Binding> {
    if args.count + kwargs.count > self.argumentCount {
      let error = self.tooManyArgumentsError(py, args: args, kwargs: kwargs)
      return .error(error.asBaseException)
    }

    if args.count > self.maxPositionalArgCount {
      let error = self.tooManyPositionalArgumentsError(py, args: args)
      return .error(error.asBaseException)
    }

    var result = Binding()

    for i in 0..<self.argumentCount {
      let isRequired = i < self.requiredArgCount

      // Try to use positional to fill argument at 'i' index
      if i < args.count {
        let value = args[i]
        isRequired ? result.addRequired(value) : result.addOptional(value)
        continue
      }

      // Try to use kwarg to fill argument at 'i' index
      let keywordNameIndex = i - self.positionalOnlyArgCount
      if keywordNameIndex >= 0 {
        let keyword = self.keywordArgNames[keywordNameIndex]
        if let value = kwargs[keyword] {
          isRequired ? result.addRequired(value) : result.addOptional(value)
          continue
        }
      }

      // We have not filled 'i' argument from args or kwargs
      if isRequired {
        let e = self.missingArgumentError(py, argIndex: i, args: args, kwargs: kwargs)
        return .error(e.asBaseException)
      }

      // This is an optional argument, just set it to 'nil'
      result.addOptional(nil)
    }

    // Make sure there are no arguments given by name and position
    if let e = self.checkArgumentGivenAsPositionalAndKwarg(py, args: args, kwargs: kwargs) {
      return .error(e.asBaseException)
    }

    // Make sure there are no extraneous keyword arguments
    if let e = self.checkExtraneousKeywordArguments(py, kwargs: kwargs) {
      return .error(e.asBaseException)
    }

    assert(result._required.count == self.requiredArgCount)
    assert(result._optional.count == self.argumentCount - self.requiredArgCount)
    return .value(result)
  }

  // MARK: - Parsing errors

  private func tooManyArgumentsError(_ py: Py,
                                     args: [PyObject],
                                     kwargs: [String: PyObject]) -> PyTypeError {
    let providedCount = args.count + kwargs.count
    assert(providedCount > self.argumentCount)

    let fn = self.fnName + "()"
    let keyword = args.isEmpty ? "keyword " : ""
    let arguments = self.argumentCount == 1 ? "argument" : "arguments"

    let message = "\(fn) takes at most \(self.argumentCount) " +
                  "\(keyword)\(arguments) (\(providedCount) given)"

    return py.newTypeError(message: message)
  }

  private func tooManyPositionalArgumentsError(_ py: Py,
                                               args: [PyObject]) -> PyTypeError {
    assert(args.count > self.maxPositionalArgCount)

    let fn = self.fnName + "()"
    switch self.maxPositionalArgCount {
    case 0:
      let message = "\(fn) takes no positional arguments"
      return py.newTypeError(message: message)
    case let max:
      let s = self.requiredArgCount == Int.max ? "exactly" : "at most"
      let message = "\(fn) takes \(s) \(max) positional arguments (\(args.count) given)"
      return py.newTypeError(message: message)
    }
  }

  private func missingArgumentError(_ py: Py,
                                    argIndex: Int,
                                    args: [PyObject],
                                    kwargs: [String: PyObject]) -> PyTypeError {
    let fn = self.fnName + "()"

    if argIndex < self.positionalOnlyArgCount {
      let atLeast = self.requiredArgCount < self.maxPositionalArgCount ?
        "at least" :
        "exactly"

      let message = "\(fn) takes \(atLeast) \(self.requiredArgCount) positional arguments " +
                    "(\(args.count) given)"

      return py.newTypeError(message: message)
    }

    let keyword = self.keywordArgNames[argIndex - self.positionalOnlyArgCount]
    let message = "\(fn) missing required argument '\(keyword)' (pos \(argIndex + 1))"
    return py.newTypeError(message: message)
  }

  private func checkArgumentGivenAsPositionalAndKwarg(
    _ py: Py,
    args: [PyObject],
    kwargs: [String: PyObject]
  ) -> PyTypeError? {
    // We are missing some positional args (it may be OK, they may be optional)
    if args.count < self.positionalOnlyArgCount {
      return nil
    }

    for i in self.positionalOnlyArgCount..<args.count {
      let keyword = self.keywordArgNames[i - self.positionalOnlyArgCount]
      if kwargs.contains(keyword) {
        let fn = self.fnName + "()"
        let message = "argument for \(fn) given by name ('\(keyword)') and position (\(i + 1))"
        return py.newTypeError(message: message)
      }
    }

    return nil
  }

  private func checkExtraneousKeywordArguments(_ py: Py,
                                               kwargs: [String: PyObject]) -> PyTypeError? {

    for key in kwargs.keys {
      if !self.keywordArgNames.contains(key) {
        let message = "'\(key)' is an invalid keyword argument for \(self.fnName)()"
        return py.newTypeError(message: message)
      }
    }

    return nil
  }

  // MARK: - Unpack

  internal static func unpackArgsTuple(_ py: Py,
                                       args: PyObject) -> PyResultGen<[PyObject]> {
    guard let tuple = py.cast.asTuple(args) else {
      let msg = "Function positional arguments should be a tuple, not \(args.typeName)"
      return .typeError(py, message: msg)
    }

    return .value(tuple.elements)
  }

  internal static func unpackKwargsDict(_ py: Py,
                                        kwargs: PyObject?) -> PyResultGen<PyDict?> {
    guard let kwargs = kwargs else {
      return .value(nil)
    }

    guard let kwargsDict = py.cast.asDict(kwargs) else {
      let msg = "Function keyword arguments should be a dict, not \(kwargs.typeName)"
      return .typeError(py, message: msg)
    }

    return .value(kwargsDict)
  }

  // MARK: - Arg count

  /// int
  /// PyArg_UnpackTuple(PyObject *args,
  ///                   const char *name,
  ///                   Py_ssize_t min, Py_ssize_t max, ...)
  internal static func guaranteeArgsCountOrError(_ py: Py,
                                                 fnName: String,
                                                 args: [PyObject],
                                                 min: Int,
                                                 max: Int) -> PyTypeError? {
    assert(min >= 0)
    assert(max >= 0)
    assert(min <= max)

    let nargs = args.count

    if min == 0 && max == 0 && args.any {
      let message = "\(fnName) takes no positional arguments, got \(nargs)"
      return py.newTypeError(message: message)
    }

    if nargs < min {
      let s = min == max ? "" : "at least "
      let message = "\(fnName) expected \(s)\(max) arguments, got \(nargs)"
      return py.newTypeError(message: message)
    }

    if nargs == 0 {
      return nil
    }

    if nargs > max {
      let s = min == max ? "" : "at most "
      let message = "\(fnName) expected \(s)\(max) arguments, got \(nargs)"
      return py.newTypeError(message: message)
    }

    return nil
  }

  /// int
  /// _PyArg_NoKeywords(const char *funcname, PyObject *kwargs)
  internal static func noKwargsOrError(_ py: Py,
                                       fnName: String,
                                       kwargs: PyDict?) -> PyTypeError? {
    let noKwargs = kwargs?.elements.isEmpty ?? true
    if noKwargs {
      return nil
    }

    let message = "\(fnName) takes no keyword arguments"
    return py.newTypeError(message: message)
  }

  // MARK: - String keywords

  internal typealias NameToValue = [String: PyObject]

  /// int
  /// PyArg_ValidateKeywordArguments(PyObject *kwargs)
  internal static func guaranteeStringKeywords(_ py: Py,
                                               kwargs: PyDict?) -> PyResultGen<NameToValue> {

    switch kwargs {
    case .some(let kwargs):
      return ArgumentParser.guaranteeStringKeywords(py, kwargs: kwargs)
    case .none:
      return .value([:])
    }
  }

  /// int
  /// PyArg_ValidateKeywordArguments(PyObject *kwargs)
  internal static func guaranteeStringKeywords(_ py: Py,
                                               kwargs: PyDict) -> PyResultGen<NameToValue> {

    var result = [String: PyObject]()

    for entry in kwargs.elements {
      switch py.cast.asString(entry.key.object) {
      case let .some(keyString):
        result[keyString.value] = entry.value
      case .none:
        return .typeError(py, message: "keywords must be strings")
      }
    }

    return .value(result)
  }

  // MARK: - Dump

  /// For debug
  @available(*, deprecated, message: "Only for debug. Remove after.")
  internal func dump() {
    print("fnName: \(self.fnName)")
    print("requiredArgCount: \(self.requiredArgCount)")
    print("positionalOnlyArgCount: \(self.positionalOnlyArgCount)")
    print("maxPositionalArgCount: \(self.maxPositionalArgCount)")
    print("keywordArgNames: \(self.keywordArgNames)")
    print("total argumentCount: \(self.argumentCount)")
  }
}
