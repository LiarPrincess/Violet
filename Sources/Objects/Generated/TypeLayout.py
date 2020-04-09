from Data.types import get_types
from Common.strings import generated_warning

types = get_types()

def get_layout_name(t):
  return t.swift_type

if __name__ == '__main__':
  print(f'''\
// swiftlint:disable file_length

{generated_warning}

// When creating new class we will check if all of the base classes have
// the same layout.
// So, for example we will allow this:
//   >>> class C(int, object): pass
// but do not allow this:
//   >>> class C(int, str): pass
//   TypeError: multiple bases have instance lay-out conflict
''')

  print('''\
internal class TypeLayout: Equatable {

  private let base: TypeLayout?

  private init() {
    self.base = nil
  }

  private init(base: TypeLayout) {
    self.base = base
  }

  /// Is the current layout based on given layout?
  /// 'Based' means that that is uses the given layout, but has more properties.
  internal func isAddingNewProperties(to other: TypeLayout) -> Bool {
    var parentOrNil: TypeLayout? = self

    while let parent = parentOrNil {
      if parent == other {
        return true
      }

      parentOrNil = parent.base
    }

    return false
  }

  internal static func == (lhs: TypeLayout, rhs: TypeLayout) -> Bool {
    let lhsId = ObjectIdentifier(lhs)
    let rhsId = ObjectIdentifier(rhs)
    return lhsId == rhsId
  }
''')

  for t in types:
    swift_type = t.swift_type
    base_type = t.swift_base_type
    fields = t.fields

    layout_name = get_layout_name(t)
    base_layout_name = base_type

    has_fields = len(fields) > 0
    if not has_fields:
      print(f'  /// `{swift_type}` uses the same layout as it s base type (`{base_type}`).')
      print(f'  internal static let {layout_name} = TypeLayout.{base_layout_name}')

    if has_fields:
      for f in fields:
        field_name = f.swift_field_name
        field_type = f.swift_field_type
        print(f'  /// - `{field_name}: {field_type}`')

      if base_type:
        print(f'  internal static let {layout_name} = TypeLayout(base: TypeLayout.{base_type})')
      else:
        assert swift_type == 'PyObject'
        print(f'  internal static let {layout_name} = TypeLayout()')

  print('}')
