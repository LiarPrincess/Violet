import Core
import Lexer
import Parser
import Compiler
import Bytecode
import Foundation

// MARK: - Exec

extension PyInstance {

  /// exec(object[, globals[, locals]])
  /// See [this](https://docs.python.org/3/library/functions.html#exec)
  ///
  /// static PyObject *
  /// builtin_exec_impl(PyObject *module, PyObject *source, PyObject *globals,
  public func exec(source: PyObject,
                   globals: PyObject?,
                   locals: PyObject?) -> PyResult<PyNone> {
    let env: Env
    switch self.parseEnv(globals: globals, locals: locals) {
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
    switch self.parseSource(arg: source, filename: "exec", mode: .fileInput) {
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
}

// MARK: - Eval

extension PyInstance {

  /// eval(expression[, globals[, locals]])
  /// See [this](https://docs.python.org/3/library/functions.html#eval)
  public func eval(source: PyObject,
                   globals: PyObject?,
                   locals: PyObject?) -> PyResult<PyObject> {
    let env: Env
    switch self.parseEnv(globals: globals, locals: locals) {
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
    switch self.parseSource(arg: source, filename: "eval", mode: .eval) {
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

// MARK: - Env

private typealias Env = (globals: PyDict, locals: PyDict)

private enum ParseEnvResult {
  case env(globals: PyDict, locals: PyDict)
  case globalsNotDict(globalsType: String)
  case localsNotDict(localsType: String)
  case error(PyBaseException)
}

private enum DictOrNone {
  case dict(PyDict)
  case none
  case somethingElse(typeName: String)
}

extension PyInstance {

  private func parseEnv(globals: PyObject?, locals: PyObject?) -> ParseEnvResult {
    // Omg! This code looks soooooo... bad.
    // So, we basically try to do 'self.parseDictOrNone' 2 times
    // (on both 'globals' and 'locals'), so that gives us 7 cases to handle.
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
      switch Py.globals() {
      case let .value(g):
        switch self.parseDictOrNone(object: locals) {
        case .dict(let l):
          return .env(globals: g, locals: l)
        case .none:
          switch Py.locals() {
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
}

// MARK: - Source

private enum Source {
  case code(PyCode)
  case codeWithFreeVariables
  case byteDecodingError
  case notStringOrBytes
  case error(PyBaseException)
}

extension PyInstance {

  private func parseSource(arg: PyObject,
                           filename: String,
                           mode: ParserMode) -> Source {
    if let code = arg as? PyCode {
      if code.freeVariableCount > 0 {
        return .codeWithFreeVariables
      }

      return .code(code)
    }

    switch self.extractString(object: arg) {
    case .string(_, let source),
         .bytes(_, let source):
      let code = self.compile(source: source,
                              filename: filename,
                              mode: mode,
                              optimize: OptimizationLevel.none)

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

  // MARK: - Run

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
