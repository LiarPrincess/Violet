import BigInt
import VioletCore

// cSpell:ignore enumobject

// In CPython:
// Objects -> enumobject.c

// sourcery: pytype = enumerate, isDefault, hasGC, isBaseType
// sourcery: subclassInstancesHave__dict__
/// Return an enumerate object. iterable must be a sequence, an iterator,
/// or some other object which supports iteration.
public struct PyEnumerate: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc = """
    enumerate(iterable, start=0)
    --

    Return an enumerate object.

    iterable
    an object supporting iteration

    The enumerate object yields pairs containing a count (from start, which
    defaults to zero) and a value yielded by the iterable argument.

    enumerate is useful for obtaining an indexed list:
    (0, seq[0]), (1, seq[1]), (2, seq[2]), ...
    """

  // sourcery: storedProperty
  /// Secondary iterator of enumeration
  internal var iterator: PyObject { self.iteratorPtr.pointee }

  // sourcery: storedProperty
  /// Next used index of enumeration
  internal var nextIndex: BigInt {
    get { self.nextIndexPtr.pointee }
    nonmutating set { self.nextIndexPtr.pointee = newValue }
  }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, iterator: PyObject, initialIndex: BigInt) {
    self.initializeBase(py, type: type)
    self.iteratorPtr.initialize(to: iterator)
    self.nextIndexPtr.initialize(to: initialIndex)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyEnumerate(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "nextIndex", value: zelf.nextIndex, includeInDescription: true)
    result.append(name: "iterator", value: zelf.iterator)
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

    let item: PyObject
    switch py.next(iterator: zelf.iterator) {
    case .value(let n):
      item = n
    case .error(let e):
      // This also includes 'StopIteration'
      return .error(e)
    }

    let index = py.newInt(zelf.nextIndex)
    zelf.nextIndex += 1

    return PyResult(py, tuple: index.asObject, item)
  }

  // MARK: - Python new

  private static let newDoc = """
    enumerate(iterable, start=0)
    --

    Return an enumerate object.

      iterable
        an object supporting iteration

    The enumerate object yields pairs containing a count (from start, which
    defaults to zero) and a value yielded by the iterable argument.

    enumerate is useful for obtaining an indexed list:
        (0, seq[0]), (1, seq[1]), (2, seq[2]), ...
    """

  private static let newArguments = ArgumentParser.createOrTrap(
    arguments: ["iterable", "start"],
    format: "O|O:enumerate"
  )

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    switch PyEnumerate.newArguments.bind(py, args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 1, "Invalid required argument count.")
      assert(binding.optionalCount == 1, "Invalid optional argument count.")

      let iterable = binding.required(at: 0)
      let start = binding.optional(at: 1)
      return PyEnumerate.__new__(py, type: type, iterable: iterable, startFrom: start)

    case let .error(e):
      return .error(e)
    }
  }

  internal static func __new__(_ py: Py,
                               type: PyType,
                               iterable: PyObject,
                               startFrom index: PyObject?) -> PyResult {
    var initialIndex = BigInt(0)
    if let index = index {
      switch IndexHelper.pyInt(py, object: index) {
      case let .value(i):
        initialIndex = i.value
      case let .notIndex(lazyError):
        let e = lazyError.create(py)
        return .error(e)
      case let .error(e):
        return .error(e)
      }
    }

    let iter: PyObject
    switch py.iter(object: iterable) {
    case let .value(i): iter = i
    case let .error(e): return .error(e)
    }

    let result = py.memory.newEnumerate(type: type,
                                        iterator: iter,
                                        initialIndex: initialIndex)

    return PyResult(result)
  }
}
