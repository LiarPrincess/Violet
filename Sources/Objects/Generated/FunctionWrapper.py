from Common.strings import generated_warning
from Function_wrappers_data.positional_functions import\
    get_positional_signatures, void_argument, void_return, result_return

from Function_wrappers_data.hand_written_functions import get_hand_written_functions


def print_mark(name: str):
    print('  // MARK: - ' + name)
    print()


if __name__ == '__main__':
    positional_functions = get_positional_signatures()
    hand_written_functions = get_hand_written_functions()

    print(f'''\
// swiftlint:disable type_name
// swiftlint:disable identifier_name
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable file_length

{generated_warning}

// Why do we need so many different signatures?
//
// For example for ternary methods (self + 2 args) we have:
// - (PyObject, PyObject,  PyObject) -> PyFunctionResult
// - (PyObject, PyObject,  PyObject?) -> PyFunctionResult
// - (PyObject, PyObject?, PyObject?) -> PyFunctionResult
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
// And of course, there are also different return types to handle…
//
// It is also a nice test to see if Swift can properly bind correct overload of `wrap`.
// Technically 'TernaryFunction' is super-type of 'TernaryFunctionOpt',
// because any function passed to 'TernaryFunction' can also be used in
// 'TernaryFunctionOpt' (functions are contravariant on parameter type).
//
// As for the names go to: https://en.wikipedia.org/wiki/Arity

/// Represents Swift function callable from Python context.
internal struct FunctionWrapper {{
''')

    # ============
    # === Kind ===
    # ============

    print_mark('Kind')
    print('  // Each kind holds a \'struct\' with similar name in its payload.')
    print('  internal enum Kind {')

    for fn in hand_written_functions:
        print(f'  /// {fn.doc}')
        print(f'  case {fn.enum_case_name}({fn.struct_name})')

    for fn in positional_functions:
        print(f'  /// `{fn.human_readable_signature}`')
        print(f'  case {fn.enum_case_name}({fn.struct_name})')

    print('  }')
    print()

    # =================
    # === Cast self ===
    # =================

    print_mark('Cast self')
    print('''\
  /// Cast given object to a specific type, 1st argument is a function name.
  internal typealias CastSelf<Zelf> = (String, PyObject) -> PyResult<Zelf>
  /// Cast given object to a specific type.
  internal typealias CastSelfOptional<Zelf> = (PyObject) -> Zelf?
''')

    # ==================
    # === Properties ===
    # ==================

    print_mark('Properties')
    print('  internal let kind: Kind')
    print()

    # ============
    # === Name ===
    # ============

    print_mark('Name')
    print('  /// The name of the built-in function/method.')
    print('  internal var name: String {')
    print('    // Just delegate to specific wrapper.')
    print('    switch self.kind {')

    for fn in hand_written_functions:
        print(f'    case let .{fn.enum_case_name}(w): return w.fnName')

    for fn in positional_functions:
        print(f'    case let .{fn.enum_case_name}(w): return w.fnName')

    print('    }')
    print('  }')
    print()

    # ============
    # === Call ===
    # ============

    print_mark('Call')
    print('  /// Call the stored function with provided arguments.')
    print('  internal func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {')
    print('    // Just delegate to specific wrapper.')
    print('    switch self.kind {')

    for fn in hand_written_functions:
        print(f'    case let .{fn.enum_case_name}(w): return w.call(args: args, kwargs: kwargs)')

    for fn in positional_functions:
        print(f'    case let .{fn.enum_case_name}(w): return w.call(args: args, kwargs: kwargs)')

    print('    }')
    print('  }')
    print()

    # ================
    # === Wrappers ===
    # ================

    for fn in positional_functions:
        enum_case_name = fn.enum_case_name
        struct_name = fn.struct_name
        fn_typealias_name = fn.fn_typealias_name
        human_readable_signature = fn.human_readable_signature
        generic_arguments = fn.generic_arguments
        generic_arguments_with_requirements = fn.generic_arguments_with_requirements
        generic_signature = fn.generic_signature
        has_self_argument = fn.has_self_argument
        return_type = fn.return_type

        print_mark(human_readable_signature)

        # Function typealias
        print(f'''\
  /// {fn.doc}
  ///
  /// `{human_readable_signature}`
  internal typealias {fn_typealias_name}{generic_arguments_with_requirements} = {generic_signature}
''')

        # Struct
        print(f'''\
  internal struct {struct_name} {{
    fileprivate let fnName: String
    private let fn: {fn.stored_in_struct_signature}
''')

        # Struct - init
        cast_self_argument = ''
        if has_self_argument:
            cast_self_argument = ',\n      castSelf: @escaping CastSelf<Zelf>'

        total_arg_index = 0
        fn_argument_binding = '('
        for arg_group in fn.arguments:
            for arg in arg_group:
                arg_type = arg.swift_type_stored_in_struct

                # If we do not store this argument in 'self.fn' -> no binding
                if not arg_type:
                    continue

                if total_arg_index > 0:
                    fn_argument_binding += ', '

                binding_name = 'arg' + str(total_arg_index)
                fn_argument_binding += binding_name + ': ' + arg_type
                total_arg_index += 1

        fn_argument_binding += ')'

        print(f'''\
    fileprivate init{generic_arguments_with_requirements}(
      name: String,
      fn: @escaping {fn_typealias_name}{generic_arguments}{cast_self_argument}
    ) {{
        self.fnName = name
        self.fn = {{ {fn_argument_binding} -> PyFunctionResult in\
''')

        if has_self_argument:
            print(f'''\
          // This function has a 'self' argument that we have to cast
          let zelf: Zelf
          switch castSelf(name, arg0) {{
          case let .value(z): zelf = z
          case let .error(e): return .error(e)
          }}
''')

        print(f"          // This function returns '{return_type.swift_type}'")

        total_arg_index = 0
        fn_call_arguments = ''
        for arg_group in fn.arguments:
            fn_call_arguments += '('
            for arg_index, arg in enumerate(arg_group):
                if arg_index > 0:
                    fn_call_arguments += ', '

                binding = 'arg' + str(total_arg_index)
                if total_arg_index == 0 and has_self_argument:
                    binding = 'zelf'
                if arg == void_argument:
                    binding = ''

                fn_call_arguments += binding
                total_arg_index += 1
            fn_call_arguments += ')'

        if return_type == void_return:
            print(f'''\
          fn{fn_call_arguments}
          return .value(Py.none)\
''')
        elif return_type == result_return:
            print(f'''\
          let result = fn{fn_call_arguments}
          return result.asFunctionResult\
''')
        else:
            raise ValueError(f"Unknown return type '{return_type.swift_type}'")

        print(f'''\
        }}
    }}
''')

        # Struct - call
        stored_in_struct_min_arg_count = fn.stored_in_struct_min_arg_count
        stored_in_struct_max_arg_count = fn.stored_in_struct_max_arg_count

        cases = ''
        for case_index in range(stored_in_struct_min_arg_count, stored_in_struct_max_arg_count + 1):
            fn_call_arguments = ''
            for arg_index in range(stored_in_struct_max_arg_count):
                if fn_call_arguments:
                    fn_call_arguments += ', '

                argument_value = f'args[{arg_index}]' if arg_index < case_index else 'nil'
                fn_call_arguments += argument_value

            cases += f'      case {case_index}:\n'
            cases += f'        return self.fn({fn_call_arguments})\n'
        cases = cases.rstrip()  # Remove last new line

        error_message = f'expected {stored_in_struct_max_arg_count} arguments, got \(args.count)'
        if stored_in_struct_max_arg_count == 0:
            error_message = "'\(self.fnName)' takes no arguments (\(args.count) given)"
        if stored_in_struct_max_arg_count == 1:
            error_message = "'\(self.fnName)' takes exactly one argument (\(args.count) given)"

        print(f'''\
    fileprivate func call(args: [PyObject], kwargs: PyDict?) -> PyFunctionResult {{
      // This function has only positional arguments, so any kwargs -> error
      if let e = ArgumentParser.noKwargsOrError(fnName: self.fnName, kwargs: kwargs) {{
        return .error(e)
      }}

      // 'self.fn' call will jump to 'self.fn' assignment inside 'init'
      switch args.count {{
{cases}
      default:
        return .typeError("{error_message}")
      }}
    }}\
''')

        # Struct - end
        print('  }')
        print()

        # FunctionWrapper - init
        cast_self_call_argument = ''
        if has_self_argument:
            cast_self_call_argument = ', castSelf: castSelf'

        # Decrease indent
        cast_self_argument = cast_self_argument.replace('      ', '    ')

        print(f'''\
  internal init{generic_arguments_with_requirements}(
    name: String,
    fn: @escaping {fn_typealias_name}{generic_arguments}{cast_self_argument}
  ) {{
    let wrapper = {struct_name}(name: name, fn: fn{cast_self_call_argument})
    self.kind = .{enum_case_name}(wrapper)
  }}
''')

    # 'struct FunctionWrapper' end
    print('}')
