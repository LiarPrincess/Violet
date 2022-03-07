import VioletCore

// In CPython:
// Python -> builtinmodule.c

// sourcery: pytype = map, isDefault, hasGC, isBaseType
// sourcery: subclassInstancesHave__dict__
public struct PyMap: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc = """
    map(func, *iterables) --> map object

    Make an iterator that computes the function using arguments from
    each of the iterables.  Stops when the shortest iterable is exhausted.
    """

  // sourcery: includeInLayout
  internal var fn: PyObject { self.fnPtr.pointee }
  // sourcery: includeInLayout
  internal var iterators: [PyObject] { self.iteratorsPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, fn: PyObject, iterators: [PyObject]) {
    self.header.initialize(py, type: type)
    self.fnPtr.initialize(to: fn)
    self.iteratorsPtr.initialize(to: iterators)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyMap(ptr: ptr)
    return "PyMap(type: \(zelf.typeName), flags: \(zelf.flags))"
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

    var args = [PyObject]()
    for iter in zelf.iterators {
      switch py.next(iterator: iter) {
      case let .value(o):
        args.append(o)
      case let .error(e): // that includes 'stopIteration'
        return .error(e)
      }
    }

    switch py.call(callable: zelf.fn, args: args) {
    case .value(let r):
      return .value(r)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    if type === py.types.map {
      if let e = ArgumentParser.noKwargsOrError(py,
                                                fnName: Self.pythonTypeName,
                                                kwargs: kwargs) {
        return .error(e.asBaseException)
      }
    }

    if args.count < 2 {
      return .typeError(py, message: "map() must have at least two arguments.")
    }

    let fn = args[0]
    var iters = [PyObject]()

    for object in args[1...] {
      switch py.iter(object: object) {
      case let .value(i): iters.append(i)
      case let .error(e): return .error(e)
      }
    }

    let result = py.memory.newMap(py, type: type, fn: fn, iterators: iters)
    return PyResult(result)
  }
}
