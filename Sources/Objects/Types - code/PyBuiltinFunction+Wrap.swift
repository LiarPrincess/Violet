import Core

// swiftlint:disable file_length

// Why do we need so many overloads?
// For example for ternary methods (self + 2 args) we have:
// - TernaryFunction = (PyObject, PyObject, PyObject) -> FunctionResult
// - TernaryFunctionOpt = (PyObject, PyObject, PyObject?) -> FunctionResult
// - TernaryFunctionOptOpt = (PyObject, PyObject?, PyObject?) -> FunctionResult
//
// So:
// Some ternary (and also binary and quartary) methods can be called with
// smaller number of arguments (in other words: some arguments are optional).
// On the Swift side we represent this with optional arg.
//
// For example:
// `PyString.strip(_ chars: PyObject?) -> String` has single optional argument.
// When called without argument we will pass `nil`.
// When called with single argument we will pass it.
// When called with more than 1 argument we will return error (hopefully).
//
// It is also nice test to see if Swift can properly bind correct overload of
// `wrap`.
// Technically 'TernaryFunction' is super-type of 'TernaryFunctionOpt',
// because any function passed to 'TernaryFunction' can also be used in
// 'TernaryFunctionOpt' (functions are contravariant on parameter type).
//
// As for the names go to: 'https://en.wikipedia.org/wiki/Arity'

extension PyBuiltinFunction {

  // MARK: - New

  internal static func wrapNew(
    _ context: PyContext,
    typeName: String,
    doc: String?,
    fn: @escaping NewFunction) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: NewFunctionWrapper(typeName: typeName, fn: fn)
    )
  }

  // MARK: - Init

  internal static func wrapInit<Zelf: PyObject>(
    _ context: PyContext,
    typeName: String,
    doc: String?,
    fn: @escaping InitFunction<Zelf>) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: InitFunctionWrapper(typeName: typeName, fn: fn)
    )
  }

  // MARK: - Args kwargs

  internal static func wrap<R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping ([PyObject], PyDictData?) -> R) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: ArgsKwargsFunctionWrapper(name: name) { [weak context] args, kwargs in
        guard let c = context else {
          fatalError("Trying to call '\(name)' after its context was deallocated.")
        }
        return fn(args, kwargs).toFunctionResult(in: c)
      }
    )
  }

  internal static func wrap<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> ([PyObject], PyDictData?) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: ArgsKwargsMethodWrapper(name: name) { arg0, args, kwargs in
        castSelf(arg0, name)
          .map { fn($0)(args, kwargs) }
          .toFunctionResult(in: arg0.context)
      }
    )
  }

  // MARK: - Positional nullary

  internal static func wrap<R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping () -> R) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: NullaryFunctionWrapper(name: name) { [weak context] in
        guard let c = context else {
          fatalError("Trying to call '\(name)' after its context was deallocated.")
        }
        return fn().toFunctionResult(in: c)
      }
    )
  }

  // MARK: - Positional unary

  internal static func wrap<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: UnaryFunctionWrapper(name: name) { arg0 in
        castSelf(arg0, name).map(fn).toFunctionResult(in: arg0.context)
      }
    )
  }

  internal static func wrap<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> () -> R, // Read-only property disquised as method
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: UnaryFunctionWrapper(name: name) { arg0 in
        castSelf(arg0, name).map { fn($0)() }.toFunctionResult(in: arg0.context)
      }
    )
  }

  // Overload without `self` argument.
  internal static func wrap<R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (PyObject) -> R) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: UnaryFunctionWrapper(name: name) { arg0 in
        fn(arg0).toFunctionResult(in: arg0.context)
      }
    )
  }

  // MARK: - Positional binary

  internal static func wrap<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: BinaryFunctionWrapper(name: name) { arg0, arg1 in
        castSelf(arg0, name)
          .map { fn($0)(arg1) }
          .toFunctionResult(in: arg0.context)
      }
    )
  }

  // Overload without `self` argument.
  internal static func wrap<R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (PyObject, PyObject) -> R) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: BinaryFunctionWrapper(name: name) { arg0, arg1 in
        fn(arg0, arg1).toFunctionResult(in: arg0.context)
      }
    )
  }

  // Special overload for binary method (self + args) with optionals.
  // See top of this file for reasoning.
  internal static func wrap<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject?) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: BinaryFunctionOptWrapper(name: name) { arg0, arg1 in
        castSelf(arg0, name)
          .map { fn($0)(arg1) }
          .toFunctionResult(in: arg0.context)
      }
    )
  }

  // MARK: - Positional ternary

  internal static func wrap<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject, PyObject) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: TernaryFunctionWrapper(name: name) { arg0, arg1, arg2 in
        castSelf(arg0, name)
          .map { fn($0)(arg1, arg2) }
          .toFunctionResult(in: arg0.context)
      }
    )
  }

  // Overload without `self` argument.
  internal static func wrap<R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (PyObject, PyObject, PyObject) -> R) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: TernaryFunctionWrapper(name: name) { arg0, arg1, arg2 in
        fn(arg0, arg1, arg2).toFunctionResult(in: arg0.context)
      }
    )
  }

  // Special overload for ternany method (self + 2 args) with optionals.
  // See top of this file for reasoning.
  internal static func wrap<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject, PyObject?) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: TernaryFunctionOptWrapper(name: name) { arg0, arg1, arg2 in
        castSelf(arg0, name)
          .map { fn($0)(arg1, arg2) }
          .toFunctionResult(in: arg0.context)
      }
    )
  }

  // Special overload for ternany method (self + 2 args) with optionals.
  // See top of this file for reasoning.
  internal static func wrap<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject?, PyObject?) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: TernaryFunctionOptOptWrapper(name: name) { arg0, arg1, arg2 in
        castSelf(arg0, name)
          .map { fn($0)(arg1, arg2) }
          .toFunctionResult(in: arg0.context)
      }
    )
  }

  // MARK: - Positional quartary

  internal static func wrap<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject, PyObject, PyObject) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: QuartaryFunctionWrapper(name: name) { arg0, arg1, arg2, arg3 in
        castSelf(arg0, name)
          .map { fn($0)(arg1, arg2, arg3) }
          .toFunctionResult(in: arg0.context)
      }
    )
  }

  // Special overload for quartary method (self + 3 args) with optionals.
  // See top of this file for reasoning.
  internal static func wrap<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject, PyObject, PyObject?) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: QuartaryFunctionOptWrapper(name: name) { arg0, arg1, arg2, arg3 in
        castSelf(arg0, name)
          .map { fn($0)(arg1, arg2, arg3) }
          .toFunctionResult(in: arg0.context)
      }
    )
  }

  // Special overload for quartary method (self + 3 args) with optionals.
  // See top of this file for reasoning.
  internal static func wrap<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject, PyObject?, PyObject?) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: QuartaryFunctionOptOptWrapper(name: name) { arg0, arg1, arg2, arg3 in
        castSelf(arg0, name)
          .map { fn($0)(arg1, arg2, arg3) }
          .toFunctionResult(in: arg0.context)
      }
    )
  }

  // Special overload for quartary method (self + 3 args) with optionals.
  // See top of this file for reasoning.
  internal static func wrap<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject?, PyObject?, PyObject?) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: QuartaryFunctionOptOptOptWrapper(name: name) { arg0, arg1, arg2, arg3 in
        castSelf(arg0, name)
          .map { fn($0)(arg1, arg2, arg3) }
          .toFunctionResult(in: arg0.context)
      }
    )
  }
}
