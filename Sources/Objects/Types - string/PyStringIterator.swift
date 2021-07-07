import VioletCore

// cSpell:ignore unicodeobject

// In CPython:
// Objects -> unicodeobject.c

// sourcery: pytype = str_iterator, default, hasGC
public class PyStringIterator: PyObject {

  internal let string: PyString
  internal private(set) var index: Int

  override public var description: String {
    return "PyStringIterator(string: \(self.string))"
  }

  // MARK: - Init

  internal init(string: PyString) {
    self.string = string
    self.index = 0
    super.init(type: Py.types.str_iterator)
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
    let elements = self.string.elements

    let indexOrNil = elements.index(elements.startIndex,
                                    offsetBy: self.index,
                                    limitedBy: elements.endIndex)

    if let index = indexOrNil, index != elements.endIndex {
      self.index += 1
      let scalar = elements[index]
      let string = Py.newString(scalar: scalar)
      return .value(string)
    }

    return .stopIteration()
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  public func lengthHint() -> PyInt {
    let count = self.string.count
    let result = count - self.index
    return Py.newInt(result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyStringIterator> {
    return .typeError("cannot create 'str_iterator' instances")
  }
}
