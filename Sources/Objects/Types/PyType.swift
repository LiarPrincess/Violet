internal class PyType: TypeClass {

  internal var name: String { return "" }
  internal var base: PyType? { return nil }
  internal var doc: String? { return nil }
  internal unowned let context: PyContext

  internal init(context: PyContext) {
    self.context = context
  }
}
