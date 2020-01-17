import Core

// In CPython:
// Objects -> bytesobject.c

// sourcery: pytype = bytes_iterator, default, hasGC
public class PyBytesIterator: PyObject {

  internal let bytes: PyBytes
  internal private(set) var index: Int

  // MARK: - Init

  internal init(bytes: PyBytes) {
    self.bytes = bytes
    self.index = 0
    super.init(type: Py.types.bytes_iterator)
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
    let scalars = self.bytes.data.scalars
    let scalarsIndexOrNil = scalars.index(scalars.startIndex,
                                          offsetBy: self.index,
                                          limitedBy: scalars.endIndex)

    if let scalarsIndex = scalarsIndexOrNil {
      self.index += 1
      let byte = scalars[scalarsIndex]
      return .value(Py.newInt(byte))
    }

    return .stopIteration()
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDictData?) -> PyResult<PyObject> {
    return .typeError("cannot create 'bytes_iterator' instances")
  }
}
