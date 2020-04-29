import VioletCore

public class DirResult: PyFunctionResultConvertible {

  private var elements = [PyObject]()
  private var cachedResult: PyFunctionResult?

  // MARK: - Init

  internal init() {}

  internal init<S: Sequence>(_ elements: S) where S.Element == PyObject {
    self.append(contentsOf: elements)
  }

  // MARK: - Append

  internal func append(_ element: PyObject) {
    self.cachedResult = nil // invalidate cache
    self.elements.append(element)
  }

  internal func append<S: Sequence>(contentsOf newElements: S)
    where S.Element == PyObject {

    for element in newElements {
      self.append(element)
    }
  }

  internal func append(contentsOf newElements: DirResult) {
    self.append(contentsOf: newElements.elements)
  }

  // MARK: - Append object

  internal func append(keysFrom object: PyObject) -> PyBaseException? {
    switch Py.callMethod(object: object, selector: .keys) {
    case let .value(keys):
      return self.append(elementsFrom: keys)
    case let .missingMethod(e),
         let .notCallable(e),
         let .error(e):
      return e
    }
  }

  internal func append(elementsFrom object: PyObject) -> PyBaseException? {
    switch Py.toArray(iterable: object) {
    case let .value(elements):
      self.append(contentsOf: elements)
      return nil
    case let .error(e):
      return e
    }
  }

  // MARK: - PyFunctionResultConvertible

  // 'DirResult' can be used as a return type in python functions.
  internal var asFunctionResult: PyFunctionResult {
    if let cached = self.cachedResult {
      return cached
    }

    let result: PyFunctionResult
    let list = Py.newList(self.elements)

    switch list.sort(key: nil, isReverse: false) {
    case .value:
      result = PyFunctionResult.value(list)
    case .error(let e):
      result = PyFunctionResult.error(e)
    }

    self.cachedResult = result
    return result
  }
}
