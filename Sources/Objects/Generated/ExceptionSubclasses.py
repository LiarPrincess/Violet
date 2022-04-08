from typing import Dict, List, Optional
from Sourcery import ExceptionByHand, get_error_types_implemented_by_hand
from Helpers import generated_warning, where_to_find_errors_in_cpython, exception_hierarchy

class ErrorInfo:
    def __init__(self,
                type_name: str,
                base_info: Optional[object], # Optional[ErrorInfo]
                implementation_by_hand: Optional[ExceptionByHand],
                doc: str):
        self.type_name = type_name
        self.base_info = base_info
        self.implementation_by_hand = implementation_by_hand
        self.doc = doc

def get_error_types() -> List[ErrorInfo]:
    result = []
    name_to_info: Dict[str: ErrorInfo] = {}

    exceptions_by_hand = get_error_types_implemented_by_hand()
    for e in exception_hierarchy:
        name = e.type_name
        base_name = e.base_type_name

        # Errors in 'exception_hierarchy' are sorted: base -> subclasses
        if base_name == 'Object':
            base_info = None
        else:
            base_info = name_to_info[base_name]

        by_hand: Optional[ExceptionByHand] = None
        for h in exceptions_by_hand:
            if h.python_type_name == name:
                by_hand = h
                break

        info = ErrorInfo(name, base_info, by_hand, e.doc)
        result.append(info)
        name_to_info[name] = info

    return result

if __name__ == '__main__':
    print(f'''\
{generated_warning(__file__)}

// swiftlint:disable line_length
// swiftlint:disable trailing_newline
// swiftlint:disable function_parameter_count
// swiftlint:disable file_length

{where_to_find_errors_in_cpython}\
''')

    for t in get_error_types():
        is_implemented_by_hand = t.implementation_by_hand is not None
        if is_implemented_by_hand:
            continue

        python_type_name = t.type_name
        python_base_type_name = t.base_info.type_name

        swift_type_name = 'Py' + python_type_name
        swift_base_type_name = 'Py' + python_base_type_name

        doc = t.doc.replace('\n', '\\n" +\n"')
        py_memory_function_name = 'new' + python_type_name

        # ==============
        # === Header ===
        # ==============

        print(f'''
// MARK: - {python_type_name}

// sourcery: pyerrortype = {python_type_name}, pybase = {python_base_type_name}, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct {swift_type_name}: PyErrorMixin {{

  // sourcery: pytypedoc
  internal static let doc = "{doc}"

  public let ptr: RawPtr

  public init(ptr: RawPtr) {{
    self.ptr = ptr
  }}\
''')

        # ==================
        # === Initialize ===
        # ==================

        # We have to copy the base class initializers 1:1.

        base_with_initializers = t
        while True:
            if base_with_initializers.implementation_by_hand is not None:
                break

            base_with_initializers = base_with_initializers.base_info

        swift_initializers = base_with_initializers.implementation_by_hand.swift_initializers
        for fn in swift_initializers:
            print()
            print(f'  internal func initialize(')

            arguments: List[str] = []
            call_arguments: List[str] = []
            for arg in fn.arguments:
                label = '' if arg.label is None else arg.label + ' '
                default = '' if arg.default_value is None else ' = ' + arg.default_value
                arguments.append(f'{label}{arg.name}: {arg.typ}{default}')

                if arg.label == '_':
                    call_label = ''
                elif arg.label:
                    call_label = arg.label + ': '
                else:
                    call_label = arg.name + ': '

                call_arguments.append(f'{call_label}{arg.name}')

            for index, arg in enumerate(arguments):
                is_last = index == len(arguments) - 1
                comma = '' if is_last else ','
                print(f'    {arg}{comma}')

            print(f'  ) {{')
            print(f'    self.initializeBase(', end='')
            for index, arg in enumerate(call_arguments):
                is_first = index == 0
                is_last = index == len(call_arguments) - 1

                indent = '' if is_first else (24 * ' ')
                end = ')\n' if is_last else ',\n'
                print(f'{indent}{arg}', end=end)

            print(f'  }}')

        # ====================
        # === Deinitialize ===
        # ====================

        print()
        print('  // Nothing to do here.')
        print('  internal func beforeDeinitialize(_ py: Py) { }')

        # =============
        # === Debug ===
        # =============

        print()
        print(f'  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {{')
        print(f'    let zelf = {swift_type_name}(ptr: ptr)')
        print(f'    var result = PyObject.DebugMirror(object: zelf)')
        print(f'    PyBaseException.fillDebug(zelf: zelf.asBaseException, debug: &result)')
        print(f'    return result')
        print(f'  }}')

        # ===============
        # === Methods ===
        # ===============

        print(f'''
  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {{
    return zelf.type
  }}

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf _zelf: PyObject) -> PyResult {{
    guard let zelf = Self.downcast(py, _zelf) else {{
      return Self.invalidZelfArgument(py, _zelf, "__dict__")
    }}

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }}

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {{
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.{py_memory_function_name}(type: type, args: argsTuple)
    return PyResult(result)
  }}

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf _zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult {{
    guard let zelf = Self.downcast(py, _zelf) else {{
      return Self.invalidZelfArgument(py, _zelf, "__init__")
    }}

    let zelfAsObject = zelf.asObject
    return {swift_base_type_name}.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }}
}}\
''')

    print()
