import Foundation
import VioletCore
import VioletBytecode

// cSpell:ignore tstate

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Py {

  // MARK: - Builtin function

  public func newBuiltinFunction(fn: FunctionWrapper,
                                 module: PyObject?,
                                 doc: String?) -> PyBuiltinFunction {
    let type = self.types.builtinFunction
    return self.memory.newBuiltinFunction(type: type,
                                          function: fn,
                                          module: module,
                                          doc: doc)
  }

  // MARK: - Builtin method

  public func newBuiltinMethod(fn: FunctionWrapper,
                               object: PyObject,
                               module: PyObject?,
                               doc: String?) -> PyBuiltinMethod {
    let type = self.types.builtinMethod
    return self.memory.newBuiltinMethod(type: type,
                                        function: fn,
                                        object: object,
                                        module: module,
                                        doc: doc)
  }

  // MARK: - Function

  // swiftlint:disable:next function_parameter_count
  public func newFunction(qualname: PyObject,
                          code: PyObject,
                          globals: PyDict,
                          defaults: PyObject?,
                          keywordDefaults: PyObject?,
                          closure: PyObject?,
                          annotations: PyObject?) -> PyResultGen<PyFunction> {
    guard let codeValue = self.cast.asCode(code) else {
      let message = "function() code must be code, not \(code.typeName)"
      return .typeError(self, message: message)
    }

    let qualnameValue: PyString?
    if self.cast.isNone(qualname) {
      qualnameValue = nil
    } else if let q = self.cast.asString(qualname) {
      qualnameValue = q
    } else {
      let message = "function() qualname must be None or string, not \(qualname.typeName)"
      return .typeError(self, message: message)
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
                          annotations: PyObject?) -> PyResultGen<PyFunction> {
    let type = self.types.function
    let module = globals.get(self, id: .__name__) ?? self.none.asObject
    let result = self.memory.newFunction(type: type,
                                         qualname: qualname,
                                         module: module,
                                         code: code,
                                         globals: globals)

    if let defaults = defaults,
       let e = result.setDefaults(self, value: defaults) {
      return .error(e)
    }

    if let keywordDefaults = keywordDefaults,
       let e = result.setKeywordDefaults(self, value: keywordDefaults) {
      return .error(e)
    }

    if let closure = closure,
       let e = result.setClosure(self, value: closure) {
      return .error(e)
    }

    if let annotations = annotations,
       let e = result.setAnnotations(self, value: annotations) {
      return .error(e)
    }

    return .value(result)
  }

  // MARK: - Method

  public func newMethod(fn: PyFunction, object: PyObject) -> PyMethod {
    let type = self.types.method
    return self.memory.newMethod(type: type, function: fn, object: object)
  }

  public func newMethod(fn: PyObject, object: PyObject) -> PyResult {
    if let f = self.cast.asBuiltinFunction(fn) {
      let fn = f.function
      let module = f.module
      let doc = f.doc
      let result = self.newBuiltinMethod(fn: fn, object: object, module: module, doc: doc)
      return .value(result.asObject)
    }

    if let f = self.cast.asFunction(fn) {
      let result = self.newMethod(fn: f, object: object)
      return .value(result.asObject)
    }

    let message = "method() func must be function, not \(fn.typeName)"
    return .typeError(self, message: message)
  }

  // MARK: - Static method

  public func newStaticMethod(callable: PyBuiltinFunction) -> PyStaticMethod {
    let object = callable.asObject
    return self.newStaticMethod(callable: object)
  }

  public func newStaticMethod(callable: PyFunction) -> PyStaticMethod {
    let object = callable.asObject
    return self.newStaticMethod(callable: object)
  }

  private func newStaticMethod(callable: PyObject) -> PyStaticMethod {
    let type = self.types.staticmethod
    return self.memory.newStaticMethod(type: type, callable: callable)
  }

  // MARK: - Class method

  public func newClassMethod(callable: PyBuiltinFunction) -> PyClassMethod {
    let object = callable.asObject
    return self.newClassMethod(callable: object)
  }

  public func newClassMethod(callable: PyFunction) -> PyClassMethod {
    let object = callable.asObject
    return self.newClassMethod(callable: object)
  }

  private func newClassMethod(callable: PyObject) -> PyClassMethod {
    let type = self.types.classmethod
    return self.memory.newClassMethod(type: type, callable: callable)
  }

  // MARK: - Property

  public func newProperty(get: FunctionWrapper,
                          set: FunctionWrapper?,
                          del: FunctionWrapper?,
                          doc: String?) -> PyProperty {
    // We need to make sure that names are '__get__/__set__/__del__'.
    let _get = self.createPropertyFn(name: "__get__", fn: get)
    let _set = self.createPropertyFnOptional(name: "__set__", fn: set)
    let _del = self.createPropertyFnOptional(name: "__del__", fn: del)
    let _doc = doc.map(self.newString(_:))

    let type = self.types.property
    return self.memory.newProperty(type: type,
                                   get: _get,
                                   set: _set,
                                   del: _del,
                                   doc: _doc?.asObject)
  }

  private func createPropertyFnOptional(name: String,
                                        fn: FunctionWrapper?) -> PyObject? {
    guard let fn = fn else {
      return nil
    }

    return self.createPropertyFn(name: name, fn: fn)
  }

  private func createPropertyFn(name: String, fn: FunctionWrapper) -> PyObject {
    assert(fn.name == name)
    let result = self.newBuiltinFunction(fn: fn, module: nil, doc: nil)
    return result.asObject
  }

  // MARK: - Function name

  public func getName(function object: PyObject) -> PyString? {
    if let fn = self.cast.asBuiltinFunction(object) {
      return fn.getName(self)
    }

    if let fn = self.cast.asBuiltinMethod(object) {
      return fn.getName(self)
    }

    if let fn = self.cast.asFunction(object) {
      return fn.getName()
    }

    if let method = self.cast.asMethod(object) {
      let fn = method.getFunction()
      return fn.getName()
    }

    if let method = self.cast.asStaticMethod(object), let fn = method.getFunction() {
      return self.getName(function: fn)
    }

    if let method = self.cast.asClassMethod(object), let fn = method.getFunction() {
      return self.getName(function: fn)
    }

    return nil
  }

  // MARK: - Module

  public func newModule(name: String, doc: String?, dict: PyDict?) -> PyModule {
    let _name = self.intern(string: name)
    let _doc = doc.map(self.newString)
    return self.newModule(name: _name.asObject, doc: _doc?.asObject, dict: dict)
  }

  public func newModule(name: PyObject, doc: PyObject?, dict: PyDict?) -> PyModule {
    let type = self.types.module
    return self.memory.newModule(type: type, name: name, doc: doc, __dict__: dict)
  }

  public enum ModuleName {
    case notModule
    case string(String)
    case stringConversionFailed(PyObject, PyBaseException)
    case namelessModule
  }

  public func getName(module object: PyObject) -> ModuleName {
    guard let module = self.cast.asModule(object) else {
      return .notModule
    }

    switch module.getNameString(self) {
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
    let type = self.types.code
    return self.memory.newCode(type: type, code: code)
  }

  // MARK: - Frame

  // swiftlint:disable function_parameter_count

  /// PyFrameObject* _Py_HOT_FUNCTION
  /// _PyFrame_New_NoTrack(PyThreadState *tstate, PyCodeObject *code,
  public func newFrame(parent: PyFrame?,
                       code: PyCode,
                       args: [PyObject],
                       kwargs: PyDict?,
                       defaults: [PyObject],
                       kwDefaults: PyDict?,
                       locals: PyDict,
                       globals: PyDict,
                       closure: PyTuple?) -> PyResultGen<PyFrame> {
// swiftlint:enable function_parameter_count

    let type = self.types.frame
    let frame = self.memory.newFrame(type: type,
                                     code: code,
                                     locals: locals,
                                     globals: globals,
                                     parent: parent)

    let fastLocals = frame.fastLocals
    if let error = fastLocals.fill(self,
                                   code: code,
                                   args: args,
                                   kwargs: kwargs,
                                   defaults: defaults,
                                   kwDefaults: kwDefaults) {
      return .error(error.asBaseException)
    }

    let cells = frame.cellVariables
    cells.fill(code: code, fastLocals: fastLocals)

    let free = frame.freeVariables
    free.fill(self, code: code, closure: closure)

    return .value(frame)
  }

  // MARK: - Super

  public func newSuper(requestedType: PyType?,
                       object: PyObject?,
                       objectType: PyType?) -> PySuper {
    let type = self.types.super
    return self.memory.newSuper(type: type,
                                requestedType: requestedType,
                                object: object,
                                objectType: objectType)
  }

  // MARK: - Cell

  public func newCell(content: PyObject?) -> PyCell {
    let type = self.types.cell
    return self.memory.newCell(type: type, content: content)
  }

  // MARK: - Is abstract method

  public func isAbstractMethod(object: PyObject) -> PyResultGen<Bool> {
    if let result = PyStaticCall.__isabstractmethod__(self, object: object) {
      switch result {
      case let .value(o): return self.isTrueBool(object: o)
      case let .error(e): return .error(e)
      }
    }

    switch self.getAttribute(object: object, name: .__isabstractmethod__) {
    case let .value(o):
      return self.isTrueBool(object: o)
    case let .error(e):
      return .error(e)
    }
  }
}
