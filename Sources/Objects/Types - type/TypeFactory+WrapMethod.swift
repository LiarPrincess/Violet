import Core

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
// `wrapMethod`.
// Technically 'TernaryFunction' is super-type of 'TernaryFunctionOpt',
// because any function passed to 'TernaryFunction' can also be used in
// 'TernaryFunctionOpt' (functions are contravariant on parameter type).

extension TypeFactory {

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

  // MARK: - Unary

  internal static func wrapMethod<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> R,
    castSelf: @escaping (PyObject) -> Zelf) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: UnaryFunctionWrapper(name: name) { arg0 in
        fn(castSelf(arg0)).toFunctionResult(in: arg0.context)
      }
    )
  }

  internal static func wrapMethod<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> () -> R, // Read-only property disquised as method
    castSelf: @escaping (PyObject) -> Zelf) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: UnaryFunctionWrapper(name: name) { arg0 in
        fn(castSelf(arg0))().toFunctionResult(in: arg0.context)
      }
    )
  }

  // Overload without `self` argument.
  internal static func wrapMethod<R: FunctionResultConvertible>(
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

  // MARK: - Binary

  internal static func wrapMethod<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject) -> R,
    castSelf: @escaping (PyObject) -> Zelf) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: BinaryFunctionWrapper(name: name) { arg0, arg1 in
        fn(castSelf(arg0))(arg1).toFunctionResult(in: arg0.context)
      }
    )
  }

  // Overload without `self` argument.
  internal static func wrapMethod<R: FunctionResultConvertible>(
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
  internal static func wrapMethod<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject?) -> R,
    castSelf: @escaping (PyObject) -> Zelf) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: BinaryFunctionOptWrapper(name: name) { arg0, arg1 in
        fn(castSelf(arg0))(arg1).toFunctionResult(in: arg0.context)
      }
    )
  }

  // MARK: - Ternary

  internal static func wrapMethod<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject, PyObject) -> R,
    castSelf: @escaping (PyObject) -> Zelf) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: TernaryFunctionWrapper(name: name) { arg0, arg1, arg2 in
        fn(castSelf(arg0))(arg1, arg2).toFunctionResult(in: arg0.context)
      }
    )
  }

  // Overload without `self` argument.
  internal static func wrapMethod<R: FunctionResultConvertible>(
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
  internal static func wrapMethod<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject, PyObject?) -> R,
    castSelf: @escaping (PyObject) -> Zelf) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: TernaryFunctionOptWrapper(name: name) { arg0, arg1, arg2 in
        fn(castSelf(arg0))(arg1, arg2).toFunctionResult(in: arg0.context)
      }
    )
  }

  // Special overload for ternany method (self + 2 args) with optionals.
  // See top of this file for reasoning.
  internal static func wrapMethod<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject?, PyObject?) -> R,
    castSelf: @escaping (PyObject) -> Zelf) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: TernaryFunctionOptOptWrapper(name: name) { arg0, arg1, arg2 in
        fn(castSelf(arg0))(arg1, arg2).toFunctionResult(in: arg0.context)
      }
    )
  }

 // MARK: - Quartary

  internal static func wrapMethod<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject, PyObject, PyObject) -> R,
    castSelf: @escaping (PyObject) -> Zelf) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: QuartaryFunctionWrapper(name: name) { arg0, arg1, arg2, arg3 in
        fn(castSelf(arg0))(arg1, arg2, arg3).toFunctionResult(in: arg0.context)
      }
    )
  }

  // Special overload for quartary method (self + 3 args) with optionals.
  // See top of this file for reasoning.
  internal static func wrapMethod<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject, PyObject, PyObject?) -> R,
    castSelf: @escaping (PyObject) -> Zelf) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: QuartaryFunctionOptWrapper(name: name) { arg0, arg1, arg2, arg3 in
        fn(castSelf(arg0))(arg1, arg2, arg3).toFunctionResult(in: arg0.context)
      }
    )
  }

  // Special overload for quartary method (self + 3 args) with optionals.
  // See top of this file for reasoning.
  internal static func wrapMethod<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject, PyObject?, PyObject?) -> R,
    castSelf: @escaping (PyObject) -> Zelf) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: QuartaryFunctionOptOptWrapper(name: name) { arg0, arg1, arg2, arg3 in
        fn(castSelf(arg0))(arg1, arg2, arg3).toFunctionResult(in: arg0.context)
      }
    )
  }

  // Special overload for quartary method (self + 3 args) with optionals.
  // See top of this file for reasoning.
  internal static func wrapMethod<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject?, PyObject?, PyObject?) -> R,
    castSelf: @escaping (PyObject) -> Zelf) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      doc: doc,
      fn: QuartaryFunctionOptOptOptWrapper(name: name) { arg0, arg1, arg2, arg3 in
        fn(castSelf(arg0))(arg1, arg2, arg3).toFunctionResult(in: arg0.context)
      }
    )
  }
}
