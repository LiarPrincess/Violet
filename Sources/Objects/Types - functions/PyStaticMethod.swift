// cSpell:ignore funcobject

// In CPython:
// Objects -> funcobject.c

// sourcery: pytype = staticmethod, isDefault, isBaseType, hasGC
// sourcery: instancesHave__dict__
public struct PyStaticMethod: PyObjectMixin {

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

  // sourcery: storedProperty
  internal var callable: PyObject? {
    get { self.callablePtr.pointee }
    nonmutating set { self.callablePtr.pointee = newValue }
  }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, callable: PyObject?) {
    self.initializeBase(py, type: type)
    self.callablePtr.initialize(to: callable)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyStaticMethod(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "callable", value: zelf.callable as Any)
    return result
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__dict__")
    }

    let result = zelf.getDict(py)
    return PyResult(result)
  }

  internal func getDict(_ py: Py) -> PyDict {
    let object = PyObject(ptr: self.ptr)

    guard let result = object.get__dict__(py) else {
      py.trapMissing__dict__(object: self)
    }

    return result
  }

  // MARK: - Func

  // sourcery: pyproperty = __func__
  internal static func __func__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__func__")
    }

    let result = zelf.getFunction()
    return PyResult(py, result)
  }

  internal func getFunction() -> PyObject? {
    return self.callable
  }

  // MARK: - Get

  // sourcery: pymethod = __get__
  internal static func __get__(_ py: Py,
                               zelf _zelf: PyObject,
                               object: PyObject,
                               type: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__get__")
    }

    guard let callable = zelf.callable else {
      return .runtimeError(py, message: "uninitialized staticmethod object")
    }

    return .value(callable)
  }

  // MARK: - Is abstract method

  // sourcery: pymethod = __isabstractmethod__
  internal static func __isabstractmethod__(_ py: Py,
                                            zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__isabstractmethod__")
    }

    guard let callable = zelf.callable else {
      return PyResult(py, false)
    }

    let result = py.isAbstractMethod(object: callable)
    return PyResult(py, result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    let result = py.memory.newStaticMethod(type: type, callable: nil)
    return PyResult(result)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf _zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__init__")
    }

    if let e = ArgumentParser.noKwargsOrError(py,
                                              fnName: Self.pythonTypeName,
                                              kwargs: kwargs) {
      return .error(e.asBaseException)
    }

    if let e = ArgumentParser.guaranteeArgsCountOrError(py,
                                                        fnName: Self.pythonTypeName,
                                                        args: args,
                                                        min: 1,
                                                        max: 1) {
      return .error(e.asBaseException)
    }

    let callable = args[0]
    zelf.callable = callable
    return .none(py)
  }
}
