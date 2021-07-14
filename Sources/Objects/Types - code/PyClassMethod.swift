// cSpell:ignore funcobject

// In CPython:
// Objects -> funcobject.c

// sourcery: pytype = classmethod, default, baseType, hasGC
public class PyClassMethod: PyObject {

  // sourcery: pytypedoc
  internal static let doc = """
    classmethod(function) -> method

    Convert a function to be a class method.

    A class method receives the class as implicit first argument,
    just like an instance method receives the instance.
    To declare a class method, use this idiom:

      class C:
          @classmethod
          def f(cls, arg1, arg2, ...):
              ...

    It can be called either on the class (e.g. C.f()) or on an instance
    (e.g. C().f()).  The instance is ignored except for its class.
    If a class method is called for a derived class, the derived class
    object is passed as the implied first argument.

    Class methods are different than C++ or Java static methods.
    If you want those, see the staticmethod builtin.
    """

  override public var description: String {
    let c = self.callable.map(String.init) ?? "nil"
    return "PyClassMethod(callable: \(c))"
  }

  internal var callable: PyObject?
  internal lazy var __dict__ = Py.newDict()

  internal convenience init(callable: PyObject) {
    let type = Py.types.classmethod
    self.init(type: type, callable: callable)
  }

  internal init(type: PyType, callable: PyObject?) {
    self.callable = callable
    super.init(type: type)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal func getDict() -> PyDict {
    return self.__dict__
  }

  // MARK: - Func

  // sourcery: pyproperty = __func__
  internal func getFunction() -> PyObject? {
    return self.callable
  }

  // MARK: - Get

  // sourcery: pymethod = __get__
  internal func get(object: PyObject, type: PyObject?) -> PyResult<PyObject> {
    guard let callable = self.callable else {
      return .runtimeError("uninitialized classmethod object")
    }

    let t = type ?? object.type
    return Py.newMethod(fn: callable, object: t)
  }

  // MARK: - Is abstract method

  // sourcery: pymethod = __isabstractmethod__
  internal func isAbstractMethod() -> PyResult<Bool> {
    guard let callable = self.callable else {
      return .value(false)
    }

    return Py.isAbstractMethod(object: callable)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyClassMethod> {
    let result = PyMemory.newClassMethod(type: type, callable: nil)
    return .value(result)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    if let e = ArgumentParser.noKwargsOrError(fnName: self.typeName,
                                              kwargs: kwargs) {
      return .error(e)
    }

    if let e = ArgumentParser.guaranteeArgsCountOrError(fnName: self.typeName,
                                                        args: args,
                                                        min: 1,
                                                        max: 1) {
      return .error(e)
    }

    let callable = args[0]
    self.callable = callable
    return .value(Py.none)
  }
}
