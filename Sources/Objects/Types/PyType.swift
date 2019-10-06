internal class PyType: TypeClass {

  internal var name: String { return "" }
  internal var base: PyType? { return nil }
  internal var doc: String? { return nil }
  internal unowned let context: PyContext

  internal var types: PyContextTypes {
    return self.context.types
  }

  internal var errorTypes: PyContextErrorTypes {
    return self.context.errorTypes
  }

  internal var warningTypes: PyContextWarningTypes {
    return self.context.warningTypes
  }

  internal init(context: PyContext) {
    self.context = context
  }

  // MARK: - Shared

  internal func extractIndex(value: PyObject) throws -> Int? {
//    guard let indexType = value.type as? IndexTypeClass else {
//      return nil
//    }

//    let index = try indexType.index(value: value)
//    let bigInt = try self.context.types.int.extractInt(index)
//    guard let result = Int(exactly: bigInt) else {
//      // i = PyNumber_AsSsize_t(item, PyExc_IndexError);
//      fatalError()
//    }

//    return result
    return nil
  }
}
