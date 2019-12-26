import Core

// In CPython:
// Objects -> rangeobject.c

// sourcery: pytype = range_iterator, default
public class PyRangeIterator: PyObject {

  internal let start: BigInt
  internal let step: BigInt
  internal let length: BigInt
  internal var index: BigInt = 0

  internal init(_ context: PyContext,
                start: BigInt,
                step: BigInt,
                length: BigInt) {
    self.start = start
    self.step = step
    self.length = length
    super.init(type: context.builtins.types.range_iterator)
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
    if self.index < self.length {
      let result = self.start + self.step * self.index
      self.index += 1
      return .value(self.builtins.newInt(result))
    }

    return .stopIteration
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDictData?) -> PyResult<PyObject> {
    return .typeError("cannot create 'range_iterator' instances")
  }
}
