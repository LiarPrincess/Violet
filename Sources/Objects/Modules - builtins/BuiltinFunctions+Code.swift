import Core
import Lexer
import Parser
import Compiler
import Bytecode
import Foundation

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// swiftlint:disable file_length

extension BuiltinFunctions {

  // MARK: - Function

  public func newFunction(qualname: PyObject,
                          code: PyObject,
                          globals: PyDict) -> PyResult<PyFunction> {
    guard let codeValue = code as? PyCode else {
      let t = code.typeName
      return .typeError("function() code must be code, not \(t)")
    }

    let qualnameValue: String?
    if qualname is PyNone {
      qualnameValue = nil
    } else if let q = qualname as? PyString {
      qualnameValue = q.value
    } else {
      let t = qualname.typeName
      return .typeError("function() qualname must be None or string, not \(t)")
    }

    let result = self.newFunction(qualname: qualnameValue,
                                  code: codeValue,
                                  globals: globals)

    return .value(result)
  }

  public func newFunction(qualname: String?,
                          code: PyCode,
                          globals: PyDict) -> PyFunction {
    let module = globals.get(id: .__name__) ?? Py.none

    return PyFunction(
      qualname: qualname,
      module: module,
      code: code,
      globals: globals
    )
  }

  // MARK: - Method

  public func newMethod(fn: PyObject, object: PyObject) -> PyResult<PyMethod> {
    guard let f = fn as? PyFunction else {
      return .typeError("method() func must be function, not \(fn.typeName)")
    }

    let result = self.newMethod(fn: f, object: object)
    return .value(result)
  }

  public func newMethod(fn: PyFunction, object: PyObject) -> PyMethod {
    return PyMethod(fn: fn, object: object)
  }

  // MARK: - Module

  public func newModule(name: String, doc: String? = nil) -> PyModule {
    let n = Py.getInterned(name)
    let d = doc.map(self.newString)
    return self.newModule(name: n, doc: d)
  }

  public func newModule(name: PyObject, doc: PyObject? = nil) -> PyModule {
    return PyModule(name: name, doc: doc)
  }

  // MARK: - Code

  public func newCode(code: CodeObject) -> PyCode {
    return PyCode(code: code)
  }

  // MARK: - Frame

  /// PyFrameObject* _Py_HOT_FUNCTION
  /// _PyFrame_New_NoTrack(PyThreadState *tstate, PyCodeObject *code,
  public func newFrame(code: PyCode,
                       locals: PyDict,
                       globals: PyDict,
                       parent: PyFrame?) -> PyFrame {
    return PyFrame(code: code, locals: locals, globals: globals, parent: parent)
  }

  // MARK: - Cell

  public func newCell(content: PyObject?) -> PyCell {
    return PyCell(content: content)
  }
}

// MARK: - Compile

private let compileArguments = ArgumentParser.createOrTrap(
  arguments: ["source", "filename", "mode", "flags", "dont_inherit", "optimize"],
  format: "OOO|OOO:compile"
)

private enum ParseStringResult {
  case value(String)
  case byteDecodingError
  case notStringOrBytes
}

extension BuiltinFunctions {

  // sourcery: pymethod = compile
  /// compile(source, filename, mode, flags=0, dont_inherit=False, optimize=-1)
  /// See [this](https://docs.python.org/3/library/functions.html#compile)
  ///
  /// static PyObject *
  /// builtin_compile_impl(PyObject *module, PyObject *source, PyObject *filename,
  internal func compile(args: [PyObject],
                        kwargs: PyDict?) -> PyResult<PyCode> {
    switch compileArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 3, "Invalid required argument count.")
      assert(binding.optionalCount == 3, "Invalid optional argument count.")

      let source = binding.required(at: 0)
      let filename = binding.required(at: 1)
      let mode = binding.required(at: 2)
      let flags = binding.optional(at: 3)
      let dontInherit = binding.optional(at: 4)
      let optimize = binding.optional(at: 5)
      return self.compile(source: source,
                          filename: filename,
                          mode: mode,
                          flags: flags,
                          dontInherit: dontInherit,
                          optimize: optimize)

