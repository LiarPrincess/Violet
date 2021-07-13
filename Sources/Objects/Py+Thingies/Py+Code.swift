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
    return PyMemory.newBuiltinMethod(fn: fn.function, object: object)
  }

  // MARK: - Function

  // swiftlint:disable:next function_parameter_count
  public func newFunction(qualname: PyObject,
                          code: PyObject,
                          globals: PyDict,
                          defaults: PyObject?,
                          keywordDefaults: PyObject?,
                          closure: PyObject?,
                          annotations: PyObject?) -> PyResult<PyFunction> {
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

    return self.newFunction(qualname: qualnameValue,
                            code: codeValue,
                            globals: globals,
                            defaults: defaults,
                            keywordDefaults: keywordDefaults,
                            closure: closure,
                            annotations: annotations)
  }

  // swiftlint:disable:next function_parameter_count
  public func newFunction(qualname: PyString?,
                          code: PyCode,
                          globals: PyDict,
                          defaults: PyObject?,
                          keywordDefaults: PyObject?,
                          closure: PyObject?,
                          annotations: PyObject?) -> PyResult<PyFunction> {
    let module = globals.get(id: .__name__) ?? self.none

    let result = PyMemory.newFunction(qualname: qualname,
                                      module: module,
                                      code: code,
                                      globals: globals)

    if let defaults = defaults {
      switch result.setDefaults(defaults) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    if let keywordDefaults = keywordDefaults {
      switch result.setKeywordDefaults(keywordDefaults) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    if let closure = closure {
      switch result.setClosure(closure) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    if let annotations = annotations {
      switch result.setAnnotations(annotations) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    return .value(result)
  }

  // MARK: - Method

  public func newMethod(fn: PyFunction,
                        object: PyObject) -> PyMethod {
    return PyMemory.newMethod(fn: fn, object: object)
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
    return PyMemory.newModule(name: name, doc: doc, dict: dict)
  }

  public enum ModuleName {
    case notModule
    case string(String)
    case stringConversionFailed(PyObject, PyBaseException)
    case namelessModule
  }

  public func getModuleName(object: PyObject) -> ModuleName {
    guard let module = PyCast.asModule(object) else {
      return .notModule
    }

    switch module.getNameString() {
    case let .string(string):
      return .string(string)
    case let .stringConversionFailed(object, e):
      return .stringConversionFailed(object, e)
    case .namelessModule:
      return .namelessModule
    }
  }

  // MARK: - Code

  public func newCode(code: CodeObject) -> PyCode {
    return PyMemory.newCode(code: code)
  }

  // MARK: - Frame

  /// PyFrameObject* _Py_HOT_FUNCTION
  /// _PyFrame_New_NoTrack(PyThreadState *tstate, PyCodeObject *code,
  public func newFrame(code: PyCode,
                       locals: PyDict,
                       globals: PyDict,
                       parent: PyFrame?) -> PyFrame {
    return PyMemory.newFrame(code: code,
                             locals: locals,
                             globals: globals,
                             parent: parent)
  }

  // MARK: - Cell

  public func newCell(content: PyObject?) -> PyCell {
    return PyMemory.newCell(content: content)
  }
}
