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
}
