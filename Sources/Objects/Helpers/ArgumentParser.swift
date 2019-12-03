import Core

// In CPython:
// Objects -> modsupport.h
// Objects -> getargs.c

// This code is quite complicated, but most of the time it is just line-by-line
// copy of CPython.

// swiftlint:disable file_length

/// Structure responsible for binding runtime parameters to function signature.
/// In CPython `typedef struct _PyArg_Parser`.
///
/// Most of the time it should use static allocation.
internal struct ArgumentParser {

  /// Function name
  private let fnName: String
  /// Minimal number of arguments needed to call the function.
  /// `min` in Cpython.
  private let minArgCount: Int
  /// Number of positional-only arguments.
  /// `pos` in CPython.
  private let positionalArgCount: Int
  /// Maximal number of positional-only arguments.
  /// `max` in CPython.
  private let maxPositionalArgCount: Int
  /// Keyword parameter names.
  /// `kwtuple` in CPython.
  private let keywordArgNames: [String]

  /// `len` in CPython.
  /// `self.positionalArgCount + self.keywordArgNames.count`
  private var argumentCount: Int {
    return self.positionalArgCount + self.keywordArgNames.count
  }

  // MARK: - Create

  /// Create new ArgumentParser.
  ///
  /// We will reuse CPython format/convention.
  /// Mostly because this way we can just compare code/format specifiers
  /// to check for errors. We could write this ouselves, but why?
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
  /// - Parameter fnName: Function name
  /// - Parameter arguments: Argument names. But only for keyword arguments.
  ///                        Positional arguments should use empty string.
  ///                        For example: `["", "base"]`.
  /// - Parameter format: Argument formats:
  ///                     - `|` - end of required arguments (minArgCount)
  ///                     - `$` - end of positional arguments (maxPositionalArgCount)
  ///                     - other - ignored
  ///                     For example: `|OO`.
  internal static func create(arguments: [String],
                              format: String) -> PyResult<ArgumentParser> {
    let name: String
    switch ArgumentParser.extractFunctionName(format: format) {
    case let .value(n): name = n
    case let .error(e): return .error(e)
    }

    let firstKeywordArgIndex = arguments.firstIndex { !$0.isEmpty }
    let positionalArgCount = firstKeywordArgIndex ?? arguments.count

    var keywordArgumentNames = [String]()
    if let keywordStart = firstKeywordArgIndex {
      keywordArgumentNames = Array(arguments[keywordStart...])
      let hasKeywordWithoutName = keywordArgumentNames.contains { $0.isEmpty }
      if hasKeywordWithoutName {
        return .systemError("Empty keyword parameter name")
      }
    }

    let parsedFormat: ParsedFormat
    switch ArgumentParser.parseFormat(format: format,
                                      argCount: arguments.count,
                                      positionalArgCount: positionalArgCount) {
    case let .value(f): parsedFormat = f
    case let .error(e): return .error(e)
    }

    return .value(
      ArgumentParser(
        fnName: name,
        minArgCount: Swift.min(parsedFormat.min, arguments.count),
        positionalArgCount: positionalArgCount,
        maxPositionalArgCount: Swift.min(parsedFormat.max, arguments.count),
        keywordArgNames: keywordArgumentNames
      )
    )
  }

  /// Create parser using `ArgumentParser.create` or `fatalError`.
  internal static func createOrFatal(arguments: [String],
                                     format: String) -> ArgumentParser {
    switch ArgumentParser.create(arguments: arguments, format: format) {
    case let .value(r):
      return r
    case let .error(e):
      fatalError(String(describing: e))
    }
  }

  /// Function name starts after ':' in format.
  private static func extractFunctionName(format: String) -> PyResult<String> {
    guard var startIndex = format.firstIndex(of: ":") else {
      return .systemError("Format does not contain function name")
    }

    // Go after ':'
    format.formIndex(after: &startIndex) // after ':'
    if startIndex == format.endIndex {
      return .systemError("Format does not contain function name")
    }

    return .value(String(format[startIndex...]))
  }

  private struct ParsedFormat {
    fileprivate let min: Int
    fileprivate let max: Int
  }

  private static func parseFormat(format: String,
                                  argCount: Int,
                                  positionalArgCount: Int) -> PyResult<ParsedFormat> {
    var minArgCount = Int.max
    var maxPositionalArgCount = Int.max

    var formatIndex = format.startIndex
    for i in 0..<argCount {
      if formatIndex == format.endIndex {
        let msg = "More keyword list entries (\(argCount)) than format specifiers (\(i))"
        return .systemError(msg)
      }

      if format[formatIndex] == "|" {
        if minArgCount != Int.max {
          return .systemError("Invalid format string (| specified twice)")
        }
        if maxPositionalArgCount != Int.max {
          return .systemError("Invalid format string ($ before |)")
        }

        minArgCount = i
        format.formIndex(after: &formatIndex)
      }

      if format[formatIndex] == "$" {
        if maxPositionalArgCount != Int.max {
          return .systemError("Invalid format string ($ specified twice)")
        }
        if i < positionalArgCount {
          return .systemError( "Empty parameter name after $")
        }

        maxPositionalArgCount = i
        format.formIndex(after: &formatIndex)
      }

      // We expect argument formatter (for example 'O') here
      if formatIndex == format.endIndex || isFormatEnd(format[formatIndex]) {
        let msg = "More keyword list entries (\(argCount)) than format specifiers (\(i))"
        return .systemError(msg)
      }

      format.formIndex(after: &formatIndex)
    }

    if formatIndex != format.endIndex && !isFormatEnd(format[formatIndex]) {
      return .systemError("More argument specifiers than keyword list entries")
    }

    return .value(ParsedFormat(min: minArgCount, max: maxPositionalArgCount))
  }

