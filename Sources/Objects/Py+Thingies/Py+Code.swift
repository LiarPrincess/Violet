import Foundation
import VioletCore
import VioletLexer
import VioletParser
import VioletBytecode
import VioletCompiler

// cSpell:ignore tstate

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension PyInstance {

  // MARK: - Builtin method

  public func newMethod(fn: PyBuiltinFunction,
                        object: PyObject) -> PyBuiltinMethod {
    return PyBuiltinMethod(fn: fn.function, object: object)
  }

  // MARK: - Function

  public func newFunction(qualname: PyObject,
                          code: PyObject,
                          globals: PyDict) -> PyResult<PyFunction> {
    guard let codeValue = PyCast.asCode(code) else {
      let t = code.typeName
      return .typeError("function() code must be code, not \(t)")
    }

    let qualnameValue: PyString?
    if qualname.isNone {
      qualnameValue = nil
    } else if let q = PyCast.asString(qualname) {
      qualnameValue = q
    } else {
      let t = qualname.typeName
      return .typeError("function() qualname must be None or string, not \(t)")
    }

    let result = self.newFunction(qualname: qualnameValue,
                                  code: codeValue,
                                  globals: globals)

    return .value(result)
  }

  public func newFunction(qualname: PyString?,
                          code: PyCode,
                          globals: PyDict) -> PyFunction {
    let module = globals.get(id: .__name__) ?? self.none

    return PyFunction(
      qualname: qualname,
      module: module,
      code: code,
      globals: globals
    )
  }

  // MARK: - Method

  public func newMethod(fn: PyFunction,
                        object: PyObject) -> PyMethod {
    return PyMethod(fn: fn, object: object)
  }

  public func newMethod(fn: PyObject,
                        object: PyObject) -> PyResult<PyObject> {
    if let f = PyCast.asBuiltinFunction(fn) {
      let result = self.newMethod(fn: f, object: object)
      return .value(result)
    }

    if let f = PyCast.asFunction(fn) {
      let result = self.newMethod(fn: f, object: object)
      return .value(result)
    }

    return .typeError("method() func must be function, not \(fn.typeName)")
  }

  // MARK: - Function name

  public func getFunctionName(object: PyObject) -> String? {
    if let fn = PyCast.asBuiltinFunction(object) {
      return fn.getName()
    }

    if let fn = PyCast.asBuiltinMethod(object) {
      return fn.getName()
    }

    if let fn = PyCast.asFunction(object) {
      let result = fn.getName()
      return result.value
    }

    if let method = PyCast.asMethod(object) {
      let fn = method.getFunction()
      let result = fn.getName()
      return result.value
    }

    if let method = PyCast.asStaticMethod(object), let fn = method.getFunction() {
      return self.getFunctionName(object: fn)
    }

    if let method = PyCast.asClassMethod(object), let fn = method.getFunction() {
      return self.getFunctionName(object: fn)
    }

    return nil
  }

  // MARK: - Module

  public func newModule(name: String,
                        doc: String? = nil,
                        dict: PyDict? = nil) -> PyModule {
    let nameObject = self.intern(string: name)
    let docObject = doc.map(self.newString)
    return self.newModule(name: nameObject, doc: docObject, dict: dict)
  }

  public func newModule(name: PyObject,
                        doc: PyObject? = nil,
                        dict: PyDict? = nil) -> PyModule {
    return PyModule(name: name, doc: doc, dict: dict)
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
