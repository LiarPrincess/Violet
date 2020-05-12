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

  /// Type to set in `init`.
  override internal class var pythonType: PyType {{
    return Py.errorTypes.{builtins_type_variable}
  }}\
''')

def print_class_epilog(t):
  print('}')
  print()

def print_common_properties(t):
  print(f'''
   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {{
     return self.type
   }}

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {{
     return self.__dict__
   }}\
''')

def print_new(t):
  class_name = get_class_name(t)

  print(f'''
  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {{
    let argsTuple = Py.newTuple(args)
    return .value({class_name}(args: argsTuple, type: type))
  }}\
''')

def print_init(t):
  print(f'''
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

    if name == 'KeyError':
      print_class_prolog(t)
      print_common_properties(t)
      print('''
  // sourcery: pymethod = __str__
  override public func str() -> PyResult<String> {
    // If args is a tuple of exactly one item, apply repr to args[0].
    // This is done so that e.g. the exception raised by {{}}[''] prints
    //     KeyError: ''
    // rather than the confusing
    //     KeyError
    // alone.  The downside is that if KeyError is raised with an explanatory
    // string, that string will be displayed in quotes.  Too bad.
    // If args is anything else, use the default BaseException__str__().

    let args = self.getArgs()

    switch args.getLength() {
    case 1:
      let first = args.elements[0]
      return Py.repr(object: first)
    default:
      return super.str()
    }
  }\
''')
      print_new(t)
      print_init(t)
      print_class_epilog(t)
    elif name == 'StopIteration':
      print_class_prolog(t)
      print('''
  private var value: PyObject

  internal convenience init(value: PyObject,
                            traceback: PyTraceback? = nil,
                            cause: PyBaseException? = nil,
                            context: PyBaseException? = nil,
                            suppressContext: Bool = false,
                            type: PyType? = nil) {
    let args = Py.newTuple(value)
    self.init(args: args,
              traceback: traceback,
              cause: cause,
              context: context,
              suppressContext: suppressContext,
              type: type)
  }

  override internal init(args: PyTuple,
                         traceback: PyTraceback? = nil,
                         cause: PyBaseException? = nil,
                         context: PyBaseException? = nil,
                         suppressContext: Bool = false,
                         type: PyType? = nil) {
    self.value = args.elements.first ?? Py.none
    super.init(args: args,
               traceback: traceback,
               cause: cause,
               context: context,
               suppressContext: suppressContext,
               type: type)
  }\
''')
      print_common_properties(t)
      print('''
  // sourcery: pyproperty = value, setter = setValue
  public func getValue() -> PyObject {
    return self.value
  }

  public func setValue(_ value: PyObject) -> PyResult<Void> {
    self.value = value
    return .value()
  }\
''')
      print_new(t)
      print('''
  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    self.value = args.first ?? Py.none
    return super.pyInit(args: args, kwargs: kwargs)
  }\
''')
      print_class_epilog(t)
    else:
      print_class_prolog(t)
      print_common_properties(t)
      print_new(t)
      print_init(t)
      print_class_epilog(t)
