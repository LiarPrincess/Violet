import BigInt
import VioletCore

// cSpell:ignore rangeobject

// In CPython:
// Objects -> rangeobject.c

// sourcery: pytype = range_iterator, isDefault
public final class PyRangeIterator: PyObject {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  internal let start: BigInt
  internal let step: BigInt
  internal let length: BigInt
  internal var index: BigInt = 0

  // MARK: - Init

  internal init(start: BigInt, step: BigInt, length: BigInt) {
    self.start = start
    self.step = step
    self.length = length
    super.init(type: Py.types.range_iterator)
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
      return .value(Py.newInt(result))
    }

    return .stopIteration()
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  internal func lengthHint() -> PyInt {
    let result = self.length - self.index
    return Py.newInt(result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyRangeIterator> {
    return .typeError("cannot create 'range_iterator' instances")
  }
}
