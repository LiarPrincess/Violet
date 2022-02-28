import VioletCore

// In CPython:
// Python -> builtinmodule.c

// sourcery: pytype = filter, isDefault, hasGC, isBaseType
// sourcery: subclassInstancesHave__dict__
public struct PyFilter: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc = """
    filter(function or None, iterable) --> filter object

    Return an iterator yielding those items of iterable for which function(item)
    is true. If function is None, return the items that are true.
    """

  internal enum Layout {
    internal static let fnOffset = SizeOf.objectHeader
    internal static let fnSize = SizeOf.object

    internal static let iteratorOffset = fnOffset + fnSize
    internal static let iteratorSize = SizeOf.object

    internal static let size = iteratorOffset + iteratorSize
  }

  private var fnPtr: Ptr<PyObject> { self.ptr[Layout.fnOffset] }
  private var iteratorPtr: Ptr<PyObject> { self.ptr[Layout.iteratorOffset] }

  internal var fn: PyObject { self.fnPtr.pointee }
  internal var iterator: PyObject { self.iteratorPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(type: PyType, fn: PyObject, iterator: PyObject) {
    self.header.initialize(type: type)
    self.fnPtr.initialize(to: fn)
    self.iteratorPtr.initialize(to: iterator)
  }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyFilter(ptr: ptr)
    zelf.header.deinitialize()
    zelf.fnPtr.deinitialize()
    zelf.iteratorPtr.deinitialize()
  }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyFilter(ptr: ptr)
    return "PyFilter(type: \(zelf.typeName), flags: \(zelf.flags))"
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
    let useTrivialBoolCheck = PyCast.isNone(self.fn) || PyCast.isBool(self.fn)

    loop: while true {
      switch Py.next(iterator: self.iterator) {
      case let .value(item):
        if useTrivialBoolCheck {
          switch Py.isTrueBool(object: item) {
          case .value(true): return .value(item)
          case .value(false): continue loop // try next item
          case .error(let e): return .error(e)
          }
        }

        switch Py.call(callable: self.fn, args: [item]) {
        case .value(let r):
          switch Py.isTrueBool(object: r) {
          case .value(true): return .value(item)
          case .value(false): continue loop // try next item
          case .error(let e): return .error(e)
          }
        case .error(let e),
             .notCallable(let e):
          return .error(e)
        }

      case let .error(e): // that includes 'stopIteration'
        return .error(e)
      }
    }
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyFilter> {
    if type === Py.types.filter {
      if let e = ArgumentParser.noKwargsOrError(fnName: "filter", kwargs: kwargs) {
        return .error(e)
      }
    }

    if let e = ArgumentParser.guaranteeArgsCountOrError(fnName: "filter",
                                                        args: args,
                                                        min: 2,
                                                        max: 2) {
      return .error(e)
    }

    let fn = args[0]
    let seq = args[1]

    let iter: PyObject
    switch Py.iter(object: seq) {
    case let .value(i): iter = i
    case let .error(e): return .error(e)
    }

    let result = PyMemory.newFilter(type: type, fn: fn, iterator: iter)
    return .value(result)
  }
}

*/
