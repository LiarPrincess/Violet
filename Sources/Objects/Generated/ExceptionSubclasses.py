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

def get_class_name(t):
  name = t.class_name
  return 'Py' + name

def print_class_prolog(t):
  name = t.class_name
  base = t.base_class
  doc = t.doc

  class_name = get_class_name(t)
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
    let msg = self.message.map {{ "msg: \($0)" }} ?? ""
    return "{class_name}(\(msg))"
  }}

  /// Tupe to set in `init`.
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
   }}\
''')

def print_class_epilog(t):
  print('}')
  print()

def print_new(t):
  class_name = get_class_name(t)

  print(f'''\

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {{
    let argsTuple = Py.newTuple(args)
    return .value({class_name}(args: argsTuple))
  }}\
''')

def print_init(t):
  print(f'''\

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {{
    return super.pyInit(args: args, kwargs: kwargs)
  }}\
''')

if __name__ == '__main__':
  print(f'''\
// swiftlint:disable line_length
// swiftlint:disable trailing_newline
// swiftlint:disable file_length

{generated_warning}

{where_to_find_it_in_cpython}
''')

  for t in data:
    name = t.class_name

    # We already have 'BaseException' (manually written)
    if name == 'BaseException':
      continue

    print_class_prolog(t)
    print_new(t)
    print_init(t)
    print_class_epilog(t)
