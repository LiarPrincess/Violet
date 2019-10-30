// Most of this file was generatued using 'Scripes/generate_errors.py'.

// swiftlint:disable line_length

public final class BuiltinWarningTypes {

  public let warning: PyType
  public let deprecationWarning: PyType
  public let pendingDeprecationWarning: PyType
  public let runtimeWarning: PyType
  public let syntaxWarning: PyType
  public let userWarning: PyType
  public let futureWarning: PyType
  public let importWarning: PyType
  public let unicodeWarning: PyType
  public let bytesWarning: PyType
  public let resourceWarning: PyType

  internal init(context: PyContext, types: BuiltinTypes, errors: BuiltinErrorTypes) {
    self.warning = PyType.warning(context, type: types.type, base: errors.exception)
    self.deprecationWarning = PyType.deprecationWarning(context, type: types.type, base: self.warning)
    self.pendingDeprecationWarning = PyType.pendingDeprecationWarning(context, type: types.type, base: self.warning)
    self.runtimeWarning = PyType.runtimeWarning(context, type: types.type, base: self.warning)
    self.syntaxWarning = PyType.syntaxWarning(context, type: types.type, base: self.warning)
    self.userWarning = PyType.userWarning(context, type: types.type, base: self.warning)
    self.futureWarning = PyType.futureWarning(context, type: types.type, base: self.warning)
    self.importWarning = PyType.importWarning(context, type: types.type, base: self.warning)
    self.unicodeWarning = PyType.unicodeWarning(context, type: types.type, base: self.warning)
    self.bytesWarning = PyType.bytesWarning(context, type: types.type, base: self.warning)
    self.resourceWarning = PyType.resourceWarning(context, type: types.type, base: self.warning)
  }
}