    case let .error(e):
      return .error(e)
    }
  }

  public func compile(source sourceArg: PyObject,
                      filename filenameArg: PyObject,
                      mode modeArg: PyObject,
                      flags: PyObject? = nil,
                      dontInherit: PyObject? = nil,
                      optimize optimizeArg: PyObject? = nil) -> PyResult<PyCode> {
    let source: String
    switch self.parseCompileStringArg(argumentIndex: 1, arg: sourceArg) {
    case let .value(s): source = s
    case let .error(e): return .error(e)
    }

    let filename: String
    switch self.parseCompileStringArg(argumentIndex: 2, arg: filenameArg) {
    case let .value(s): filename = s
    case let .error(e): return .error(e)
    }

    let mode: ParserMode
    switch self.parseCompileMode(arg: modeArg) {
    case let .value(m): mode = m
    case let .error(e): return .error(e)
    }

    // We will ignore 'flags' and 'dont_inherit'.

    let optimize: OptimizationLevel
    switch self.parseCompileOptimize(arg: optimizeArg) {
    case let .value(o): optimize = o
    case let .error(e): return .error(e)
    }

    return self.compile(source: source,
                        filename: filename,
                        mode: mode,
                        optimize: optimize)
  }

  /// Compile object at a given `url`.
  public func compile(url: URL,
                      mode: ParserMode,
                      optimize: OptimizationLevel? = nil) -> PyResult<PyCode> {
    let data: Data
    switch Py.fileSystem.read(path: url.path) {
    case let .value(d):
      data = d
    case let .error(e):
      return .error(e)
    }

    let encoding = PyStringEncoding.default
    guard let source = String(data: data, encoding: encoding.swift) else {
      let e = Py.newUnicodeDecodeError(data: data, encoding: encoding)
      return .error(e)
    }

    return Py.compile(
      source: source,
      filename: url.lastPathComponent,
      mode: mode,
      optimize: optimize
    )
  }

  public func compile(source: String,
                      filename: String,
                      mode: ParserMode,
                      optimize: OptimizationLevel? = nil) -> PyResult<PyCode> {
    do {
      let lexer = Lexer(for: source)
      let parser = Parser(mode: mode, tokenSource: lexer)
      let ast = try parser.parse()

      let compilerOptions = CompilerOptions(
        optimizationLevel: optimize ?? Py.sys.flags.optimize
      )

      let compiler = try Compiler(ast: ast,
                                  filename: filename,
                                  options: compilerOptions)

      let code = try compiler.run()
      let codeObject = self.newCode(code: code)
      return .value(codeObject)
    } catch {
      if let e = error as? LexerError {
        return .error(Py.newSyntaxError(filename: filename, error: e))
      }

      if let e = error as? ParserError {
        return .error(Py.newSyntaxError(filename: filename, error: e))
      }

      if let e = error as? CompilerError {
        return .error(Py.newSyntaxError(filename: filename, error: e))
      }

      let msg = String(describing: error)
      let e = Py.newRuntimeError(msg: "Error when compiling '\(filename)': '\(msg)'")
      return .error(e)
    }
  }

  private func parseCompileStringArg(argumentIndex index: Int,
                                     arg: PyObject) -> PyResult<String> {
    switch self.parseString(object: arg) {
    case .value(let s):
      return .value(s)
    case .byteDecodingError:
      return .typeError("compile(): cannot decode arg \(index) as string")
    case .notStringOrBytes:
      return .typeError("compile(): arg \(index) must be a string or bytes object")
    }
  }

  private func parseString(object: PyObject) -> ParseStringResult {
    if let str = object as? PyString {
      return .value(str.value)
    }

    if let bytes = object as? PyBytesType {
      if let str = bytes.data.string {
        return .value(str)
      }

      return .byteDecodingError
    }

    return .notStringOrBytes
  }

  private func parseCompileMode(arg: PyObject) -> PyResult<ParserMode> {
    guard let string = arg as? PyString else {
      return .typeError("compile(): mode must be an str")
    }

    if string.compare(with: "exec") == .equal {
      return .value(.exec)
    }

    if string.compare(with: "eval") == .equal {
      return .value(.eval)
    }

    if string.compare(with: "single") == .equal {
      return .value(.single)
    }

    return .typeError("compile() mode must be 'exec', 'eval' or 'single'")
  }

  private func parseCompileOptimize(arg: PyObject?) -> PyResult<OptimizationLevel> {
    guard let arg = arg else {
      return .value(.none)
    }

    guard let int = arg as? PyInt else {
      return .typeError("compile(): optimize must be an int")
    }

    switch int.value {
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

// MARK: - Exec

private let execArguments = ArgumentParser.createOrTrap(
  arguments: ["source", "globals", "locals"],
  format: "O|OO:exec"
)

private enum DictOrNone {
  case dict(PyDict)
  case none
  case somethingElse(typeName: String)
}

private enum ExecEvalEnv {
  case env(globals: PyDict, locals: PyDict)
  case globalsNotDict(globalsType: String)
  case localsNotDict(localsType: String)
  case error(PyBaseException)
}

private enum ExecEvalSource {
  case code(PyCode)
  case codeWithFreeVariables
  case byteDecodingError
  case notStringOrBytes
  case error(PyBaseException)
}

extension BuiltinFunctions {

  // sourcery: pymethod = exec
  /// exec(object[, globals[, locals]])
  /// See [this](https://docs.python.org/3/library/functions.html#exec)
  ///
  /// static PyObject *
  /// builtin_exec_impl(PyObject *module, PyObject *source, PyObject *globals,
  internal func exec(args: [PyObject],
                     kwargs: PyDict?) -> PyResult<PyNone> {
    switch execArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 1, "Invalid required argument count.")
      assert(binding.optionalCount == 2, "Invalid optional argument count.")

      let source = binding.required(at: 0)
      let globals = binding.optional(at: 1)
      let locals = binding.optional(at: 2)
      return self.exec(source: source, globals: globals, locals: locals)

    case let .error(e):
      return .error(e)
    }
  }

  public func exec(source: PyObject,
                   globals: PyObject?,
                   locals: PyObject?) -> PyResult<PyNone> {
    let env: Env
    switch self.parseExecEvalEnv(globals: globals, locals: locals) {
    case let .env(globals: g, locals: l):
      env = (globals: g, locals: l)
    case let .globalsNotDict(globalsType: t):
      return .typeError("exec() globals must be a dict, not \(t)")
    case let .localsNotDict(localsType: t):
      return .typeError("exec() locals must be a dict, not \(t)")
    case let .error(e):
      return .error(e)
    }

    if env.globals.get(id: .builtins) == nil {
      env.globals.set(id: .builtins, to: Py.builtinsModule)
    }

    let code: PyCode
    switch self.parseExecEvalSource(arg: source, filename: "exec", mode: .fileInput) {
    case .code(let c):
      code = c
    case .codeWithFreeVariables:
      return .typeError("code object passed to exec() may not contain free variables")
    case .byteDecodingError:
      return .typeError("exec(): cannot decode arg 1 as string")
    case .notStringOrBytes:
      return .typeError("exec(): arg 1 must be a string, bytes or code object")
    case .error(let e):
      return .error(e)
    }

    let result = self.run(code: code, env: env)
    return result.map { _ in Py.none }
  }

  private typealias Env = (globals: PyDict, locals: PyDict)

  private func parseExecEvalEnv(globals: PyObject?,
                                locals: PyObject?) -> ExecEvalEnv {
    switch self.parseDictOrNone(object: globals) {
    case .dict(let g):
      switch self.parseDictOrNone(object: locals) {
      case .dict(let l):
        return .env(globals: g, locals: l)
      case .none:
        return .env(globals: g, locals: g)
      case .somethingElse(let typeName):
        return .localsNotDict(localsType: typeName)
      }

    case .none:
      switch Py.getGlobals() {
      case let .value(g):
        switch self.parseDictOrNone(object: locals) {
        case .dict(let l):
          return .env(globals: g, locals: l)
        case .none:
          switch Py.getLocals() {
          case let .value(l):
            return .env(globals: g, locals: l)
          case let .error(e):
            return .error(e)
          }
        case .somethingElse(let typeName):
          return .localsNotDict(localsType: typeName)
        }

      case let .error(e):
        return .error(e)
      }

    case .somethingElse(let typeName):
      return .globalsNotDict(globalsType: typeName)
    }
  }

  private func parseDictOrNone(object: PyObject?) -> DictOrNone {
    guard let obj = object else {
      return .none
    }

    if let dict = obj as? PyDict {
      return .dict(dict)
    }

    if obj.isNone {
      return .none
    }

    return .somethingElse(typeName: obj.typeName)
  }

  private func parseExecEvalSource(arg: PyObject,
                                   filename: String,
                                   mode: ParserMode) -> ExecEvalSource {
    if let code = arg as? PyCode {
      if code.freeVariableCount > 0 {
        return .codeWithFreeVariables
      }

      return .code(code)
    }

    switch self.parseString(object: arg) {
    case .value(let source):
      let code = self.compile(source: source,
                              filename: filename,
                              mode: mode,
                              optimize: .none)

      switch code {
      case let .value(c):
        return .code(c)
      case let .error(e):
        return .error(e)
      }

    case .byteDecodingError:
      return .byteDecodingError
    case .notStringOrBytes:
      return .notStringOrBytes
    }
  }

  private func run(code: PyCode, env: Env) -> PyResult<PyObject> {
    return Py.delegate.eval(
      name: nil,
      qualname: nil,
      code: code,

      args: [],
      kwargs: nil,
      defaults: [],
      kwDefaults: nil,

      globals: env.globals,
      locals: env.locals,
      closure: nil
    )
  }
}

