// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// swiftlint:disable:previous vertical_whitespace

// MARK: - Types

public final class BuiltinTypes {

  /// Root of the type hierarchy
  public let object: PyType
  /// Type which is set as `type` on all of the `PyType` objects
  public let type: PyType

  public let bool: PyType
  public let builtinFunction: PyType
  public let code: PyType
  public let complex: PyType
  public let ellipsis: PyType
  public let float: PyType
  public let function: PyType
  public let int: PyType
  public let list: PyType
  public let method: PyType
  public let module: PyType
  public let simpleNamespace: PyType
  public let none: PyType
  public let notImplemented: PyType
  public let property: PyType
  public let range: PyType
  public let slice: PyType
  public let tuple: PyType

  internal init(context: PyContext) {
    // Requirements:
    // 1. `type` inherits from `object`
    // 2. both `type` and `object` are instances of `type`
    // And yes, it is a cycle that will never be deallocated

    self.object = PyType.objectWithoutType(context)
    self.type = PyType.typeWithoutType(context, base: self.object)
    self.object.setType(to: self.type)
    self.type.setType(to: self.type)

    // `self.bool` has to be last because it uses `self.int` as base!
    self.builtinFunction = PyType.builtinFunction(context, type: self.type, base: self.object)
    self.code = PyType.code(context, type: self.type, base: self.object)
    self.complex = PyType.complex(context, type: self.type, base: self.object)
    self.ellipsis = PyType.ellipsis(context, type: self.type, base: self.object)
    self.float = PyType.float(context, type: self.type, base: self.object)
    self.function = PyType.function(context, type: self.type, base: self.object)
    self.int = PyType.int(context, type: self.type, base: self.object)
    self.list = PyType.list(context, type: self.type, base: self.object)
    self.method = PyType.method(context, type: self.type, base: self.object)
    self.module = PyType.module(context, type: self.type, base: self.object)
    self.simpleNamespace = PyType.simpleNamespace(context, type: self.type, base: self.object)
    self.none = PyType.none(context, type: self.type, base: self.object)
    self.notImplemented = PyType.notImplemented(context, type: self.type, base: self.object)
    self.property = PyType.property(context, type: self.type, base: self.object)
    self.range = PyType.range(context, type: self.type, base: self.object)
    self.slice = PyType.slice(context, type: self.type, base: self.object)
    self.tuple = PyType.tuple(context, type: self.type, base: self.object)
    self.bool = PyType.bool(context, type: self.type, base: self.int)
  }
}

// MARK: - Errors

public final class BuiltinErrors {

  // public let baseException: PyType
  // public let exception: PyType
  // public let generatorExit: PyType
  // public let keyboardInterrupt: PyType

  internal init(context: PyContext, types: BuiltinTypes) {
    // self.baseException = PyType.baseException(context, type: types.type, base: types.object)
    // self.exception = PyType.exception(context, type: types.type, base: types.object)
    // self.generatorExit = PyType.generatorExit(context, type: types.type, base: types.object)
    // self.keyboardInterrupt = PyType.keyboardInterrupt(context, type: types.type, base: types.object)
  }
}

// MARK: - Warnings

public final class BuiltinWarnings {

  // public let bytesWarning: PyType
  // public let deprecationWarning: PyType
  // public let futureWarning: PyType
  // public let importWarning: PyType
  // public let pendingDeprecationWarning: PyType
  // public let resourceWarning: PyType
  // public let runtimeWarning: PyType
  // public let syntaxWarning: PyType
  // public let unicodeWarning: PyType
  // public let userWarning: PyType
  // public let warning: PyType

  internal init(context: PyContext, types: BuiltinTypes) {
    // self.bytesWarning = PyType.bytesWarning(context, type: types.type, base: types.object)
    // self.deprecationWarning = PyType.deprecationWarning(context, type: types.type, base: types.object)
    // self.futureWarning = PyType.futureWarning(context, type: types.type, base: types.object)
    // self.importWarning = PyType.importWarning(context, type: types.type, base: types.object)
    // self.pendingDeprecationWarning = PyType.pendingDeprecationWarning(context, type: types.type, base: types.object)
    // self.resourceWarning = PyType.resourceWarning(context, type: types.type, base: types.object)
    // self.runtimeWarning = PyType.runtimeWarning(context, type: types.type, base: types.object)
    // self.syntaxWarning = PyType.syntaxWarning(context, type: types.type, base: types.object)
    // self.unicodeWarning = PyType.unicodeWarning(context, type: types.type, base: types.object)
    // self.userWarning = PyType.userWarning(context, type: types.type, base: types.object)
    // self.warning = PyType.warning(context, type: types.type, base: types.object)
  }
}
