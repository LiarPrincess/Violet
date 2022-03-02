import VioletCore

public class DirResult: PyFunctionResultConvertible {

  private var elements = [PyObject]()
  /// Avoid sorting if we are already sorted.
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

  // MARK: - Append keys/elements

  internal func append(_ py: Py, keysFrom object: PyObject) -> PyBaseException? {
    switch py.getKeys(object: object) {
    case let .value(keys):
      return self.append(py, elementsFrom: keys)
    case let .missingMethod(e),
         let .error(e):
      return e
    }
  }

  internal func append(_ py: Py, elementsFrom iterable: PyObject) -> PyBaseException? {
    let e = py.forEach(iterable: iterable) { object in
      self.append(object)
      return .goToNextElement
    }

    return e
  }

  // MARK: - PyFunctionResultConvertible

  // 'DirResult' can be used as a return type in python function.
  public var asFunctionResult: PyFunctionResult {
/* MARKER

    if let cached = self.cachedResult {
      return cached
    }

    let result: PyFunctionResult
    let list = Py.newList(elements: self.elements)

    switch list.sort(key: nil, isReverse: false) {
    case .value:
      result = .value(list.asObject)
    case .error(let e):
      result = .error(e)
    }

    self.cachedResult = result
    return result
*/
    fatalError()
  }
}
