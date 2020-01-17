import Objects
import Bytecode

extension Frame {

  /// Performs a `Boolean` operation.
  internal func compareOp(comparison: ComparisonOpcode) -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.compare(left: left, right: right, comparison: comparison) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .error(e)
    }
  }

  private func compare(left: PyObject,
                       right: PyObject,
                       comparison: ComparisonOpcode) -> PyResult<PyObject> {
    switch comparison {
    case .equal:
      return Py.isEqual(left: left, right: right)
    case .notEqual:
      return Py.isNotEqual(left: left, right: right)
    case .less:
      return Py.isLess(left: left, right: right)
    case .lessEqual:
      return Py.isLessEqual(left: left, right: right)
    case .greater:
      return Py.isGreater(left: left, right: right)
    case .greaterEqual:
      return Py.isGreaterEqual(left: left, right: right)
    case .is:
      let result = Py.is(left: left, right: right)
      return .value(Py.newBool(result))
    case .isNot:
      let result = Py.is(left: left, right: right)
      return .value(Py.newBool(!result))
    case .in:
      let result = Py.contains(iterable: left, element: right)
      return result.map(Py.newBool)
    case .notIn:
      let result = Py.contains(iterable: left, element: right)
      return result.map { !$0 }.map(Py.newBool)
    case .exceptionMatch:
      // ceval.c -> case PyCmp_EXC_MATCH:
      fatalError()
    }
  }
}
