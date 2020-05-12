from Data.errors import data
from Common.strings import generated_warning
from Common.errors import where_to_find_it_in_cpython
from Common.builtin_types import get_property_name_escaped as get_builtins_type_property_name

def is_final(name):
  'If there exists any exception with us as base then we are not final'

  for e in data:
    if e.base_class == name:
      return False

  return True

if __name__ == '__main__':
  print(f'''\
// swiftlint:disable line_length
// swiftlint:disable trailing_newline
// swiftlint:disable file_length

{generated_warning}

{where_to_find_it_in_cpython}
''')

  # For some of the exceptions we manyally wrote Swift class.
  manually_implemented = [
    'BaseException',
    'KeyError', # Custom '__str__' method
    'StopIteration', # 'value' property
  ]

  for t in data:
    name = t.class_name
    base = t.base_class
    doc = t.doc

    if name in manually_implemented:
      continue

    class_name = 'Py' + name
    doc = doc.replace('\n', ' " +\n"')
    final = 'final ' if is_final(name) else ''
    builtins_type_variable = get_builtins_type_property_name(name)

    print(f'''\
// MARK: - {name}

// sourcery: pyerrortype = {name}, default, baseType, hasGC, baseExceptionSubclass
public {final}class {class_name}: Py{base} {{

  override internal class var doc: String {{
    return "{doc}"
  }}

  override public var description: String {{
    return self.createDescription(typeName: "{class_name}")
  }}

  /// Type to set in `init`.
  override internal class var pythonType: PyType {{
    return Py.errorTypes.{builtins_type_variable}
  }}

  // sourcery: pyproperty = __class__
  override public func getClass() -> PyType {{
    return self.type
  }}

  // sourcery: pyproperty = __dict__
  override public func getDict() -> PyDict {{
    return self.__dict__
  }}

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {{
    let argsTuple = Py.newTuple(args)
    return .value({class_name}(args: argsTuple, type: type))
  }}

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyNone> {{
    return super.pyInit(args: args, kwargs: kwargs)
  }}
}}
''')
