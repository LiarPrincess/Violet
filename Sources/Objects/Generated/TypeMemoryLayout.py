from Sourcery import get_types, TypeInfo
from Common.strings import generated_warning


def get_layout_name(t: TypeInfo):
    return t.swift_type_name


if __name__ == '__main__':
    print(f'''\
// swiftlint:disable file_length

{generated_warning}
''')

    print('''\
extension PyType {

  /// Layout of a given type in memory.
  /// If types share the same layout then it means that they look exactly
  /// the same in memory.
  ///
  /// When creating new class we will check if all of the base classes have
  /// the same layout (it is also allowed for one layout to extend the other one).
  ///
  /// For example we will allow this:
  /// ```py
  /// >>> class C(int, object): pass
  /// ```
  ///
  /// But we will not allow this:
  /// ```py
  /// >>> class C(int, str): pass
  /// TypeError: multiple bases have instance lay-out conflict
  /// ```
  ///
  /// We don't actually need a list of fields etc.
  /// We will just use identity.
  ///
  /// Q: Do I need to create new layout for my type?
  /// A: Well, do you add new fields?
  ///    Yes - you need new layout (with base set to parent layout)
  ///    No - use parent layout
  public class MemoryLayout {

    /// Layout of the parent type.
    private let base: MemoryLayout?

    private init() {
      self.base = nil
    }

    public init(base: MemoryLayout) {
      self.base = base
    }

    internal func isEqual(to other: MemoryLayout) -> Bool {
      return self === other
    }

    /// Is the current layout based on given layout?
    /// 'Based' means that that is uses the given layout, but has more properties.
    internal func isAddingNewProperties(to other: MemoryLayout) -> Bool {
      // Same layout -> not adding new properties
      if self.isEqual(to: other) {
        return false
      }

      // Traverse 'self' hierarchy looking for 'other'
      var currentBaseOrNil: MemoryLayout? = self.base

      while let current = currentBaseOrNil {
        if current.isEqual(to: other) {
          return true
        }

        currentBaseOrNil = current.base
      }

      return false
    }
''')

    for t in get_types():
        swift_type_name = t.swift_type_name
        base_type_name = t.swift_base_type_name
        fields = t.swift_fields

        layout_name = get_layout_name(t)
        base_layout_name = base_type_name

        has_fields = len(fields) > 0
        if has_fields:
            print(f'    /// Fields:')
            for f in fields:
                field_name = f.swift_field_name
                field_type = f.swift_field_type
                print(f'    /// - `{field_name}: {field_type}`')

            if base_type_name:
                print(f'    public static let {layout_name} = MemoryLayout(base: MemoryLayout.{base_type_name})')
            else:
                assert swift_type_name == 'PyObject'
                print(f'    public static let {layout_name} = MemoryLayout()')
        else:
            print(f'    /// `{swift_type_name}` uses the same layout as it s base type (`{base_type_name}`).')
            print(f'    public static let {layout_name} = MemoryLayout.{base_layout_name}')

    print('  }')
    print('}')
