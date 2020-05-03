import VioletCore

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

  // MARK: - Init

  internal static func wrapInit<Zelf: PyObject>(
    type: PyType,
    doc: String?,
    fn: @escaping InitFunction<Zelf>,
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: InitFunctionWrapper(type: type, fn: fn),
      module: module,
      doc: doc
    )
  }

  internal static func wrapInit<Zelf: PyObject>(
    type: PyType,
    doc: String?,
    fn: @escaping (Zelf, [PyObject], PyDict?) -> PyResult<PyNone>,
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return Self.wrapInit(
      type: type,
      doc: doc,
      fn: Self.toInitSignature(fn: fn),
      module: module
    )
  }

  private static func toInitSignature<Zelf: PyObject>(
    fn: @escaping (Zelf, [PyObject], PyDict?) -> PyResult<PyNone>
  ) -> InitFunction<Zelf> {
    return { (zelf: Zelf) in { (args: [PyObject], kwargs: PyDict?) in
        fn(zelf, args, kwargs)
      }
    }
  }

  // MARK: - Args kwargs function

  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping ([PyObject], PyDict?) -> R,
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: ArgsKwargsFunctionWrapper(name: name) { args, kwargs in
        let result = fn(args, kwargs)
        return result.asFunctionResult
      },
      module: module,
      doc: doc
    )
  }

  // MARK: - Args kwargs method

  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> ([PyObject], PyDict?) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>,
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: ArgsKwargsMethodWrapper(name: name) { arg0, args, kwargs in
        let zelf = castSelf(arg0, name)
        let result = zelf.map { fn($0)(args, kwargs) }
        return result.asFunctionResult
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
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: NullaryFunctionWrapper(name: name) {
        let result = fn()
        return result.asFunctionResult
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
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: UnaryFunctionWrapper(name: name) { arg0 in
        let zelf = castSelf(arg0, name)
        let result = zelf.map(fn)
        return result.asFunctionResult
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
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: UnaryFunctionWrapper(name: name) { arg0 in
        let zelf = castSelf(arg0, name)
        let result = zelf.map { fn($0)() }
        return result.asFunctionResult
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
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: UnaryFunctionWrapper(name: name) { arg0 in
        let result = fn(arg0)
        return result.asFunctionResult
      },
      module: module,
      doc: doc
    )
  }

  // Overload without `self` argument.
  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (PyObject?) -> R,
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: UnaryFunctionOptWrapper(name: name) { arg0 in
        let result = fn(arg0)
        return result.asFunctionResult
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
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: BinaryFunctionWrapper(name: name) { arg0, arg1 in
        let zelf = castSelf(arg0, name)
        let result = zelf.map { fn($0)(arg1) }
        return result.asFunctionResult
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
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: BinaryFunctionWrapper(name: name) { arg0, arg1 in
        let result = fn(arg0, arg1)
        return result.asFunctionResult
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
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: BinaryFunctionOptWrapper(name: name) { arg0, arg1 in
        let zelf = castSelf(arg0, name)
        let result = zelf.map { fn($0)(arg1) }
        return result.asFunctionResult
      },
      module: module,
      doc: doc
    )
  }

  // Overload without `self` argument.
  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (PyObject, PyObject?) -> R,
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: BinaryFunctionOptWrapper(name: name) { arg0, arg1 in
        let result = fn(arg0, arg1)
        return result.asFunctionResult
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
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: TernaryFunctionWrapper(name: name) { arg0, arg1, arg2 in
        let zelf = castSelf(arg0, name)
        let result = zelf.map { fn($0)(arg1, arg2) }
        return result.asFunctionResult
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
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: TernaryFunctionWrapper(name: name) { arg0, arg1, arg2 in
        let result = fn(arg0, arg1, arg2)
        return result.asFunctionResult
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
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: TernaryFunctionOptWrapper(name: name) { arg0, arg1, arg2 in
        let zelf = castSelf(arg0, name)
        let result = zelf.map { fn($0)(arg1, arg2) }
        return result.asFunctionResult
      },
      module: module,
      doc: doc
    )
  }

  // Overload without `self` argument.
  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (PyObject, PyObject, PyObject?) -> R,
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: TernaryFunctionOptWrapper(name: name) { arg0, arg1, arg2 in
        let result = fn(arg0, arg1, arg2)
        return result.asFunctionResult
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
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: TernaryFunctionOptOptWrapper(name: name) { arg0, arg1, arg2 in
        let zelf = castSelf(arg0, name)
        let result = zelf.map { fn($0)(arg1, arg2) }
        return result.asFunctionResult
      },
      module: module,
      doc: doc
    )
  }

  // Overload without `self` argument.
  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (PyObject, PyObject?, PyObject?) -> R,
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: TernaryFunctionOptOptWrapper(name: name) { arg0, arg1, arg2 in
        let result = fn(arg0, arg1, arg2)
        return result.asFunctionResult
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
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: QuartaryFunctionWrapper(name: name) { arg0, arg1, arg2, arg3 in
        let zelf = castSelf(arg0, name)
        let result = zelf.map { fn($0)(arg1, arg2, arg3) }
        return result.asFunctionResult
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
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: QuartaryFunctionOptWrapper(name: name) { arg0, arg1, arg2, arg3 in
        let zelf = castSelf(arg0, name)
        let result = zelf.map { fn($0)(arg1, arg2, arg3) }
        return result.asFunctionResult
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
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: QuartaryFunctionOptOptWrapper(name: name) { arg0, arg1, arg2, arg3 in
        let zelf = castSelf(arg0, name)
        let result = zelf.map { fn($0)(arg1, arg2, arg3) }
        return result.asFunctionResult
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
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: QuartaryFunctionOptOptOptWrapper(name: name) { arg0, arg1, arg2, arg3 in
        let zelf = castSelf(arg0, name)
        let result = zelf.map { fn($0)(arg1, arg2, arg3) }
        return result.asFunctionResult
      },
      module: module,
      doc: doc
    )
  }
}
