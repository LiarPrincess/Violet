import VioletCore

// In CPython:
// Python -> builtinmodule.c

// sourcery: pytype = zip, default, hasGC, baseType
public class PyZip: PyObject {

  // sourcery: pytypedoc
  internal static let doc = """
    zip(iter1 [,iter2 [...]]) --> zip object

    Return a zip object whose .__next__() method returns a tuple where
    the i-th element comes from the i-th iterable argument.  The .__next__()
    method continues until the shortest iterable in the argument sequence
    is exhausted and then it raises StopIteration.
    """

  internal let iterators: [PyObject]

  override public var description: String {
    return "PyZip(iterator count: \(self.iterators.count))"
  }

  // MARK: - Init

  internal convenience init(iterators: [PyObject]) {
    let type = Py.types.zip
    self.init(type: type, iterators: iterators)
  }

  internal init(type: PyType, iterators: [PyObject]) {
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
    if self.iterators.isEmpty {
      return .stopIteration()
    }

    var result = [PyObject]()
    for iter in self.iterators {
      switch Py.next(iterator: iter) {
      case let .value(o):
        result.append(o)
      case let .error(e): // that includes 'stopIteration'
        return .error(e)
      }
    }

    // Multiple iterators -> tuple
    let tuple = Py.newTuple(elements: result)
    return .value(tuple)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyZip> {
    if type === Py.types.zip {
      if let e = ArgumentParser.noKwargsOrError(fnName: "zip", kwargs: kwargs) {
        return .error(e)
      }
    }

    var iters = [PyObject]()

    for (index, object) in args.enumerated() {
      switch Py.iter(object: object) {
      case .value(let i):
        iters.append(i)

      case .error(let e):
        if e.isTypeError {
          return .typeError("zip argument \(index + 1) must support iteration")
        }

        return .error(e)
      }
    }

    let result = PyMemory.newZip(type: type, iterators: iters)
    return .value(result)
  }
}