  private static func isFormatEnd(_ c: Character) -> Bool {
    return c == ";" || c == ":"
  }

  // MARK: - Parse

  /// static int
  /// vgetargskeywordsfast_impl(PyObject *const *args, Py_ssize_t nargs,
  ///                           PyObject *kwargs, PyObject *kwnames,
  ///                           struct _PyArg_Parser *parser,
  ///                           va_list *p_va, int flags)
  internal func parse(args: PyObject,
                      kwargs: PyObject?) -> PyResult<[PyObject]> {
    let argsArray: [PyObject]
    switch ArgumentParser.unpackArgsTuple(args: args) {
    case let .value(o): argsArray = o
    case let .error(e): return .error(e)
    }

    let kwargsData: PyDictData?
    switch ArgumentParser.unpackKwargsDict(kwargs: kwargs) {
    case let .value(o): kwargsData = o
    case let .error(e): return .error(e)
    }

    return self.parse(args: argsArray, kwargs: kwargsData)
  }

  /// static int
  /// vgetargskeywordsfast_impl(PyObject *const *args, Py_ssize_t nargs,
  ///                           PyObject *kwargs, PyObject *kwnames,
  ///                           struct _PyArg_Parser *parser,
  ///                           va_list *p_va, int flags)
  internal func parse(args: [PyObject],
                      kwargs: PyDictData?) -> PyResult<[PyObject]> {
    // We do not expect large kwargs dictionaries,
    // so the allocation should be minimal.
    var kwargsDict = [String:PyObject]()

    if let kwargs = kwargs {
      for entry in kwargs {
        switch entry.key.object as? PyString {
        case let .some(keyString):
          kwargsDict[keyString.value] = entry.value
        case .none:
          return .typeError("keywords must be strings")
        }
      }
    }

    return self.parse(args: args, kwargs: kwargsDict)
  }

  // swiftlint:disable cyclomatic_complexity

  /// static int
  /// vgetargskeywordsfast_impl(PyObject *const *args, Py_ssize_t nargs,
  ///                           PyObject *kwargs, PyObject *kwnames,
  ///                           struct _PyArg_Parser *parser,
  ///                           va_list *p_va, int flags)
  internal func parse(args: [PyObject],
                      kwargs: [String:PyObject]) -> PyResult<[PyObject]> {
    // swiftlint:enable cyclomatic_complexity

    if args.count + kwargs.count > self.argumentCount {
      return .error(self.tooMuchArgumentsError(args: args, kwargs: kwargs))
    }

    if args.count > self.maxPositionalArgCount {
      return .error(self.tooMuchPositionalArgumentsError(args: args))
    }

    var result = [PyObject]()
    var remainingKwargArgs = kwargs.count

    for i in 0..<self.argumentCount {
      // Use as many positional arguments as we can
      // (we could move it before loop, but we want to stay the same as CPython)
      if i < args.count {
        result.append(args[i])
        continue
      }

      if i >= self.positionalArgCount && remainingKwargArgs > 0 {
        let keyword = self.keywordArgNames[i - self.positionalArgCount]
        if let arg = kwargs[keyword] {
          result.append(arg)
          remainingKwargArgs -= 1
          continue
        }
      }

      // We are missing positional OR we don't have enough kwargs
      // OR we have already finished.

      let hasAllRequiredArguments = i >= self.minArgCount
      guard hasAllRequiredArguments else {
        return .error(self.missingArgumentError(argIndex: i, args: args, kwargs: kwargs))
      }

      // Current code reports success when all required args are fulfilled
      // and no keyword args left with no further validation.
      if remainingKwargArgs == 0 {
        return .value(result)
      }
    }

    if remainingKwargArgs > 0 {
      // Make sure there are no arguments given by name and position
      if let e = self.checkArgumentGivenAsPositionalAndKwarg(args: args, kwargs: kwargs) {
        return .error(e)
      }

      // Make sure there are no extraneous keyword arguments
      if let e = self.checkExtraneousKeywordArguments(kwargs: kwargs) {
        return .error(e)
      }
    }

    return .value(result)
  }

  // MARK: - Parsing errors

