public class PyContext {

  // Internal typed values
  internal lazy var _true  = PyBool(self, value: true)
  internal lazy var _false = PyBool(self, value: false)
  internal lazy var _none  = PyNone(self)
  internal lazy var _ellipsis = PyEllipsis(self)
  internal lazy var _notImplemented = PyNotImplemented(self)
  internal lazy var _emptyTuple = PyTuple(self, elements: [])

  // Public PyObject values
  public var `true`:   PyObject { return self._true }
  public var `false`:  PyObject { return self._false }
  public var none:     PyObject { return self._none }
  public var ellipsis: PyObject { return self._ellipsis }
  public var notImplemented: PyObject { return self._notImplemented }
  public var emptyTuple: PyObject { return self._emptyTuple }

  internal lazy var types = PyContextTypes(context: self)
//  internal lazy var errorTypes = PyContextErrorTypes(context: self)
//  internal lazy var warningTypes = PyContextWarningTypes(context: self)

  public lazy var builtins = Builtins(context: self)

  public init() { }
}

// MARK: - Types

internal final class PyContextTypes {

  /// Root of the type hierarchy
  internal let object: PyType
  /// Type which is set as `type` on all of the `PyType` objects
  internal let type: PyType

  internal let none: PyType
  internal let ellipsis: PyType
  internal let notImplemented: PyType

  internal let int: PyType
  internal let float: PyType
  internal let bool: PyType
  internal let complex: PyType

  internal let tuple: PyType
  internal let list: PyType
//  internal let set: PyType
//  internal let dict: PyType

  internal let slice: PyType
  internal let range: PyType
//  internal let enumerate: PyType
//  internal let string: PyType

  internal let code: PyType
  internal let module: PyType
  internal let namespace: PyType
  internal let builtinFunction: PyType
  internal let property: PyType
  internal let function: PyType
  internal let method: PyType

  fileprivate init(context: PyContext) {
    // Requirements:
    // 1. `type` inherits from `object`
    // 2. both `type` and `object` are instances of `type`
    // And yes, it is a cycle that will never be deallocated

    self.object = TypeFactory.objectWithoutType(context)
    self.type = TypeFactory.typeWithoutType(context, base: self.object)
    self.object.setType(to: self.type)
    self.type.setType(to: self.type)

    self.none     = TypeFactory.none(context, type: self.type, base: self.object)
    self.ellipsis = TypeFactory.ellipsis(context, type: self.type, base: self.object)
    self.notImplemented = TypeFactory.notImplemented(context, type: self.type, base: self.object)

    self.int     = TypeFactory.int(context,     type: self.type, base: self.object)
    self.float   = TypeFactory.float(context,   type: self.type, base: self.object)
    self.bool    = TypeFactory.bool(context,    type: self.type, base: self.int)
    self.complex = TypeFactory.complex(context, type: self.type, base: self.object)

    self.tuple = TypeFactory.tuple(context, type: self.type, base: self.object)
    self.list  = TypeFactory.list(context,  type: self.type, base: self.object)
//    self.set   = TypeFactory(context, name: "set",   type: self.type, base: self.object)
//    self.dict  = TypeFactory(context, name: "dict",  type: self.type, base: self.object)

    self.slice = TypeFactory.slice(context, type: self.type, base: self.object)
    self.range = TypeFactory.range(context, type: self.type, base: self.object)
//    self.enumerate = TypeFactory.enumerate(context, type: self.type, base: self.object)
//    self.string = TypeFactory(context, name: "string", type: self.type, base: self.object)

    self.code = TypeFactory.code(context, type: self.type, base: self.object)
    self.module = TypeFactory.module(context, type: self.type, base: self.object)
    self.namespace = TypeFactory.simpleNamespace(context, type: self.type, base: self.object)
    self.builtinFunction = TypeFactory.builtinFunction(context, type: self.type, base: self.object)
    self.property = TypeFactory.property(context, type: self.type, base: self.object)
    self.function = TypeFactory.function(context, type: self.type, base: self.object)
    self.method = TypeFactory.method(context, type: self.type, base: self.object)
  }
}
