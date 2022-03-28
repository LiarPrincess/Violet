import Foundation
import VioletCore
import VioletBytecode

// MARK: - Abstract

private protocol ExecEval {

  static var filename: String { get }
  static var parserMode: Py.ParserMode { get }

  static func createLocalsNotDictError(type: String) -> String
  static func createGlobalsNotDictError(type: String) -> String

  static var sourceWithFreeVariablesError: String { get }
  static var sourceDecodingError: String { get }
  static var sourceArgumentHasInvalidTypeError: String { get }
}

extension ExecEval {

  fileprivate static func run(_ py: Py,
                              source: PyObject,
                              globals _globals: PyObject?,
                              locals _locals: PyObject?) -> PyResult {
    let locals: PyDict
    let globals: PyDict
    switch Self.parseEnv(py, globals: _globals, locals: _locals) {
    case let .value(env):
      globals = env.globals
      locals = env.locals
    case let .error(e):
      return .error(e)
    }

    if globals.get(py, id: .__builtins__) == nil {
      let frame = py.delegate.getCurrentlyExecutedFrame(py)
      let builtins = frame?.builtins ?? py.builtins.__dict__
      globals.set(py, id: .__builtins__, value: builtins.asObject)
    }

    let code: PyCode
    switch Self.parseSource(py, arg: source) {
    case let .value(c):
      code = c
    case let .error(e):
      return .error(e)
    }

    return py.delegate.eval(py,
                            name: nil,
                            qualname: nil,
                            code: code,

                            args: [],
                            kwargs: nil,
                            defaults: [],
                            kwDefaults: nil,

                            globals: globals,
                            locals: locals,
                            closure: nil)
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

  private static func parseEnv(_ py: Py,
                               globals: PyObject?,
                               locals: PyObject?) -> PyResultGen<Env> {
    // Omg! This code looks soooooo bad.
    // So, we basically try to do 'Self.parseDictOrNone' 2 times
    // (on both 'globals' and 'locals'), so that gives us 7 cases to handle.
    switch Self.parseDictOrNone(py, object: globals) {
    case .dict(let g):
      switch Self.parseDictOrNone(py, object: locals) {
      case .dict(let l):
        return .value(Env(globals: g, locals: l))
      case .none:
        return .value(Env(globals: g, locals: g))
      case .somethingElse(let type):
        return .typeError(py, message: Self.createLocalsNotDictError(type: type))
      }

    case .none:
      switch py.globals() {
      case let .value(g):
        switch Self.parseDictOrNone(py, object: locals) {
        case .dict(let l):
          return .value(Env(globals: g, locals: l))
        case .none:
          switch py.locals() {
          case let .value(l):
            return .value(Env(globals: g, locals: l))
          case let .error(e):
            return .error(e)
          }
        case .somethingElse(let type):
          return .typeError(py, message: Self.createLocalsNotDictError(type: type))
        }

      case let .error(e):
        return .error(e)
      }

    case .somethingElse(let type):
      return .typeError(py, message: Self.createGlobalsNotDictError(type: type))
    }
  }

  private static func parseDictOrNone(_ py: Py, object: PyObject?) -> DictOrNone {
    guard let obj = object else {
      return .none
    }

    if let dict = py.cast.asDict(obj) {
      return .dict(dict)
    }

    if py.cast.isNone(obj) {
      return .none
    }

    return .somethingElse(typeName: obj.typeName)
  }

  // MARK: - Source

  private static func parseSource(_ py: Py, arg: PyObject) -> PyResultGen<PyCode> {
    if let code = py.cast.asCode(arg) {
      if code.freeVariableCount > 0 {
        return .typeError(py, message: Self.sourceWithFreeVariablesError)
      }

      return .value(code)
    }

    switch py.getString(object: arg, encoding: .default) {
    case .string(_, let source),
         .bytes(_, let source):
      return py.compile(source: source,
                        filename: Self.filename,
                        mode: Self.parserMode,
                        optimize: .none)

    case .byteDecodingError:
      return .typeError(py, message: Self.sourceArgumentHasInvalidTypeError)
    case .notStringOrBytes:
      return .typeError(py, message: Self.sourceArgumentHasInvalidTypeError)
    }
  }
}

extension Py {

  // MARK: - Exec

  private struct Exec: ExecEval {

    fileprivate static let filename = "exec"
    fileprivate static let parserMode = Py.ParserMode.fileInput

    fileprivate static func createLocalsNotDictError(type: String) -> String {
      return "exec() locals must be a dict, not \(type)"
    }

    fileprivate static func createGlobalsNotDictError(type: String) -> String {
      return "exec() globals must be a dict, not \(type)"
    }

    fileprivate static let sourceWithFreeVariablesError =
      "code object passed to exec() may not contain free variables"

    fileprivate static let sourceDecodingError =
      "exec(): cannot decode arg 1 as string"

    fileprivate static let sourceArgumentHasInvalidTypeError =
      "exec(): arg 1 must be a string, bytes or code object"
  }

  /// exec(object[, globals[, locals]])
  /// See [this](https://docs.python.org/3/library/functions.html#exec)
  ///
  /// static PyObject *
  /// builtin_exec_impl(PyObject *module, PyObject *source, PyObject *globals,
  public func exec(source: PyObject,
                   globals: PyObject?,
                   locals: PyObject?) -> PyBaseException? {
    switch Exec.run(self, source: source, globals: globals, locals: locals) {
    case .value:
      return nil
    case .error(let e):
      return e
    }
  }

  // MARK: - Eval

  private struct Eval: ExecEval {

    fileprivate static let filename = "eval"
    fileprivate static let parserMode = Py.ParserMode.eval

    fileprivate static func createLocalsNotDictError(type: String) -> String {
      return "locals must be a mapping"
    }

    fileprivate static func createGlobalsNotDictError(type: String) -> String {
      return "globals must be a dict"
    }

    fileprivate static let sourceWithFreeVariablesError =
      "code object passed to eval() may not contain free variables"

    fileprivate static let sourceDecodingError =
      "eval(): cannot decode arg 1 as string"

    fileprivate static let sourceArgumentHasInvalidTypeError =
      "eval(): arg 1 must be a string, bytes or code object"
  }

  /// eval(expression[, globals[, locals]])
  /// See [this](https://docs.python.org/3/library/functions.html#eval)
  public func eval(source: PyObject, globals: PyObject?, locals: PyObject?) -> PyResult {
    return Eval.run(self, source: source, globals: globals, locals: locals)
  }
}
