import Core
import Lexer
import Parser
import Compiler
import Bytecode
import Foundation

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

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
    switch self.parseCompileStringArg(index: 1, arg: sourceArg) {
    case let .value(s): source = s
    case let .error(e): return .error(e)
    }

    let filename: String
    switch self.parseCompileStringArg(index: 2, arg: filenameArg) {
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

  private func compile(source: String,
                       filename: String,
                       mode: ParserMode,
                       optimize: OptimizationLevel) -> PyResult<PyCode> {
    do {
      let lexer = Lexer(for: source)
      let parser = Parser(mode: mode, tokenSource: lexer)
      let ast = try parser.parse()

      let compilerOptions = CompilerOptions(optimizationLevel: optimize)
      let compiler = try Compiler(ast: ast,
                                  filename: filename,
                                  options: compilerOptions)

      let codeObject = try compiler.run()
      let code = self.newCode(code: codeObject)
      return .value(code)
    } catch {
      if let e = error as? LexerError {
        let e = Py.newSyntaxError(filename: filename,
                                  location: e.location,
                                  text: String(describing: e.kind))
        return .error(e)
      }

      if let e = error as? ParserError {
        let e = Py.newSyntaxError(filename: filename,
                                  location: e.location,
                                  text: String(describing: e.kind))
        return .error(e)
      }

      if let e = error as? CompilerError {
        let e = Py.newSyntaxError(filename: filename,
                                  location: e.location,
                                  text: String(describing: e.kind))
        return .error(e)
      }

      let msg = String(describing: error)
      let e = Py.newRuntimeError(msg: "Error when compiling '\(filename)': '\(msg)'")
      return .error(e)
    }
  }

  private func parseCompileStringArg(index: Int,
                                     arg: PyObject) -> PyResult<String> {
    if let str = arg as? PyString {
      return .value(str.value)
    }

    if let bytes = arg as? PyBytesType {
      if let str = bytes.data.string {
        return .value(str)
      }

      return .typeError("compile(): cannot decode arg \(index) as string")
    }

    return .typeError("compile(): arg \(index) must be a string or bytes object")
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
