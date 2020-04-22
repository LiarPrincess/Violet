import Core
import Lexer
import Parser
import Compiler
import Bytecode
import Foundation

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// MARK: - Helpers

private class WarningsHandler:
  LexerDelegate, ParserDelegate, CompilerDelegate {

  fileprivate let filename: String
  fileprivate private(set) var lexerWarnings = [LexerWarning]()
  fileprivate private(set) var parserWarnings = [ParserWarning]()
  fileprivate private(set) var compilerWarnings = [CompilerWarning]()

  fileprivate init(filename: String) {
    self.filename = filename
  }

  fileprivate func warn(warning: LexerWarning) {
    self.lexerWarnings.append(warning)
  }

  fileprivate func warn(warning: ParserWarning) {
    self.parserWarnings.append(warning)
  }

  fileprivate func warn(warning: CompilerWarning) {
    self.compilerWarnings.append(warning)
  }

  fileprivate func printParserWarnings() -> PyBaseException? {
    for warning in self.lexerWarnings {
      if let e = Py.warn(filename: self.filename, warning: warning) {
        return e
      }
    }

    for warning in self.parserWarnings {
      if let e = Py.warn(filename: self.filename, warning: warning) {
        return e
      }
    }

    return nil
  }

  fileprivate func printCompilerWarnings() -> PyBaseException? {
    for warning in self.compilerWarnings {
      if let e = Py.warn(filename: self.filename, warning: warning) {
        return e
      }
    }

    return nil
  }
}

// MARK: - Compile

extension PyInstance {

  /// compile(source, filename, mode, flags=0, dont_inherit=False, optimize=-1)
  /// See [this](https://docs.python.org/3/library/functions.html#compile)
  ///
  /// static PyObject *
  /// builtin_compile_impl(PyObject *module, PyObject *source, ...)
  public func compile(source sourceArg: PyObject,
                      filename filenameArg: PyObject,
                      mode modeArg: PyObject,
                      flags: PyObject? = nil,
                      dontInherit: PyObject? = nil,
                      optimize optimizeArg: PyObject? = nil) -> PyResult<PyCode> {
    let source: String
    switch self.parseStringArg(argumentIndex: 1, arg: sourceArg) {
    case let .value(s): source = s
    case let .error(e): return .error(e)
    }

    let filename: String
    switch self.parseStringArg(argumentIndex: 2, arg: filenameArg) {
    case let .value(s): filename = s
    case let .error(e): return .error(e)
    }

    let mode: ParserMode
    switch self.parseMode(arg: modeArg) {
    case let .value(m): mode = m
    case let .error(e): return .error(e)
    }

    // We will ignore 'flags' and 'dont_inherit'.

    let optimize: OptimizationLevel
    switch self.parseOptimize(arg: optimizeArg) {
    case let .value(o): optimize = o
    case let .error(e): return .error(e)
    }

    return self.compile(source: source,
                        filename: filename,
                        mode: mode,
                        optimize: optimize)
  }

  /// Compile object at a given `path`.
  public func compile(path: String,
                      mode: ParserMode,
                      optimize: OptimizationLevel? = nil) -> PyResult<PyCode> {
    let data: Data
    switch self.fileSystem.read(path: path) {
    case let .value(d): data = d
    case let .error(e): return .error(e)
    }

    let encoding = PyStringEncoding.default
    guard let source = String(data: data, encoding: encoding.swift) else {
      let e = self.newUnicodeDecodeError(data: data, encoding: encoding)
      return .error(e)
    }

    let filename = self.fileSystem.basename(path: path)

    return self.compile(
      source: source,
      filename: filename,
      mode: mode,
      optimize: optimize
    )
  }

  public func compile(source: String,
                      filename: String,
                      mode: ParserMode,
                      optimize: OptimizationLevel? = nil) -> PyResult<PyCode> {
    do {
      let delegate = WarningsHandler(filename: filename)

      let lexer = Lexer(for: source, delegate: delegate)
      let parser = Parser(mode: mode,
                          tokenSource: lexer,
                          delegate: delegate,
                          lexerDelegate: delegate)
      let ast = try parser.parse()

      if let e = delegate.printParserWarnings() {
        return .error(e)
      }

      let compilerOptions = CompilerOptions(
        optimizationLevel: optimize ?? self.sys.flags.optimize
      )

      let compiler = Compiler(filename: filename,
                              ast: ast,
                              options: compilerOptions,
                              delegate: delegate)
      let code = try compiler.run()

      if let e = delegate.printCompilerWarnings() {
        return .error(e)
      }

      return .value(self.newCode(code: code))
    } catch {
      if let e = error as? LexerError {
        return .error(self.newSyntaxError(filename: filename, error: e))
      }

      if let e = error as? ParserError {
        return .error(self.newSyntaxError(filename: filename, error: e))
      }

      if let e = error as? CompilerError {
        return .error(self.newSyntaxError(filename: filename, error: e))
      }

      let msg = String(describing: error)
      let e = self.newRuntimeError(msg: "Error when compiling '\(filename)': '\(msg)'")
      return .error(e)
    }
  }

  // MARK: - Source

  private func parseStringArg(argumentIndex index: Int,
                              arg: PyObject) -> PyResult<String> {
    switch self.extractString(object: arg) {
    case .string(_, let s),
         .bytes(_, let s):
      return .value(s)
    case .byteDecodingError:
      return .typeError("compile(): cannot decode arg \(index) as string")
    case .notStringOrBytes:
      return .typeError("compile(): arg \(index) must be a string or bytes object")
    }
  }

  // MARK: - Mode

  private func parseMode(arg: PyObject) -> PyResult<ParserMode> {
    guard let string = arg as? PyString else {
      return .typeError("compile(): mode must be an str")
    }

    if string.isEqual("exec") {
      return .value(.exec)
    }

    if string.isEqual("eval") {
      return .value(.eval)
    }

    if string.isEqual("single") {
      return .value(.single)
    }

    return .typeError("compile() mode must be 'exec', 'eval' or 'single'")
  }

  // MARK: - Optimize

  private var optimizeFromArgumentsOrEnvironment: OptimizationLevel {
    return self.sys.flags.optimize
  }

  private func parseOptimize(arg: PyObject?) -> PyResult<OptimizationLevel> {
    // The argument optimize specifies the optimization level of the compiler;
    // the default value of -1 selects the optimization level of the interpreter
    // as given by -O options.

    guard let arg = arg else {
      return .value(self.optimizeFromArgumentsOrEnvironment)
    }

    guard let int = arg as? PyInt else {
      return .typeError("compile(): optimize must be an int")
    }

    switch int.value {
    case -1:
      return .value(self.optimizeFromArgumentsOrEnvironment)
    case 0:
      return .value(.none)
    case 1:
      return .value(.O)
    case 2:
      return .value(.OO)
    default:
      return .valueError("compile(): invalid optimize value")
    }
  }
}
