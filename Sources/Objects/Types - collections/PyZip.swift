import VioletCore

// In CPython:
// Python -> builtinmodule.c

// sourcery: pytype = zip, isDefault, hasGC, isBaseType
// sourcery: subclassInstancesHave__dict__
public struct PyZip: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc = """
    zip(iter1 [,iter2 [...]]) --> zip object

    Return a zip object whose .__next__() method returns a tuple where
    the i-th element comes from the i-th iterable argument.  The .__next__()
    method continues until the shortest iterable in the argument sequence
    is exhausted and then it raises StopIteration.
    """

  // sourcery: storedProperty
  internal var iterators: [PyObject] { self.iteratorsPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, iterators: [PyObject]) {
    self.header.initialize(py, type: type)
    self.iteratorsPtr.initialize(to: iterators)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyZip(ptr: ptr)
    return "PyZip(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf: PyObject,
                                        name: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal static func __iter__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__iter__")
    }

    return PyResult(zelf)
  }

  // MARK: - Next

  // sourcery: pymethod = __next__
  internal static func __next__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__next__")
    }

    if zelf.iterators.isEmpty {
      return .stopIteration(py)
    }

    var result = [PyObject]()
    for iter in zelf.iterators {
      switch py.next(iterator: iter) {
      case let .value(o):
        result.append(o)
      case let .error(e): // that includes 'stopIteration'
        return .error(e)
      }
    }

    // Multiple iterators -> tuple
    return PyResult(py, tuple: result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    if type === py.types.zip {
      if let e = ArgumentParser.noKwargsOrError(py,
                                                fnName: Self.pythonTypeName,
                                                kwargs: kwargs) {
        return .error(e.asBaseException)
      }
    }

    var iters = [PyObject]()

    for (index, object) in args.enumerated() {
      switch py.iter(object: object) {
      case .value(let i):
        iters.append(i)

      case .error(let e):
        if py.cast.isTypeError(e.asObject) {
          let message = "zip argument \(index + 1) must support iteration"
          return .typeError(py, message: message)
        }

        return .error(e.asBaseException)
      }
    }

    let result = py.memory.newZip(py, type: type, iterators: iters)
    return PyResult(result)
  }
}
