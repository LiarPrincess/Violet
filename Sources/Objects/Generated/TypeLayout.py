import os
import sys

# ----
# File
# ----

class SwiftType:
  def __init__(self, name, base_name):
    self.name = name
    self.base_name = base_name
    self.properties = []

class SwiftProperty:
  def __init__(self, name, type):
    self.name = name
    self.type = type

def read_input_file() -> [SwiftType]:
  dir_path = os.path.dirname(__file__)
  input_file = os.path.join(dir_path, 'TypeLayout.tmp')

  result = []
  current_type = None

  with open(input_file, 'r') as reader:
    for line in reader:
      line = line.strip()

      if not line or line.startswith('#'):
        continue

      is_property = line.startswith('-')
      if is_property:
        assert current_type

        line_without_minus = line[1:].strip()
        split = line_without_minus.split('|')
        assert len(split) == 2

        prop_name = split[0]
        prop_type = split[1]

        # Description does not matter for layout
        if prop_name == 'description' and prop_type == 'String':
          continue

        prop = SwiftProperty(split[0], split[1])
        current_type.properties.append(prop)

      else:
        # Starting new type
        split = line.split('|')
        assert len(split) == 2

        current_type = SwiftType(split[0], split[1])
        result.append(current_type)

  return result

# -----
# Print
# -----

def print_layouts():
  print('''\
// When creating new class we will check if all of the base classes have
// the same layout.
// So, for example we will allow this:
//   >>> class C(int, object): pass
// but do not allow this:
//   >>> class C(int, str): pass
//   TypeError: multiple bases have instance lay-out conflict

// swiftlint:disable file_length

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

  for t in read_input_file():
    has_properties = len(t.properties) > 0
    if has_properties:
      for p in t.properties:
        print(f'  /// - `{p.name}: {p.type}`')

      if t.base_name:
        print(f'  internal static let {t.name} = TypeLayout(base: TypeLayout.{t.base_name})')
      else:
        assert t.name == 'PyObject'
        print(f'  internal static let {t.name} = TypeLayout()')

    else:
      print(f'  /// `{t.name}` uses the same layout as it s base type (`{t.base_name}`).')
      print(f'  internal static let {t.name} = TypeLayout.{t.base_name}')

  print('}')

# ----
# Main
# ----

if __name__ == '__main__':
  print_layouts()
