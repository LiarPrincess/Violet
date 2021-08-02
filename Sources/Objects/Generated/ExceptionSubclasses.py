from Exception_hierarchy import data
from Common.strings import generated_warning, where_to_find_errors_in_cpython
from Builtin_types import get_property_name_escaped as get_builtin_type_property_name

# Some exceptions will be implemented by hand.
MANUALLY_IMPLEMENTED = [
    'BaseException',
    'KeyError',  # Custom '__str__' method
    'StopIteration',  # 'value' property
    'SystemExit',  # 'code' property
    'ImportError',  # tons of customization (msg, name, path)
    'SyntaxError',  # another ton of customization (msg, filename, lineno, offset, text, print_file_and_line)
]


def is_final(name):
    'If there exists any exception with us as base then we are not final'

    for e in data:
        if e.base_class == name:
            return False

    return True


if __name__ == '__main__':
    print(f'''\
{generated_warning(__file__)}

// swiftlint:disable line_length
// swiftlint:disable trailing_newline
// swiftlint:disable file_length

{where_to_find_errors_in_cpython}
''')

    for t in data:
        python_type_name = t.class_name
        python_base_type_name = t.base_class
        doc = t.doc

        if python_type_name in MANUALLY_IMPLEMENTED:
            continue

        swift_class_name = 'Py' + python_type_name
        swift_base_class_name = 'Py' + python_base_type_name
        python_type_name_camel_case = python_type_name[0].lower() + python_type_name[1:]

        doc = doc.replace('\n', '\\n" +\n"')
        final = 'final ' if is_final(python_type_name) else ''
        builtins_type_variable = get_builtin_type_property_name(python_type_name)
        py_memory_function_name = 'new' + python_type_name

        print(f'''\
// MARK: - {python_type_name}

// sourcery: pyerrortype = {python_type_name}, default, baseType, hasGC
// sourcery: baseExceptionSubclass, instancesHave__dict__
public {final}class {swift_class_name}: {swift_base_class_name} {{

  // sourcery: pytypedoc
  internal static let {python_type_name_camel_case}Doc = "{doc}"

  /// Type to set in `init`.
  override internal class var pythonTypeToSetInInit: PyType {{
    return Py.errorTypes.{builtins_type_variable}
  }}

  // sourcery: pyproperty = __class__
  internal static func getClass({python_type_name_camel_case}: {swift_class_name}) -> PyType {{
    return {python_type_name_camel_case}.type
  }}

  // sourcery: pyproperty = __dict__
  internal static func getDict({python_type_name_camel_case}: {swift_class_name}) -> PyDict {{
    return {python_type_name_camel_case}.__dict__
  }}

  // sourcery: pystaticmethod = __new__
  internal static func py{python_type_name}New(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<{swift_class_name}> {{
    let argsTuple = Py.newTuple(elements: args)
    let result = PyMemory.{py_memory_function_name}(type: type, args: argsTuple)
    return .value(result)
  }}

  // sourcery: pymethod = __init__
  internal func py{python_type_name}Init(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {{
    return self.py{python_base_type_name}Init(args: args, kwargs: kwargs)
  }}
}}
''')
