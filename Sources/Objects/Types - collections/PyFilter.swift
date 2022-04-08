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

  // sourcery: storedProperty
  internal var fn: PyObject { self.fnPtr.pointee }
  // sourcery: storedProperty
  internal var iterator: PyObject { self.iteratorPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, fn: PyObject, iterator: PyObject) {
    self.initializeBase(py, type: type)
    self.fnPtr.initialize(to: fn)
    self.iteratorPtr.initialize(to: iterator)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyFilter(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "iterator", value: zelf.iterator)
    result.append(name: "fn", value: zelf.fn)
    return result
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf _zelf: PyObject,
                                        name: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal static func __iter__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__iter__")
    }

    return PyResult(zelf)
  }

  // MARK: - Next

  // sourcery: pymethod = __next__
  internal static func __next__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__next__")
    }

    let useTrivialBoolCheck = py.cast.isNone(zelf.fn) || py.cast.isBool(zelf.fn)

    loop: while true {
      switch py.next(iterator: zelf.iterator) {
      case let .value(item):
        if useTrivialBoolCheck {
          switch py.isTrueBool(object: item) {
          case .value(true): return .value(item)
          case .value(false): continue loop // try next item
          case .error(let e): return .error(e)
          }
        }

        switch py.call(callable: zelf.fn, args: [item]) {
        case .value(let r):
          switch py.isTrueBool(object: r) {
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
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    if type === py.types.filter {
      if let e = ArgumentParser.noKwargsOrError(py,
                                                fnName: Self.pythonTypeName,
                                                kwargs: kwargs) {
        return .error(e.asBaseException)
      }
    }

    if let e = ArgumentParser.guaranteeArgsCountOrError(py,
                                                        fnName: Self.pythonTypeName,
                                                        args: args,
                                                        min: 2,
                                                        max: 2) {
      return .error(e.asBaseException)
    }

    let fn = args[0]
    let seq = args[1]

    let iter: PyObject
    switch py.iter(object: seq) {
    case let .value(i): iter = i
    case let .error(e): return .error(e)
    }

    let result = py.memory.newFilter(type: type, fn: fn, iterator: iter)
    return PyResult(result)
  }
}
