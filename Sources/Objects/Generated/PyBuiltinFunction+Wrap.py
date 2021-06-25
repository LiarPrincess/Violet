from Common.strings import generated_warning
from Function_wrappers_data.positional_functions import get_positional_signatures

if __name__ == '__main__':
    positional_functions = get_positional_signatures()

    print(f'''\
// swiftlint:disable identifier_name
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable file_length

{generated_warning}
''')

    print('extension PyBuiltinFunction {')
    print()

    for fn in positional_functions:
        fn_typealias_name = fn.fn_typealias_name
        generic_arguments = fn.generic_arguments
        generic_arguments_with_requirements = fn.generic_arguments_with_requirements

        cast_self_argument = ''
        cast_self_call_argument = ''
        if fn.has_self_argument:
            cast_self_argument = f',\n    castSelf: @escaping FunctionWrapper.CastSelf<Zelf>'
            cast_self_call_argument = ', castSelf: castSelf'

        print(f'''\
  internal static func wrap{generic_arguments_with_requirements}(
    name: String,
    doc: String?,
    fn: @escaping FunctionWrapper.{fn_typealias_name}{generic_arguments}{cast_self_argument},
    module: PyString? = nil
  ) -> PyBuiltinFunction {{
    let wrapper = FunctionWrapper(name: name, fn: fn{cast_self_call_argument})
    return PyBuiltinFunction(fn: wrapper, module: module, doc: doc)
  }}
''')

    print('}')  # extension end
