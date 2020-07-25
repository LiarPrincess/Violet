import Foundation
import VioletCore
import VioletLexer
import VioletParser
import VioletBytecode
import VioletCompiler

// MARK: - Abstract

private protocol ExecEval {

  static var filename: String { get }
  static var parserMode: Parser.Mode { get }

  static func createLocalsNotDictError(type: String) -> String
  static func createGlobalsNotDictError(type: String) -> String

  static func createSourceWithFreeVariablesError() -> String
  static func createSourceDecodingError() -> String
  static func createSourceArgumentHasInvalidTypeError() -> String
}

extension ExecEval {

  fileprivate static func run(source: PyObject,
                              globals _globals: PyObject?,
                              locals _locals: PyObject?) -> PyResult<PyObject> {
    let locals: PyDict
    let globals: PyDict
    switch Self.parseEnv(globals: _globals, locals: _locals) {
    case let .value(env):
      globals = env.globals
      locals = env.locals
    case let .error(e):
      return .error(e)
    }

    if globals.get(id: .__builtins__) == nil {
      let builtins = Py.delegate.frame?.builtins ?? Py.builtins.__dict__
      globals.set(id: .__builtins__, to: builtins)
    }

    let code: PyCode
    switch Self.parseSource(arg: source) {
    case let .value(c):
      code = c
    case let .error(e):
      return .error(e)
    }

    return Py.delegate.eval(
      name: nil,
      qualname: nil,
      code: code,

      args: [],
      kwargs: nil,
      defaults: [],
      kwDefaults: nil,

      globals: globals,
      locals: locals,
      closure: nil
    )
  }
}

// MARK: - Env

private struct Env {
  let globals: PyDict
  let locals: PyDict
}

private enum DictOrNone {
  case dict(PyDict)
  case none
  case somethingElse(typeName: String)
}

extension ExecEval {

  private static func parseEnv(globals: PyObject?,
                               locals: PyObject?) -> PyResult<Env> {
    // Omg! This code looks soooooo… bad.
    // So, we basically try to do 'Self.parseDictOrNone' 2 times
    // (on both 'globals' and 'locals'), so that gives us 7 cases to handle.
    switch Self.parseDictOrNone(object: globals) {
    case .dict(let g):
      switch Self.parseDictOrNone(object: locals) {
      case .dict(let l):
        return .value(Env(globals: g, locals: l))
      case .none:
        return .value(Env(globals: g, locals: g))
      case .somethingElse(let type):
        return .typeError(Self.createLocalsNotDictError(type: type))
      }

    case .none:
      switch Py.globals() {
      case let .value(g):
        switch Self.parseDictOrNone(object: locals) {
        case .dict(let l):
          return .value(Env(globals: g, locals: l))
        case .none:
          switch Py.locals() {
          case let .value(l):
            return .value(Env(globals: g, locals: l))
          case let .error(e):
            return .error(e)
          }
        case .somethingElse(let type):
          return .typeError(Self.createLocalsNotDictError(type: type))
        }

      case let .error(e):
        return .error(e)
      }

    case .somethingElse(let type):
      return .typeError(Self.createGlobalsNotDictError(type: type))
    }
  }

  private static func parseDictOrNone(object: PyObject?) -> DictOrNone {
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

  // MARK: - Source

  private static func parseSource(arg: PyObject) -> PyResult<PyCode> {
    if let code = arg as? PyCode {
      if code.freeVariableCount > 0 {
        return .typeError(Self.createSourceWithFreeVariablesError())
      }

      return .value(code)
    }

    switch Py.extractString(object: arg) {
    case .string(_, let source),
         .bytes(_, let source):
      let compileResult = Py.compile(source: source,
                                     filename: Self.filename,
                                     mode: Self.parserMode,
                                     optimize: OptimizationLevel.none)

      return compileResult.asResult()

    case .byteDecodingError:
      return .typeError(Self.createSourceArgumentHasInvalidTypeError())
    case .notStringOrBytes:
      return .typeError(Self.createSourceArgumentHasInvalidTypeError())
    }
  }
}

// MARK: - PyInstance

extension PyInstance {

  // MARK: - Exec

  private struct Exec: ExecEval {

    fileprivate static let filename = "exec"
    fileprivate static let parserMode = Parser.Mode.fileInput

    fileprivate static func createLocalsNotDictError(type: String) -> String {
      return "exec() locals must be a dict, not \(type)"
    }

    fileprivate static func createGlobalsNotDictError(type: String) -> String {
      return "exec() globals must be a dict, not \(type)"
    }

    fileprivate static func createSourceWithFreeVariablesError() -> String {
      return "code object passed to exec() may not contain free variables"
    }

    fileprivate static func createSourceDecodingError() -> String {
      return "exec(): cannot decode arg 1 as string"
    }

    fileprivate static func createSourceArgumentHasInvalidTypeError() -> String {
      return "exec(): arg 1 must be a string, bytes or code object"
    }
  }

  /// exec(object[, globals[, locals]])
  /// See [this](https://docs.python.org/3/library/functions.html#exec)
  ///
  /// static PyObject *
  /// builtin_exec_impl(PyObject *module, PyObject *source, PyObject *globals,
  public func exec(source: PyObject,
                   globals: PyObject?,
                   locals: PyObject?) -> PyResult<PyNone> {
    let result = Exec.run(source: source, globals: globals, locals: locals)
    return result.map { _ in self.none }
  }

  // MARK: - Eval

  private struct Eval: ExecEval {

    fileprivate static let filename = "eval"
    fileprivate static let parserMode = Parser.Mode.eval

    fileprivate static func createLocalsNotDictError(type: String) -> String {
      return "locals must be a mapping"
    }

    fileprivate static func createGlobalsNotDictError(type: String) -> String {
      return "globals must be a dict"
    }

    fileprivate static func createSourceWithFreeVariablesError() -> String {
      return "code object passed to eval() may not contain free variables"
    }

    fileprivate static func createSourceDecodingError() -> String {
      return "eval(): cannot decode arg 1 as string"
    }

    fileprivate static func createSourceArgumentHasInvalidTypeError() -> String {
      return "eval(): arg 1 must be a string, bytes or code object"
    }
  }

  /// eval(expression[, globals[, locals]])
  /// See [this](https://docs.python.org/3/library/functions.html#eval)
  public func eval(source: PyObject,
                   globals: PyObject?,
                   locals: PyObject?) -> PyResult<PyObject> {
    return Eval.run(source: source, globals: globals, locals: locals)
  }
}
