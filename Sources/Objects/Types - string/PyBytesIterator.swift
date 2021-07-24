import VioletCore

// cSpell:ignore bytesobject

// In CPython:
// Objects -> bytesobject.c

// sourcery: pytype = bytes_iterator, default, hasGC
public final class PyBytesIterator: PyObject {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  internal let bytes: PyBytes
  internal private(set) var index: Int

  // MARK: - Init

  internal init(bytes: PyBytes) {
    self.bytes = bytes
    self.index = 0
    super.init(type: Py.types.bytes_iterator)
  }

  override public var description: String {
    return "PyBytesIterator(bytes: \(self.bytes), index: \(self.index))"
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
    if self.index < self.bytes.count {
      let byte = self.bytes.elements[self.index]
      let result = Py.newInt(byte)
      self.index += 1
      return .value(result)
    }

    return .stopIteration()
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  internal func lengthHint() -> PyInt {
    let count = self.bytes.count
    let result = count - self.index
    return Py.newInt(result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyBytesIterator> {
    return .typeError("cannot create 'bytes_iterator' instances")
  }
}
