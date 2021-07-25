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

// swiftlint:disable function_body_length
// swiftlint:disable file_length

extension PyType {{

  /// Methods stored on `PyType` needed to make `PyStaticCall` work.
  ///
  /// See `PyStaticCall` documentation for more information.
  internal struct StaticallyKnownNotOverriddenMethods {{
''')

    # ===============
    # === Methods ===
    # ===============

    print('''\
    // MARK: - Properties

    // All of the function pointers have 16 bytes.
    // They also have an invalid representation that can be used as optional tag.
    // So each of those function wrappers is exactly 16 bytes.
''')

    for m in STATIC_METHODS:
        name = m.name
        kind = m.kind.name

        if name in INSERT_NEW_LINE_BEFORE:
            print()

        print(f'    internal var {name}: {kind}Wrapper?')

    print()

    # ============
    # === Init ===
    # ============

    print('    // MARK: - Init')
    print()
    print("    // We need 'init' without params, because we also have other 'init'.")
    print('    internal init() {')

    for m in STATIC_METHODS:
        name = m.name
        kind = m.kind.name

        if name in INSERT_NEW_LINE_BEFORE:
            print()

        print(f'      self.{name} = nil')

    print('    }')
    print()

    # ================
    # === Init MRO ===
    # ================

    print('''\
    // MARK: - Init MRO

    /// Special init for heap types (types created on-the-fly,
    /// for example by 'class' statement).
    ///
    /// We can't just use 'base' type, because each type has a different method
    /// resolution order (MRO) and we have to respect this.
    internal init(
      mroWithoutCurrentlyCreatedType mro: MRO,
      dictForCurrentlyCreatedType dict: PyDict
    ) {
      self = StaticallyKnownNotOverriddenMethods()

      // We need to start from the back (the most base type, probably 'object').
      for type in mro.baseClasses.reversed() {
        self.copyMethods(from: type.staticMethods)
        self.removeOverriddenMethods(from: type.__dict__)
      }

      self.removeOverriddenMethods(from: dict)
    }
''')

    print('    private mutating func copyMethods(from other: StaticallyKnownNotOverriddenMethods) {')
    for m in STATIC_METHODS:
        name = m.name
        kind = m.kind.name

        if name in INSERT_NEW_LINE_BEFORE:
            print()

        print(f'      self.{name} = other.{name} ?? self.{name}')

    print('    }')
    print()

    print('''\
    private mutating func removeOverriddenMethods(from dict: PyDict) {
      for entry in dict.elements {
        let key = entry.key.object
        guard let string = PyCast.asString(key) else {
          continue
        }

        // All of the methods have ASCII name, so we can just use Swift definition
        // of equality.
        switch string.value {\
''')

    for m in STATIC_METHODS:
        name = m.name
        kind = m.kind.name

        if name in INSERT_NEW_LINE_BEFORE:
            print()

        print(f'        case "{name}": self.{name} = nil')

    print('        default: break')
    print('        }')
    print('      }')
    print('    }')
    print()

    # ============
    # === Copy ===
    # ============

    print('''\
    // MARK: - Copy

    internal func copy() -> StaticallyKnownNotOverriddenMethods {
      // We are struct, so this is trivial.
      // If we ever change it to reference type, then we just need to change
      // this method.
      return self
    }
  }
}\
''')