  private func tooMuchArgumentsError(args: [PyObject],
                                     kwargs: [String:PyObject]) -> PyErrorEnum {
    let providedCount = args.count + kwargs.count
    assert(providedCount > self.argumentCount)

    let fn = self.fnName + "()"
    let keyword = args.isEmpty ? "keyword " : ""
    let arguments = self.argumentCount == 1 ? "argument" : "arguments"

    let msg = "\(fn) takes at most \(self.argumentCount) " +
              "\(keyword)\(arguments) " +
              "(\(providedCount) given)"

    return .typeError(msg)
  }

  private func tooMuchPositionalArgumentsError(args: [PyObject]) -> PyErrorEnum {
    assert(args.count > self.maxPositionalArgCount)

    let fn = self.fnName + "()"
    switch self.maxPositionalArgCount {
    case 0:
      return .typeError("\(fn) takes no positional arguments")
    case let max:
      let s = self.minArgCount == Int.max ? "exactly" : "at most"
      let msg = "\(fn) takes \(s) \(max) positional arguments (\(args.count) given)"
      return .typeError(msg)
    }
  }

  private func missingArgumentError(argIndex: Int,
                                    args: [PyObject],
                                    kwargs: [String:PyObject]) -> PyErrorEnum {
    let fn = self.fnName + "()"

    if argIndex < self.positionalArgCount {
      let s = self.minArgCount < self.maxPositionalArgCount ? "at least" : "exactly"
      let msg = "\(fn) takes \(s) \(minArgCount) positional arguments (\(args.count) given)"
      return .typeError(msg)
    }

    let keyword = self.keywordArgNames[argIndex - self.positionalArgCount]
    let msg = "\(fn) missing required argument '\(keyword)' (pos \(argIndex + 1))"
    return .typeError(msg)
  }

  private func checkArgumentGivenAsPositionalAndKwarg(args: [PyObject],
                                                      kwargs: [String:PyObject]) -> PyErrorEnum? {
    for i in self.positionalArgCount..<args.count {
      let keyword = self.keywordArgNames[i - self.positionalArgCount]
      if kwargs.contains(keyword) {
        let fn = self.fnName + "()"
        let msg = "argument for \(fn) given by name ('\(keyword)') and position (\(i + 1))"
        return .typeError(msg)
      }
    }

    return nil
  }

  private func checkExtraneousKeywordArguments(kwargs: [String:PyObject]) -> PyErrorEnum? {
    for key in kwargs.keys {
      if !self.keywordArgNames.contains(key) {
        let fn = self.fnName + "()"
        let msg = "'\(key)' is an invalid keyword argument for \(fn)"
        return .typeError(msg)
      }
    }

    return nil
  }

  // MARK: - Unpack

  internal static func unpackArgsTuple(args: PyObject) -> PyResult<[PyObject]> {
    guard let tuple = args as? PyTuple else {
      let t = args.typeName
      return .typeError("Function positional arguments should be a tuple, not \(t)")
    }

    return .value(tuple.elements)
  }

  internal static func unpackKwargsDict(kwargs: PyObject?) -> PyResult<PyDictData?> {
    guard let kwargs = kwargs else {
      return .value(nil)
    }

    guard let kwargsDict = kwargs as? PyDict else {
      let t = kwargs.typeName
      return .typeError("Function keyword arguments should be a dict, not \(t)")
    }

    return .value(kwargsDict.data)
  }

  // MARK: - Unpack

  /// int
  /// PyArg_UnpackTuple(PyObject *args,
  ///                   const char *name,
  ///                   Py_ssize_t min, Py_ssize_t max, ...)
  internal static func guaranteeArgsCountOrError(fnName: String,
                                                 args: [PyObject],
                                                 min: Int,
                                                 max: Int) -> PyErrorEnum? {
    let nargs = args.count

    if nargs < min {
      let s = min == max ? "" : "at least "
      return . typeError("\(fnName) expected \(s)\(max) arguments, got \(nargs)")
    }

    if nargs == 0 {
      return nil
    }

    if nargs > max {
      let s = min == max ? "" : "at most "
      return .typeError("\(fnName) expected \(s)\(max) arguments, got \(nargs)")
    }

    return nil
  }

  // MARK: - No keywords

  /// int
  /// _PyArg_NoKeywords(const char *funcname, PyObject *kwargs)
  internal static func noKwargsOrError(fnName: String,
                                       kwargs: PyDictData?) -> PyErrorEnum? {
    guard let kwargs = kwargs, kwargs.isEmpty else {
      return nil
    }

    return .typeError("\(fnName) takes no keyword arguments")
  }

  // MARK: - Dump

  /// For debug
  @available(*, deprecated, message: "Only for debug. Remove after.")
  internal func dump() {
    print("fnName: \(self.fnName)")
    print("minArgCount: \(self.minArgCount)")
    print("positionalArgCount: \(self.positionalArgCount)")
    print("maxPositionalArgCount: \(self.maxPositionalArgCount)")
    print("keywordArgNames: \(self.keywordArgNames)")
    print("total argumentCount: \(self.argumentCount)")
  }
}
