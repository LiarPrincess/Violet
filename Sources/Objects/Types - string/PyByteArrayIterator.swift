import VioletCore

// In CPython:
// Objects -> bytearrayobject.c

// sourcery: pytype = bytearray_iterator, default, hasGC
public class PyByteArrayIterator: PyObject {

  internal let bytes: PyByteArray
  internal private(set) var index: Int

  // MARK: - Init

  internal init(bytes: PyByteArray) {
    self.bytes = bytes
    self.index = 0
    super.init(type: Py.types.bytearray_iterator)
  }

  override public var description: String {
    return "PyByteArrayIterator(bytes: \(self.bytes), index: \(self.index))"
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  public func getClass() -> PyType {
    return self.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  public func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  public func iter() -> PyObject {
    return self
  }

  // MARK: - Next

  // sourcery: pymethod = __next__
  public func next() -> PyResult<PyObject> {
    let scalars = self.bytes.data.scalars

    if self.index < scalars.count {
      let byte = scalars[self.index]
      let result = Py.newInt(byte)
      self.index += 1
      return .value(result)
    }

    return .stopIteration()
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  public func lengthHint() -> PyInt {
    let data = self.bytes.data.values
    let result = data.count - self.index
    return Py.newInt(result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyByteArrayIterator> {
    return .typeError("cannot create 'bytearray_iterator' instances")
  }
}
