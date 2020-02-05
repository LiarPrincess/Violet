import Core

// swiftlint:disable file_length

// Why do we need so many overloads?
// For example for ternary methods (self + 2 args) we have:
// - TernaryFunction       = (PyObject, PyObject,  PyObject) -> PyFunctionResult
// - TernaryFunctionOpt    = (PyObject, PyObject,  PyObject?) -> PyFunctionResult
// - TernaryFunctionOptOpt = (PyObject, PyObject?, PyObject?) -> PyFunctionResult
//
// So:
// Some ternary (and also binary and quartary) methods can be called with
// smaller number of arguments (in other words: some arguments are optional).
// In the Swift side we represent this with optional arg.
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
// As for the names go to: https://en.wikipedia.org/wiki/Arity

extension PyBuiltinFunction {

  // MARK: - New

  internal static func wrapNew(
    type: PyType,
    doc: String?,
    fn: @escaping NewFunction,
    module: PyModule? = nil) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: NewFunctionWrapper(type: type, fn: fn),
      module: module,
      doc: doc
    )
  }

  // MARK: - Init

  internal static func wrapInit<Zelf: PyObject>(
    type: PyType,
    doc: String?,
    fn: @escaping InitFunction<Zelf>,
    module: PyModule? = nil) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: InitFunctionWrapper(type: type, fn: fn),
      module: module,
      doc: doc
    )
  }

  // MARK: - Args kwargs feunction

  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping ([PyObject], PyDictData?) -> R,
    module: PyModule? = nil) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: ArgsKwargsFunctionWrapper(name: name) { args, kwargs in
        fn(args, kwargs).asFunctionResult
      },
      module: module,
      doc: doc
    )
  }

  // MARK: - Args kwargs method

  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> ([PyObject], PyDictData?) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>,
    module: PyModule? = nil) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: ArgsKwargsMethodWrapper(name: name) { arg0, args, kwargs in
        castSelf(arg0, name)
          .map { fn($0)(args, kwargs) }
          .asFunctionResult
      },
      module: module,
      doc: doc
    )
  }

  // MARK: - Positional nullary

  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping () -> R,
    module: PyModule? = nil) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: NullaryFunctionWrapper(name: name) {
        fn().asFunctionResult
      },
      module: module,
      doc: doc
    )
  }

  // MARK: - Positional unary

  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>,
    module: PyModule? = nil) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: UnaryFunctionWrapper(name: name) { arg0 in
        castSelf(arg0, name).map(fn).asFunctionResult
      },
      module: module,
      doc: doc
    )
  }

  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> () -> R, // Read-only property disquised as method
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>,
    module: PyModule? = nil) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: UnaryFunctionWrapper(name: name) { arg0 in
        castSelf(arg0, name)
          .map { fn($0)() }
          .asFunctionResult
      },
      module: module,
      doc: doc
    )
  }

  // Overload without `self` argument.
  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (PyObject) -> R,
    module: PyModule? = nil) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: UnaryFunctionWrapper(name: name) { arg0 in
        fn(arg0).asFunctionResult
      },
      module: module,
      doc: doc
    )
  }

  // MARK: - Positional binary

  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>,
    module: PyModule? = nil) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: BinaryFunctionWrapper(name: name) { arg0, arg1 in
        castSelf(arg0, name)
          .map { fn($0)(arg1) }
          .asFunctionResult
      },
      module: module,
      doc: doc
    )
  }

  // Overload without `self` argument.
  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (PyObject, PyObject) -> R,
    module: PyModule? = nil) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: BinaryFunctionWrapper(name: name) { arg0, arg1 in
        fn(arg0, arg1).asFunctionResult
      },
      module: module,
      doc: doc
    )
  }

  // Special overload for binary method (self + args) with optionals.
  // See top of this file for reasoning.
  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject?) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>,
    module: PyModule? = nil) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: BinaryFunctionOptWrapper(name: name) { arg0, arg1 in
        castSelf(arg0, name)
          .map { fn($0)(arg1) }
          .asFunctionResult
      },
      module: module,
      doc: doc
    )
  }

  // MARK: - Positional ternary

  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject, PyObject) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>,
    module: PyModule? = nil) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: TernaryFunctionWrapper(name: name) { arg0, arg1, arg2 in
        castSelf(arg0, name)
          .map { fn($0)(arg1, arg2) }
          .asFunctionResult
      },
      module: module,
      doc: doc
    )
  }

  // Overload without `self` argument.
  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (PyObject, PyObject, PyObject) -> R,
    module: PyModule? = nil) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: TernaryFunctionWrapper(name: name) { arg0, arg1, arg2 in
        fn(arg0, arg1, arg2).asFunctionResult
      },
      module: module,
      doc: doc
    )
  }

  // Special overload for ternany method (self + 2 args) with optionals.
  // See top of this file for reasoning.
  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject, PyObject?) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>,
    module: PyModule? = nil) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: TernaryFunctionOptWrapper(name: name) { arg0, arg1, arg2 in
        castSelf(arg0, name)
          .map { fn($0)(arg1, arg2) }
          .asFunctionResult
      },
      module: module,
      doc: doc
    )
  }

  // Special overload for ternany method (self + 2 args) with optionals.
  // See top of this file for reasoning.
  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject?, PyObject?) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>,
    module: PyModule? = nil) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: TernaryFunctionOptOptWrapper(name: name) { arg0, arg1, arg2 in
        castSelf(arg0, name)
          .map { fn($0)(arg1, arg2) }
          .asFunctionResult
      },
      module: module,
      doc: doc
    )
  }

  // MARK: - Positional quartary

  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject, PyObject, PyObject) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>,
    module: PyModule? = nil) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: QuartaryFunctionWrapper(name: name) { arg0, arg1, arg2, arg3 in
        castSelf(arg0, name)
          .map { fn($0)(arg1, arg2, arg3) }
          .asFunctionResult
      },
      module: module,
      doc: doc
    )
  }

  // Special overload for quartary method (self + 3 args) with optionals.
  // See top of this file for reasoning.
  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject, PyObject, PyObject?) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>,
    module: PyModule? = nil) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: QuartaryFunctionOptWrapper(name: name) { arg0, arg1, arg2, arg3 in
        castSelf(arg0, name)
          .map { fn($0)(arg1, arg2, arg3) }
          .asFunctionResult
      },
      module: module,
      doc: doc
    )
  }

  // Special overload for quartary method (self + 3 args) with optionals.
  // See top of this file for reasoning.
  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject, PyObject?, PyObject?) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>,
    module: PyModule? = nil) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: QuartaryFunctionOptOptWrapper(name: name) { arg0, arg1, arg2, arg3 in
        castSelf(arg0, name)
          .map { fn($0)(arg1, arg2, arg3) }
          .asFunctionResult
      },
      module: module,
      doc: doc
    )
  }

  // Special overload for quartary method (self + 3 args) with optionals.
  // See top of this file for reasoning.
  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject?, PyObject?, PyObject?) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>,
    module: PyModule? = nil) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: QuartaryFunctionOptOptOptWrapper(name: name) { arg0, arg1, arg2, arg3 in
        castSelf(arg0, name)
          .map { fn($0)(arg1, arg2, arg3) }
          .asFunctionResult
      },
      module: module,
      doc: doc
    )
  }
}
