/* MARKER
import Foundation
import BigInt
import FileSystem
import VioletCore
import VioletLexer
import VioletParser
import VioletBytecode
import VioletCompiler

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

private let sourceFileEncoding = PyString.Encoding.utf8

extension Py {

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
                      optimize optimizeArg: PyObject? = nil) -> CompileResult {
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

    let mode: Parser.Mode
    switch self.parseMode(arg: modeArg) {
    case let .value(m): mode = m
    case let .error(e): return .error(e)
    }

    // We will ignore 'flags' and 'dont_inherit'.

    let optimize: Compiler.OptimizationLevel
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
  public func compile(path: Path,
                      mode: Parser.Mode,
                      optimize: Compiler.OptimizationLevel? = nil) -> CompileResult {
    let source: String
    switch self.readSourceFile(path: path) {
    case let .value(s):
      source = s
    case let .readError(e),
         let .decodingError(e):
      return .error(e)
    }

    let filename = self.fileSystem.basename(path: path)
    return self.compile(source: source,
                        filename: filename.string,
                        mode: mode,
                        optimize: optimize)
  }

  internal enum ReadSourceFileResult {
    case value(String)
    /// Error when reading a file (it may not exist etc.)
    case readError(PyBaseException)
    /// File exists but we cant read it
    case decodingError(PyBaseException)
  }

  internal func readSourceFile(path: Path) -> ReadSourceFileResult {
    let data: Data
    switch self.fileSystem.read(path: path) {
    case let .value(d): data = d
    case let .error(e): return .readError(e)
    }

    guard let source = sourceFileEncoding.decode(data: data) else {
      let e = self.newUnicodeDecodeError(data: data, encoding: sourceFileEncoding)
      return .decodingError(e)
    }

    return .value(source)
  }

  public enum CompileResult {
    /// Code compiled successfully (Yay!)
    case code(PyCode)

    /// Lexer warning that should be treated as error OR error when printing
    case lexerWarning(LexerWarning, PyBaseException)
    /// Lexing failed
    case lexerError(LexerError, PyBaseException)

    /// Parser warning that should be treated as error OR error when printing
    case parserWarning(ParserWarning, PyBaseException)
    /// Parsing failed
    case parserError(ParserError, PyBaseException)

    /// Compiler warning that should be treated as error OR error when printing
    case compilerWarning(CompilerWarning, PyBaseException)
    /// Compiling failed
    case compilerError(CompilerError, PyBaseException)

    /// Non lexer, parser or compiler error
    case error(PyBaseException)

    public func asResult() -> PyResult<PyCode> {
      switch self {
      case let .code(c):
        return .value(c)
      case let .lexerWarning(_, e),
           let .lexerError(_, e),
           let .parserWarning(_, e),
           let .parserError(_, e),
           let .compilerWarning(_, e),
           let .compilerError(_, e),
           let .error(e):
        return .error(e)
      }
    }
  }

  private class WarningsHandler: LexerDelegate, ParserDelegate, CompilerDelegate {

    fileprivate private(set) var lexerWarnings = [LexerWarning]()
    fileprivate private(set) var parserWarnings = [ParserWarning]()
    fileprivate private(set) var compilerWarnings = [CompilerWarning]()

    fileprivate func warn(warning: LexerWarning) {
      self.lexerWarnings.append(warning)
    }

    fileprivate func warn(warning: ParserWarning) {
      self.parserWarnings.append(warning)
    }

    fileprivate func warn(warning: CompilerWarning) {
      self.compilerWarnings.append(warning)
    }
  }

  // swiftlint:disable:next function_body_length
  public func compile(source: String,
                      filename: String,
                      mode: Parser.Mode,
                      optimize: Compiler.OptimizationLevel? = nil) -> CompileResult {
    do {
      let delegate = WarningsHandler()

      // Parser phase
      let lexer = Lexer(for: source, delegate: delegate)
      let parser = Parser(mode: mode,
                          tokenSource: lexer,
                          delegate: delegate,
                          lexerDelegate: delegate)
      let ast = try parser.parse()

      for warning in delegate.lexerWarnings {
        if let e = self.warn(filename: filename, warning: warning) {
          return .lexerWarning(warning, e)
        }
      }

      for warning in delegate.parserWarnings {
        if let e = self.warn(filename: filename, warning: warning) {
          return .parserWarning(warning, e)
        }
      }

      // Compiler phase
      let compilerOptions = Compiler.Options(
        optimizationLevel: optimize ?? self.optimizeFromSysFlags
      )

      let compiler = Compiler(filename: filename,
                              ast: ast,
                              options: compilerOptions,
                              delegate: delegate)
      let code = try compiler.run()

      for warning in delegate.compilerWarnings {
        if let e = self.warn(filename: filename, warning: warning) {
          return .compilerWarning(warning, e)
        }
      }

      let result = self.newCode(code: code)
      return .code(result)
    } catch let e as LexerError {
      return .lexerError(e, self.newSyntaxError(filename: filename, error: e))
    } catch let e as ParserError {
      return .parserError(e, self.newSyntaxError(filename: filename, error: e))
    } catch let e as CompilerError {
      return .compilerError(e, self.newSyntaxError(filename: filename, error: e))
    } catch {
      let msg = "Error when compiling '\(filename)': '\(error)'"
      return .error(self.newRuntimeError(msg: msg))
    }
  }

  // MARK: - Source

  private func parseStringArg(argumentIndex index: Int,
                              arg: PyObject) -> PyResult<String> {
    switch self.getString(object: arg) {
    case .string(_, let s),
         .bytes(_, let s):
      return .value(s)
    case .byteDecodingError:
      return .typeError(self, message: "compile(): cannot decode arg \(index) as string")
    case .notStringOrBytes:
      return .typeError(self, message: "compile(): arg \(index) must be a string or bytes object")
    }
  }

  // MARK: - Mode

  private func parseMode(arg: PyObject) -> PyResult<Parser.Mode> {
    guard let string = self.cast.asString(arg) else {
      return .typeError(self, message: "compile(): mode must be an str")
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

    return .typeError(self, message: "compile() mode must be 'exec', 'eval' or 'single'")
  }

  // MARK: - Optimize

  private var optimizeFromSysFlags: Compiler.OptimizationLevel {
    return self.sys.flags.optimize
  }

  private func parseOptimize(arg: PyObject?) -> PyResult<Compiler.OptimizationLevel> {
    // The argument optimize specifies the optimization level of the compiler;
    // the default value of -1 selects the optimization level of the interpreter
    // as given by -O options.

    guard let arg = arg else {
      return .value(self.optimizeFromSysFlags)
    }

    guard let int = self.cast.asInt(arg) else {
      return .typeError(self, message: "compile(): optimize must be an int")
    }

    switch int.value {
    case -1:
      return .value(self.optimizeFromSysFlags)
    case 0:
      return .value(.none)
    case 1:
      return .value(.O)
    case 2:
      return .value(.OO)
    default:
      return .valueError(self, message: "compile(): invalid optimize value")
    }
  }
}

*/
