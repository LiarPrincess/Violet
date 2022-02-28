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

  internal enum Layout {
    internal static let fnOffset = SizeOf.objectHeader
    internal static let fnSize = SizeOf.object

    internal static let iteratorsOffset = fnOffset + fnSize
    internal static let iteratorsSize = SizeOf.array

    internal static let size = iteratorsOffset + iteratorsSize
  }

  private var fnPtr: Ptr<PyObject> { Ptr(self.ptr, offset: Layout.fnOffset) }
  private var iteratorsPtr: Ptr<[PyObject]> { Ptr(self.ptr, offset: Layout.iteratorsOffset) }

  internal var fn: PyObject { self.fnPtr.pointee }
  internal var iterators: [PyObject] { self.iteratorsPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(type: PyType, fn: PyObject, iterators: [PyObject]) {
    self.header.initialize(type: type)
    self.fnPtr.initialize(to: fn)
    self.iteratorsPtr.initialize(to: iterators)
  }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyMap(ptr: ptr)
    zelf.header.deinitialize()
    zelf.fnPtr.deinitialize()
    zelf.iteratorsPtr.deinitialize()
  }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyMap(ptr: ptr)
    return "PyMap(type: \(zelf.typeName), flags: \(zelf.flags))"
  }
}

/* MARKER

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return self
  }

  // MARK: - Next

  // sourcery: pymethod = __next__
  internal func next() -> PyResult<PyObject> {
    var args = [PyObject]()
    for iter in self.iterators {
      switch Py.next(iterator: iter) {
      case let .value(o):
        args.append(o)
      case let .error(e): // that includes 'stopIteration'
        return .error(e)
      }
    }

    switch Py.call(callable: self.fn, args: args) {
    case .value(let r):
      return .value(r)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyMap> {
    if type === Py.types.map {
      if let e = ArgumentParser.noKwargsOrError(fnName: "map", kwargs: kwargs) {
        return .error(e)
      }
    }

    if args.count < 2 {
      return .typeError("map() must have at least two arguments.")
    }

    let fn = args[0]
    var iters = [PyObject]()

    for object in args[1...] {
      switch Py.iter(object: object) {
      case let .value(i): iters.append(i)
      case let .error(e): return .error(e)
      }
    }

    let result = PyMemory.newMap(type: type, fn: fn, iterators: iters)
    return .value(result)
  }
}

*/
