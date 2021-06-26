import VioletCore

// In CPython:
// Python -> builtinmodule.c

// sourcery: pytype = map, default, hasGC, baseType
public class PyMap: PyObject {

  internal static let doc: String = """
    map(func, *iterables) --> map object

    Make an iterator that computes the function using arguments from
    each of the iterables.  Stops when the shortest iterable is exhausted.
    """

  internal let fn: PyObject
  internal let iterators: [PyObject]

  override public var description: String {
    return "PyMap(iterator count: \(self.iterators.count))"
  }

  // MARK: - Init

  internal convenience init(fn: PyObject, iterators: [PyObject]) {
    let type = Py.types.map
    self.init(type: type, fn: fn, iterators: iterators)
  }

  internal init(type: PyType, fn: PyObject, iterators: [PyObject]) {
    self.fn = fn
    self.iterators = iterators
    super.init(type: type)
  }

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
    case .error(let e), .notCallable(let e):
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