// MARK: - Eval

private let evalArguments = ArgumentParser.createOrTrap(
  arguments: ["source", "globals", "locals"],
  format: "O|OO:exec"
)

extension BuiltinFunctions {

  // sourcery: pymethod = eval
  /// eval(expression[, globals[, locals]])
  /// See [this](https://docs.python.org/3/library/functions.html#eval)
  public func eval(args: [PyObject],
                   kwargs: PyDict?) -> PyResult<PyObject> {
    switch execArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 1, "Invalid required argument count.")
      assert(binding.optionalCount == 2, "Invalid optional argument count.")

      let source = binding.required(at: 0)
      let globals = binding.optional(at: 1)
      let locals = binding.optional(at: 2)
      return self.eval(source: source, globals: globals, locals: locals)

    case let .error(e):
      return .error(e)
    }
  }

  public func eval(source: PyObject,
                   globals: PyObject?,
                   locals: PyObject?) -> PyResult<PyObject> {
    let env: Env
    switch self.parseExecEvalEnv(globals: globals, locals: locals) {
    case let .env(globals: g, locals: l):
      env = (globals: g, locals: l)
    case .globalsNotDict:
      return .typeError("globals must be a dict")
    case .localsNotDict:
      return .typeError("locals must be a mapping")
    case .error(let e):
      return .error(e)
    }

    if env.globals.get(id: .builtins) == nil {
      env.globals.set(id: .builtins, to: Py.builtinsModule)
    }

    let code: PyCode
    switch self.parseExecEvalSource(arg: source, filename: "eval", mode: .eval) {
    case .code(let c):
      code = c
    case .codeWithFreeVariables:
      return .typeError("code object passed to eval() may not contain free variables")
    case .byteDecodingError:
      return .typeError("eval(): cannot decode arg 1 as string")
    case .notStringOrBytes:
      return .typeError("eval(): arg 1 must be a string, bytes or code object")
    case .error(let e):
      return .error(e)
    }

    let result = self.run(code: code, env: env)
    return result
  }
}
