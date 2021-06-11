internal enum SpecialIdentifiers {

  /// Name used for function `return` type in `__annotations__ dict`.
  ///
  /// ```py
  /// def f() -> str:
  ///   return ''
  ///
  /// print(f.__annotations__) # -> {'return': <class 'str'>}
  /// ```
  internal static let returnAnnotationKey = "return"
  /// Built-in `super` function.
  /// See: https://docs.python.org/3/library/functions.html#super
  internal static let superFunctionName = "super"
  /// Name of the type to instantiate when assertion fails.
  internal static let assertionErrorTypeName = "AssertionError"

  /// Name of the `dict` used for holding `__annotations__`.
  ///
  /// You can use `self.builder.appendLoadName(SpecialIdentifiers.__annotations__)`
  /// to access it.
  internal static let __annotations__ = "__annotations__"
  /// https://docs.python.org/3/tutorial/classes.html
  internal static let __class__ = "__class__"
  /// https://docs.python.org/3/tutorial/classes.html
  internal static let __classcell__ = "__classcell__"
  /// Used to store `__doc__` for `modules`, `classes` and `functions`.
  internal static let __doc__ = "__doc__"
  /// Name of the special `__future__` module.
  internal static let __future__ = "__future__"
  /// Used in `class` to load (global) `__name__` and store it as `__module__`.
  internal static let __module__ = "__module__"
  /// Used in `class` to load (global) `__name__` and store it as `__module__`.
  internal static let __name__ = "__name__"
  /// Used in `class` to store `__qualname__`.
  internal static let __qualname__ = "__qualname__"
}
