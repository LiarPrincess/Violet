from typing import List
from Helpers import (
    generated_warning,
    get_positional_function_wrappers,
    get_hand_written_function_wrappers,
    escape_swift_keyword as escape
)

def print_mark(name: str):
    print()
    print('  // MARK: - ' + name)
    print()

if __name__ == '__main__':
    print(f'''\
{generated_warning(__file__)}

// swiftlint:disable type_name
// swiftlint:disable identifier_name
// swiftlint:disable line_length
// swiftlint:disable file_length

/// Wraps a Swift function callable from Python context.
///
/// Why do we need so many different signatures?
///
/// For example for ternary methods (self + 2 args) we have:
/// - (PyObject, PyObject,  PyObject) -> PyResult
/// - (PyObject, PyObject,  PyObject?) -> PyResult
/// - (PyObject, PyObject?, PyObject?) -> PyResult
///
/// So:
/// Some ternary (and also binary and quartary) methods can be called with
/// smaller number of arguments (in other words: some arguments are optional).
/// On the Swift side we represent this with optional arg.
///
/// For example:
/// `PyString.strip(zelf: PyObject, chars: PyObject?) -> String` has an required
/// `zelf` argument and an single optional `chars` argument.
/// When called with 1 argument we will call: `zelf: arg0, chars: nil`.
/// When called with 2 arguments we will call: `zelf: arg0, chars: arg1`.
/// When called with more than 2 arguments we will return an error (hopefully).
///
/// And of course, there are also different return types to handle…
///
/// It is also a nice test to see if Swift can properly bind correct overload of `wrap`.
/// Technically 'TernaryFunction' is super-type of 'TernaryFunction with optional',
/// because any function passed to 'TernaryFunction' can also be used in
/// 'TernaryFunction with optional' (functions are contravariant on parameter type).
public struct FunctionWrapper: CustomStringConvertible {{\
''')

    hand_written_functions = get_hand_written_function_wrappers()
    positional_functions = get_positional_function_wrappers()

    # ============
    # === Kind ===
    # ============

    print_mark('Kind')
    print('  // Each kind holds a \'struct\' with similar name in its payload.')
    print('  internal enum Kind {')

    for fn in hand_written_functions:
        print(f'  /// {fn.doc}')
        print(f'  case {escape(fn.name_enum_case)}({fn.name_struct})')

    for fn in positional_functions:
        print(f'  /// `{fn.signature}`')
        print(f'  case {escape(fn.name_enum_case)}({fn.name_struct})')

    print('  }')

    # ==================
    # === Properties ===
    # ==================

    print_mark('Properties')
    print('  internal let kind: Kind')

    # ============
    # === Name ===
    # ============

    print_mark('Name')
    print('  /// The name of the built-in function/method.')
    print('  public var name: String {')
    print('    // Just delegate to specific wrapper.')
    print('    switch self.kind {')

    for fn in hand_written_functions:
        print(f'    case let .{escape(fn.name_enum_case)}(w): return w.fnName')

    for fn in positional_functions:
        print(f'    case let .{escape(fn.name_enum_case)}(w): return w.fnName')

    print('    }')
    print('  }')

    # ============
    # === Call ===
    # ============

    print_mark('Call')
    print('  /// Call the stored function with provided arguments.')
    print('  public func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult {')
    print('    // Just delegate to specific wrapper.')
    print('    switch self.kind {')

    for fn in hand_written_functions:
        print(f'    case let .{escape(fn.name_enum_case)}(w): return w.call(py, args: args, kwargs: kwargs)')

    for fn in positional_functions:
        print(f'    case let .{escape(fn.name_enum_case)}(w): return w.call(py, args: args, kwargs: kwargs)')

    print('    }')
    print('  }')

    # ===================
    # === Description ===
    # ===================

    print_mark('Description')
    print('  public var description: String {')
    print('    let name = self.name')
    print('    let fn = self.describeKind()')
    print('    return "FunctionWrapper(name: \(name), fn: \(fn))"')
    print('  }')
    print()

    print('  private func describeKind() -> String {')
    print('    switch self.kind {')

    for fn in hand_written_functions:
        print(f'    case .{escape(fn.name_enum_case)}: return "{fn.swift_description}"')

    for fn in positional_functions:
        print(f'    case .{escape(fn.name_enum_case)}: return "{fn.signature}"')

    print('    }')
    print('  }')
    print()

    # ==========================
    # === Wrappers - helpers ===
    # ==========================


    print('  internal static func handleTypeArgument(_ py: Py,')
    print('                                          fnName: String,')
    print('                                          args: [PyObject]) -> PyResultGen<PyType> {')
    print('    if args.isEmpty {')
    print('      let error = py.newTypeError(message: "\(fnName)(): not enough arguments")')
    print('      return .error(error.asBaseException)')
    print('    }')
    print()
    print('    let arg0 = args[0]')
    print('    guard let type = py.cast.asType(arg0) else {')
    print('      let error = py.newTypeError(message: "\(fnName)(X): X is not a type object (\(arg0.typeName))")')
    print('      return .error(error.asBaseException)')
    print('    }')
    print()
    print('    return .value(type)')
    print('  }')

    # ================
    # === Wrappers ===
    # ================

    for fn in positional_functions:
        struct_name = fn.name_struct
        name_fn_typealias = fn.name_fn_typealias
        signature = fn.signature

        print_mark(signature)

        # === Function typealias ===
        print(f'  /// {fn.doc}')
        print(f'  ///')
        print(f'  /// `{signature}`')
        print(f'  public typealias {name_fn_typealias} = {signature}')
        print()

        # === Struct ===
        print(f'  internal struct {struct_name} {{')
        print(f'    private let fn: {name_fn_typealias}')
        print(f'    fileprivate let fnName: String')
        print()

        print(f'    fileprivate init(name: String, fn: @escaping {name_fn_typealias}) {{')
        print(f'      self.fnName = name')
        print(f'      self.fn = fn')
        print(f'    }}')
        print()

        print(f'    fileprivate func call(_ py: Py, args: [PyObject], kwargs: PyDict?) -> PyResult {{')
        print(f'      // This function has only positional arguments, so any kwargs -> error')
        print(f'      if let e = ArgumentParser.noKwargsOrError(py, fnName: self.fnName, kwargs: kwargs) {{')
        print(f'        return .error(e.asBaseException)')
        print(f'      }}')
        print()

        if fn.has_type_as_1_argument:
            print('      // This function has a \'type\' argument that we have to cast')
            print('      let type: PyType')
            print('      switch FunctionWrapper.handleTypeArgument(py, fnName: self.fnName, args: args) {')
            print('      case let .value(t): type = t')
            print('      case let .error(e): return .error(e)')
            print('      }')
            print()

        print(f'      switch args.count {{')

        min_arg_count = fn.min_arg_count
        max_arg_count = fn.max_arg_count

        for case_index in range(min_arg_count, max_arg_count + 1):
            arguments: List[str] = []
            for arg_index in range(max_arg_count):
                arg = f'args[{arg_index}]' if arg_index < case_index else 'nil'
                arguments.append(arg)

            if fn.has_type_as_1_argument:
                arguments[0] = 'type'

            fn_call_arguments = '' if not arguments else ', ' + ', '.join(arguments)
            print(f'      case {case_index}:')
            print(f'        return self.fn(py{fn_call_arguments})')

        # === Default case ===
        error_message = f'expected {max_arg_count} arguments, got \(args.count)'
        if max_arg_count == 0:
            error_message = "'\(self.fnName)' takes no arguments (\(args.count) given)"
        if max_arg_count == 1:
            error_message = "'\(self.fnName)' takes exactly one argument (\(args.count) given)"

        print(f'      default:')
        print(f'        return .typeError(py, message: "{error_message}")')
        print(f'      }}')

        # Struct - end
        print('    }')
        print('  }')
        print()

        print(f'  public init(name: String, fn: @escaping {name_fn_typealias} ) {{')
        print(f'    let wrapper = {struct_name}(name: name, fn: fn)')
        print(f'    self.kind = .{fn.name_enum_case}(wrapper)')
        print(f'  }}')

    # 'struct FunctionWrapper' end
    print('}')
