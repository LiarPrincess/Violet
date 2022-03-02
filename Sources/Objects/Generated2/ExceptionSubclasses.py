from Helpers import generated_warning, where_to_find_errors_in_cpython, exception_hierarchy

# Some exceptions will be implemented by hand.
MANUALLY_IMPLEMENTED = [
    'BaseException',
    'KeyError',  # Custom '__str__' method
    'StopIteration',  # 'value' property
    'SystemExit',  # 'code' property
    'ImportError',  # tons of customization (msg, name, path)
    'SyntaxError',  # another ton of customization (msg, filename, lineno, offset, text, print_file_and_line)
]

if __name__ == '__main__':
    print(f'''\
{generated_warning(__file__)}

// swiftlint:disable line_length
// swiftlint:disable trailing_newline
// swiftlint:disable function_parameter_count
// swiftlint:disable file_length

{where_to_find_errors_in_cpython}
''')

    for t in exception_hierarchy:
        python_type_name = t.type_name
        python_base_type_name = t.base_type_name

        if python_type_name in MANUALLY_IMPLEMENTED:
            continue

        doc = t.doc.replace('\n', '\\n" +\n"')
        swift_type_name = 'Py' + python_type_name
        py_memory_function_name = 'new' + python_type_name

        print(f'''\
// MARK: - {python_type_name}

// sourcery: pyerrortype = {python_type_name}, pybase = {python_base_type_name}, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct {swift_type_name}: PyErrorMixin {{

  // sourcery: pytypedoc
  internal static let doc = "{doc}"

  public let ptr: RawPtr

  public init(ptr: RawPtr) {{
    self.ptr = ptr
  }}

  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback?,
                           cause: PyBaseException?,
                           context: PyBaseException?,
                           suppressContext: Bool) {{
    self.errorHeader.initialize(py,
                                type: type,
                                args: args,
                                traceback: traceback,
                                cause: cause,
                                context: context,
                                suppressContext: suppressContext)
  }}

  // Nothing to do here.
  internal func beforeDeinitialize() {{ }}

  internal static func createDebugString(ptr: RawPtr) -> String {{
    let zelf = PyStopIteration(ptr: ptr)
    return "{swift_type_name}(type: \(zelf.typeName), flags: \(zelf.flags))"
  }}

/* MARKER
  // sourcery: pyproperty = __class__
  internal static func getClass(_ py: Py, object: PyObject) -> PyType {{
    return object.type
  }}

  // sourcery: pyproperty = __dict__
  internal static func getDict(_ py: Py, object: PyObject) -> PyDict {{
    return object.__dict__
  }}

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(_ py: Py,
                             type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<{swift_type_name}> {{
    let argsTuple = Py.newTuple(elements: args)
    let result = py.memory.{py_memory_function_name}(type: type, args: argsTuple)
    return .value(result)
  }}

  // sourcery: pymethod = __init__
  internal func pyInit(
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyNone> {{
    return self.py{python_base_type_name}Init(args: args, kwargs: kwargs)
  }}
*/
}}
''')
