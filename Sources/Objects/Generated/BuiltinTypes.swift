// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// swiftlint:disable:previous vertical_whitespace

public final class BuiltinTypes {

  /// Root of the type hierarchy
  public let object: PyType
  /// Type which is set as `type` on all of the `PyType` objects
  public let type: PyType

  public let bool: PyType
  public let builtinFunction: PyType
  public let code: PyType
  public let complex: PyType
  public let dict: PyType
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
  public let set: PyType
  public let slice: PyType
  public let str: PyType
  public let tuple: PyType

  internal init(context: PyContext) {
    // Requirements (for `self.object` and `self.type`):
    // 1. `type` inherits from `object`
    // 2. both `type` and `object` are instances of `type`
    // And yes, it is a cycle that will never be deallocated

    self.object = TypeFactory.objectWithoutType(context)
    self.type = TypeFactory.typeWithoutType(context, base: self.object)
    self.object.setType(to: self.type)
    self.type.setType(to: self.type)

    // `self.bool` has to be last because it uses `self.int` as base!
    self.builtinFunction = TypeFactory.builtinFunction(context, type: self.type, base: self.object)
    self.code = TypeFactory.code(context, type: self.type, base: self.object)
    self.complex = TypeFactory.complex(context, type: self.type, base: self.object)
    self.dict = TypeFactory.dict(context, type: self.type, base: self.object)
    self.ellipsis = TypeFactory.ellipsis(context, type: self.type, base: self.object)
    self.float = TypeFactory.float(context, type: self.type, base: self.object)
    self.function = TypeFactory.function(context, type: self.type, base: self.object)
    self.int = TypeFactory.int(context, type: self.type, base: self.object)
    self.list = TypeFactory.list(context, type: self.type, base: self.object)
    self.method = TypeFactory.method(context, type: self.type, base: self.object)
    self.module = TypeFactory.module(context, type: self.type, base: self.object)
    self.simpleNamespace = TypeFactory.simpleNamespace(context, type: self.type, base: self.object)
    self.none = TypeFactory.none(context, type: self.type, base: self.object)
    self.notImplemented = TypeFactory.notImplemented(context, type: self.type, base: self.object)
    self.property = TypeFactory.property(context, type: self.type, base: self.object)
    self.range = TypeFactory.range(context, type: self.type, base: self.object)
    self.set = TypeFactory.set(context, type: self.type, base: self.object)
    self.slice = TypeFactory.slice(context, type: self.type, base: self.object)
    self.str = TypeFactory.str(context, type: self.type, base: self.object)
    self.tuple = TypeFactory.tuple(context, type: self.type, base: self.object)
    self.bool = TypeFactory.bool(context, type: self.type, base: self.int)
  }
}
