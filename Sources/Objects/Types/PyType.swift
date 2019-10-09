internal class PyType: PyObject {

  internal let name: String = ""
  internal let base: PyType? = nil
  internal let subclasses: String = "" // weak

  internal let doc: String? = nil
  internal let mro: String = ""
  internal let dict: [String:Any] = [:]

  private unowned let _context: PyContext
  override internal var context: PyContext {
    return self._context
  }

  override internal var type: PyType {
    return self.context.types.typeType
  }

  internal init(context: PyContext) {
    self._context = context
    super.init()
  }
}
