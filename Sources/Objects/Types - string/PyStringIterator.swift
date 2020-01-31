import Core

// In CPython:
// Objects -> unicodeobject.c

// sourcery: pytype = str_iterator, default, hasGC
public class PyStringIterator: PyObject {

  internal let string: PyString
  internal private(set) var index: Int

  override public var description: String {
    return "PyStringIterator()"
  }

  // MARK: - Init

  internal init(string: PyString) {
    self.string = string
    self.index = 0
    super.init(type: Py.types.str_iterator)
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

  internal func getAttribute(name: String) -> PyResult<PyObject> {
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
    let scalars = self.string.data.scalars
    let scalarsIndexOrNil = scalars.index(scalars.startIndex,
                                          offsetBy: self.index,
                                          limitedBy: scalars.endIndex)

    if let scalarsIndex = scalarsIndexOrNil {
      self.index += 1
      let char = String(scalars[scalarsIndex])
      return .value(Py.newString(char))
    }

    return .stopIteration()
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDictData?) -> PyResult<PyObject> {
    return .typeError("cannot create 'str_iterator' instances")
  }
}
