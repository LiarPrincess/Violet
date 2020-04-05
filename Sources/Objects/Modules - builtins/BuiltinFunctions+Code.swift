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
