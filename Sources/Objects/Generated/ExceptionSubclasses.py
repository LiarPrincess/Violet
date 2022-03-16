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

        swift_type_name = 'Py' + python_type_name
        swift_base_type_name = 'Py' + python_base_type_name

        doc = t.doc.replace('\n', '\\n" +\n"')
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
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {{
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

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {{
    return zelf.type
  }}

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {{
    guard let zelf = Self.downcast(py, zelf) else {{
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }}

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }}

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {{
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.{py_memory_function_name}(
      py,
      type: type,
      args: argsTuple,
      traceback: nil,
      cause: nil,
      context: nil,
      suppressContext: PyErrorHeader.defaultSuppressContext
    )

    return PyResult(result)
  }}

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {{
    guard let zelf = Self.downcast(py, zelf) else {{
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }}

    let zelfAsObject = zelf.asObject
    return {swift_base_type_name}.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }}
}}
''')
