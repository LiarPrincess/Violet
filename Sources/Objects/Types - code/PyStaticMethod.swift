// In CPython:
// Objects -> funcobject.c

// sourcery: pytype = staticmethod, default, baseType, hasGC
public class PyStaticMethod: PyObject {

  internal static let doc: String = """
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
  private lazy var __dict__ = PyDict()

  internal convenience init(callable: PyObject) {
    let type = Py.types.staticmethod
    self.init(type: type, callable: callable)
  }

  /// Use only in `__new__`!
  private init(type: PyType, callable: PyObject?) {
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
  public func getDict() -> PyDict {
    return self.__dict__
  }

  // MARK: - Func

  // sourcery: pyproperty = __func__
  internal func getFunc() -> PyObject? {
    return self.callable
  }

  // MARK: - Get

  // sourcery: pymethod = __get__
  public func get(object: PyObject, type: PyObject) -> PyResult<PyObject> {
    guard let callable = self.callable else {
      return .runtimeError("uninitialized staticmethod object")
    }

    return .value(callable)
  }

  // MARK: - Is abstract method

  // sourcery: pymethod = __isabstractmethod__
  public func isAbstractMethod() -> PyResult<Bool> {
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
    let result = PyStaticMethod(type: type, callable: nil)
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
