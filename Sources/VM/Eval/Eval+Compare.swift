import VioletBytecode
import VioletObjects

extension Eval {

  internal typealias CompareType = Instruction.CompareType

  /// Performs a `Boolean` operation.
  internal func compareOp(type: CompareType) -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    let result = self.compare(type: type, left: left, right: right)
    Debug.compare(type: type, left: left, right: right, result: result)

    switch result {
    case let .value(o):
      self.stack.top = o
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  private func compare(type: CompareType, left: PyObject, right: PyObject) -> PyResult {
    switch type {
    case .equal:
      return self.py.isEqual(left: left, right: right)
    case .notEqual:
      return self.py.isNotEqual(left: left, right: right)
    case .less:
      return self.py.isLess(left: left, right: right)
    case .lessEqual:
      return self.py.isLessEqual(left: left, right: right)
    case .greater:
      return self.py.isGreater(left: left, right: right)
    case .greaterEqual:
      return self.py.isGreaterEqual(left: left, right: right)
    case .is:
      let isResult = left.ptr === right.ptr
      return PyResult(self.py, isResult)
    case .isNot:
      let isResult = left.ptr === right.ptr
      return PyResult(self.py, !isResult)
    case .in:
      // Iterable is on the right! For example: '1 in { 1, 2, 3 }'
      return self.py.contains(iterable: right, object: left)
    case .notIn:
      // Iterable is on the right! For example: '1 in { 1, 2, 3 }'
      switch self.py.contains(iterable: right, object: left) {
      case let .value(object):
        return self.py.not(object: object)
      case let .error(e):
        return .error(e)
      }
    case .exceptionMatch:
      return self.exceptionMatch(left: left, right: right)
    }
  }

  private func exceptionMatch(left: PyObject, right: PyObject) -> PyResult {
    let error: PyBaseException?
    if let rightTuple = self.py.cast.asTuple(right) {
      error = py.forEach(tuple: rightTuple) { _, object in
        if let e = self.guaranteeExceptionType(object) {
          return .error(e)
        }

        return .goToNextElement
      }
    } else {
      error = self.guaranteeExceptionType(right)
    }

    if let e = error {
      return .error(e)
    }

    let result = self.py.exceptionMatches(exception: left, expectedType: right)
    return PyResult(self.py, result)
  }

  private func guaranteeExceptionType(_ object: PyObject) -> PyBaseException? {
    if let type = self.py.cast.asType(object), self.py.isException(type: type) {
      return nil
    }

    let message = "catching classes that do not inherit from BaseException is not allowed"
    let error = self.py.newTypeError(message: message)
    return error.asBaseException
  }
}
