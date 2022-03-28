import Foundation
import BigInt
import FileSystem
import VioletCore
import VioletBytecode

// swiftlint:disable function_parameter_count

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

private let sourceFileEncoding = PyString.Encoding.utf8

extension Py {

  // MARK: - Options

  /// What/why are we parsing?
  ///
  /// What is the meaning of life? 42?
  public enum ParserMode {
    /// Used for input in interactive mode.
    case interactive
    /// Used for all input read from non-interactive files.
    case fileInput
    /// Used for `eval()`.
    case eval

    /// The same as `fileInput`.
    public static var exec: ParserMode { return .fileInput }

    /// The same as `interactive`.
    public static var single: ParserMode { return .interactive }
  }

  public enum OptimizationLevel: Equatable, Comparable {
    /// No optimizations.
    case none
    /// Remove assert statements and any code conditional on the value of `__debug__`.
    /// Command line: `-O`.
    case O
    /// Do `-O` and also discard `docstrings`.
    /// Command line: `-OO`.
    case OO
  }

  public enum OptimizationLevelArg {
    case none
    case O
    case OO
    case fromSys
  }

  // MARK: - Compile

  /// compile(source, filename, mode, flags=0, dont_inherit=False, optimize=-1)
  /// See [this](https://docs.python.org/3/library/functions.html#compile)
  ///
  /// static PyObject *
  /// builtin_compile_impl(PyObject *module, PyObject *source, ...)
  public func compile(source sourceArg: PyObject,
                      filename filenameArg: PyObject,
                      mode modeArg: PyObject,
                      flags: PyObject?,
                      dontInherit: PyObject?,
                      optimize optimizeArg: PyObject?) -> PyResultGen<PyCode> {
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

    let optimize: OptimizationLevelArg
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
                      mode: ParserMode,
                      optimize: OptimizationLevelArg) -> PyResultGen<PyCode> {
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

  public func compile(source: String,
                      filename: String,
                      mode: ParserMode,
                      optimize: OptimizationLevelArg) -> PyResultGen<PyCode> {
    let optimizationLevel: OptimizationLevel
    switch optimize {
    case .none: optimizationLevel = .none
    case .O: optimizationLevel = .O
    case .OO: optimizationLevel = .OO
    case .fromSys: optimizationLevel = self.sys.flags.optimize
    }

    return self.delegate.compile(self,
                                 source: source,
                                 filename: filename,
                                 mode: mode,
                                 optimize: optimizationLevel)
  }

  // MARK: - Source

  internal enum ReadSourceFileResult {
    case value(String)
    /// Error when reading a file (it may not exist etc.)
    case readError(PyBaseException)
    /// File exists but we cant read it
    case decodingError(PyBaseException)
  }

  internal func readSourceFile(path: Path) -> ReadSourceFileResult {
    let data: Data
    switch self.fileSystem.read(self, path: path) {
    case let .value(d): data = d
    case let .error(e): return .readError(e)
    }

    guard let source = sourceFileEncoding.decode(data: data) else {
      let e = self.newUnicodeDecodeError(data: data, encoding: sourceFileEncoding)
      return .decodingError(e.asBaseException)
    }

    return .value(source)
  }

  private func parseStringArg(argumentIndex index: Int,
                              arg: PyObject) -> PyResultGen<String> {
    switch self.getString(object: arg, encoding: .default) {
    case .string(_, let s),
         .bytes(_, let s):
      return .value(s)
    case .byteDecodingError:
      return .typeError(self, message: "compile(): cannot decode arg \(index) as string")
    case .notStringOrBytes:
      return .typeError(self, message: "compile(): arg \(index) must be a string or bytes object")
    }
  }

  // MARK: - Parse mode

  private func parseMode(arg: PyObject) -> PyResultGen<ParserMode> {
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

  // MARK: - Parse optimize

  private func parseOptimize(arg: PyObject?) -> PyResultGen<OptimizationLevelArg> {
    // The argument optimize specifies the optimization level of the compiler;
    // the default value of -1 selects the optimization level of the interpreter
    // as given by -O options.

    guard let arg = arg else {
      return .value(.fromSys)
    }

    guard let int = self.cast.asInt(arg) else {
      return .typeError(self, message: "compile(): optimize must be an int")
    }

    switch int.value {
    case -1:
      return .value(.fromSys)
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
