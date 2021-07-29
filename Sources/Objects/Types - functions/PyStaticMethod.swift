// cSpell:ignore funcobject

// In CPython:
// Objects -> funcobject.c

// sourcery: pytype = staticmethod, default, baseType, hasGC
// sourcery: instancesHave__dict__
public final class PyStaticMethod: PyObject {

  // sourcery: pytypedoc
  internal static let doc = """
    staticmethod(function) -> method

    Convert a function to be a static method.

    A static method does not receive an implicit first argument.
    To declare a static method, use this idiom:

         class C:
             @staticmethod
             def f(arg1, arg2, ...):
                 ...

    It can be called either on the class (e.g. C.f()) or on an instance
    (e.g. C().f()).  The instance is ignored except for its class.

    Static methods in Python are similar to those found in Java or C++.
    For a more advanced concept, see the classmethod builtin.
    """

  override public var description: String {
    let c = self.callable.map(String.init) ?? "nil"
    return "PyStaticMethod(callable: \(c))"
  }

  private var callable: PyObject?

  internal convenience init(callable: PyObject) {
    let type = Py.types.staticmethod
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
      return .runtimeError("uninitialized staticmethod object")
    }

    return .value(callable)
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
                            kwargs: PyDict?) -> PyResult<PyStaticMethod> {
    let result = PyMemory.newStaticMethod(type: type, callable: nil)
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