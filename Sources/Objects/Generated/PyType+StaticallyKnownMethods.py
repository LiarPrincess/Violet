from Common.strings import generated_warning
from Static_methods import STATIC_METHODS

INSERT_NEW_LINE_BEFORE = (
    '__hash__',
    '__eq__',
    '__bool__',
    '__getattr__',
    '__getitem__',
    '__iter__',
    '__del__',
    '__instancecheck__',
    '__pos__',
    '__add__',
    '__radd__',
    '__iadd__',
    '__pow__',
)

if __name__ == '__main__':
    print(f'''\
{generated_warning(__file__)}

extension PyType {{

  /// Methods stored on `PyType` needed to make `PyStaticCall` work.
  ///
  /// See `PyStaticCall` documentation for more information.
  internal struct StaticallyKnownNotOverriddenMethods {{\
''')

    # ===============
    # === Methods ===
    # ===============

    print('''
    // MARK: - Properties

    // All of the function pointers have 16 bytes.
    // They also have invalid representation that can be used as optional tag.
    // So each of those function wrappers is exactly 16 bytes.
''')

    for m in STATIC_METHODS:
        name = m.name
        kind = m.kind.name

        if name in INSERT_NEW_LINE_BEFORE:
            print()

        print(f'    internal var {name}: {kind}Wrapper?')

    # ============
    # === Copy ===
    # ============

    print('''
    // MARK: - Copy

    internal func copy() -> StaticallyKnownNotOverriddenMethods {
      // We are struct, so this is trivial.
      // If we ever change it to reference type, then we just need to change
      // this method.
      return self
    }
  }
}
''')
