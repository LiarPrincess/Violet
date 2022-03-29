import Foundation
import BigInt
import FileSystem
import VioletCore
import VioletBytecode

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Py {

  // MARK: - Namespace

  public func newNamespace() -> PyNamespace {
    let dict = self.newDict()
    return self.newNamespace(dict: dict)
  }

  public func newNamespace(dict: PyDict) -> PyNamespace {
    let type = self.types.simpleNamespace
    return self.memory.newNamespace(type: type, __dict__: dict)
  }

  // MARK: - Dict

  /// Returns the **builtin** (!!!!) `__dict__` instance.
  ///
  /// Extreme edge case: object has `__dict__` attribute:
  /// ```py
  /// >>> class C():
  /// ...     def __init__(self):
  /// ...             self.__dict__ = { 'a': 1 }
  /// ...
  /// >>> c = C()
  /// >>> c.__dict__
  /// {'a': 1}
  /// ```
  /// This is actually `dict` stored as '\_\_dict\_\_' in real '\_\_dict\_\_'.
  /// In such situation this function returns real '\_\_dict\_\_'
  /// (not the user property!).
  public func get__dict__(object: PyObject) -> PyDict? {
    return object.get__dict__(self)
  }

  public func get__dict__(type: PyType) -> PyDict {
    return type.getDict(self)
  }

  public func get__dict__(module: PyModule) -> PyDict {
    return module.getDict(self)
  }

  public func get__dict__(error: PyBaseException) -> PyDict {
    return error.getDict(self)
  }

  internal func trapMissing__dict__<T: PyObjectMixin>(object: T) -> Never {
    trap("Expected '\(object.typeName)' to have a dict? Guess not.")
  }

  // MARK: - Id

  /// id(object)
  /// See [this](https://docs.python.org/3/library/functions.html#id)
  public func id(object: PyObject) -> PyInt {
    let ptr = object.ptr
    let pointer = Int(bitPattern: ptr)
    return self.newInt(pointer)
  }

  // MARK: - Dir

  internal static var dirDoc: String {
    return """
    dir([object]) -> list of strings

    If called without an argument, return the names in the current scope.
    Else, return an alphabetized list of names comprising (some of) the attributes
    of the given object, and of attributes reachable from it.
    If the object supplies a method named __dir__, it will be used; otherwise
    the default dir() logic is used and returns:
      for a module object: the module's attributes.
      for a class object:  its attributes, and recursively the attributes
        of its bases.
      for any other object: its attributes, its class's attributes, and
        recursively the attributes of its class's base classes.
    """
  }

  /// dir([object])
  /// See [this](https://docs.python.org/3/library/functions.html#dir)
  ///
  /// PyObject *
  /// PyObject_Dir(PyObject *obj)
  public func dir(object: PyObject? = nil) -> PyResult {
    if let object = object {
      return self.objectDir(object: object)
    }

    return self.localsDir()
  }

  /// static PyObject *
  /// _dir_object(PyObject *obj)
  private func objectDir(object: PyObject) -> PyResult {
    if let result = PyStaticCall.__dir__(self, object: object) {
      return PyResult(self, result)
    }

    switch self.callMethod(object: object, selector: .__dir__) {
    case .value(let o):
      // Now we need to sort them
      var dir = DirResult()
      if let e = dir.append(self, elementsFrom: o) {
        return .error(e)
      }

      return PyResult(self, dir)

    case .missingMethod:
      return .typeError(self, message: "object does not provide __dir__")
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  /// static PyObject *
  /// _dir_locals(void)
  private func localsDir() -> PyResult {
    guard let frame = self.delegate.getCurrentlyExecutedFrame(self) else {
      return .systemError(self, message: "frame does not exist")
    }

    var dir = DirResult()
    if let e = dir.append(self, keysFrom: frame.locals) {
      return .error(e)
    }

    return PyResult(self, dir)
  }
}
