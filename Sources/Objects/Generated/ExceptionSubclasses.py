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

  for e in data:
    name = e.class_name
    base = e.base_class
    doc = e.doc

    if name == 'BaseException':
      continue

    doc = doc.replace('\n', ' " +\n"')
    final = 'final ' if is_final(name) else ''
    builtins_type_variable = get_builtins_type_property_name(name)

    print(f'''\
// MARK: - {name}

// sourcery: pyerrortype = {name}, default, baseType, hasGC, baseExceptionSubclass
public {final}class Py{name}: Py{base} {{

  override internal class var doc: String {{
    return "{doc}"
  }}

  override public var description: String {{
    let msg = self.message.map {{ "msg: \($0)" }} ?? ""
    return "Py{name}(\(msg))"
  }}

  override internal func setType() {{
    self.setType(to: Py.errorTypes.{builtins_type_variable})
  }}

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {{
     return self.type
   }}

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {{
     return self.__dict__
   }}

  // sourcery: pymethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyObject> {{
    let argsTuple = Py.newTuple(args)
    return .value(Py{name}(args: argsTuple))
  }}

  // sourcery: pymethod = __init__
  internal class func pyInit(zelf: Py{name},
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyNone> {{
    return PyBaseException.pyInitShared(zelf: zelf, args: args, kwargs: kwargs)
  }}
}}
''')
