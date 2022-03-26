from Helpers import generated_warning, ALL_STATIC_METHODS

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

import BigInt
import VioletCore

// swiftlint:disable nesting
// swiftlint:disable discouraged_optional_boolean
// swiftlint:disable function_body_length
// swiftlint:disable line_length
// swiftlint:disable file_length

/// Call Swift method directly without going through a full Python dispatch
/// (if possible).
///
/// # What is this?
///
/// Certain Python methods are used very often.
/// While we could do the full Python dispatch on every call, we can also store the
/// pointer to resolved Swift function directly on type (`PyType` instance).
/// Then when this method is called we would use the stored function instead
/// of doing the costly `MRO` lookup.
///
/// Example: we want to call `list.__len__`
///
/// Python dispatch:
/// 1. Lookup `__len__` in `list` `MRO` - this operation is complicated,
///    especially when the method is defined on one of the base types.
/// 2. Create method object bound to specific `list` instance - this means heap
///    allocation.
/// 3. Dispatch bound method - it will (eventually) call `PyList.__len__` in Swift.
///
/// Static dispatch (the one defined in this file):
/// 1. Check if `object.type` contains pointer to `__len__` function - if this fails
///    (for example when method is overridden) then do full 'Python dispatch'.
/// 2. Call Swift function stored in this pointer - this is (almost) a direct call
///    to `PyList.__len__`.
///
/// Ofc. It does not make sense to do this for every method, in our case we will
/// just use the most common magic methods.
///
/// # Why?
///
/// REASON 1: Debugging
///
/// Trust me, you don't want to debug a raw Python dispatch.
/// There is a lot of code involved, with multiple method calls (which can fail).
///
/// On the other hand static calls in lldb look like this:
/// 1. Check if `list` has stored `__len__` function pointer (lldb: `n`)
/// 2. Go into the final method (lldb: `s`)
///
/// REASON 2: Static calls during `Py.initialize`
///
/// This also allows us to call Python methods during `Py.initialize`,
/// when not all of the types are yet fully initialized.
///
/// For example when we have not yet added `__hash__` to `str.__dict__`
/// we can still call this method because we know (statically) that `str` does
/// implement this operation. This has a side-effect of using `str.__hash__`
/// (via static call) to insert `__hash__` inside `str.__dict__`.
///
/// # Is this bullet-proof?
///
/// Not really.
/// If you remove one of the builtin methods from a type, then function pointer
/// on type still remains.
///
/// But most of the time you can't do this:
/// ```py
/// >>> del list.__len__
/// Traceback (most recent call last):
///   File "<stdin>", line 1, in <module>
/// TypeError: can't set attributes of built-in/extension type 'list'
/// ```
///
/// Also you have to take care of overridden methods in classes written by user:
/// - Option 1: do not fill any of the function pointers on subclass -> all of the
///             methods will use Python dispatch.
/// - Option 2: use pointers from base class, but remove entries for overridden methods.
public enum PyStaticCall {{

  /// Methods stored on `PyType` needed to make `PyStaticCall` work.
  ///
  /// See `PyStaticCall` documentation for more information.
  public final class KnownNotOverriddenMethods {{
''')

    # =======================
    # === class - Aliases ===
    # =======================

    print('''\
    // MARK: - Aliases
''')

    already_printed_kinds = set()
    for m in ALL_STATIC_METHODS:
        kind = m.kind
        name = kind.name
        if name in already_printed_kinds:
            continue

        signature = '('
        for index, arg in enumerate(kind.arguments):
            if index != 0:
                signature += ', '
            signature += arg.typ

        signature += ')'
        signature += f' -> {kind.return_type}'

        print(f'    public typealias {name} = {signature}')
        already_printed_kinds.add(name)

    print()

    # ==========================
    # === class - Properties ===
    # ==========================

    print('''\
    // MARK: - Properties

    // All of the function pointers have 16 bytes.
    // They also have an invalid representation that can be used as optional tag.
    // So each of those functions is exactly 16 bytes.
''')

    for m in ALL_STATIC_METHODS:
        if m.name in INSERT_NEW_LINE_BEFORE:
            print()

        print(f'    public var {m.name}: {m.kind.name}?')

    print()

    # ====================
    # === class - Init ===
    # ====================

    print('    // MARK: - Init')
    print()
    print('    public init() {')

    for m in ALL_STATIC_METHODS:
        if m.name in INSERT_NEW_LINE_BEFORE:
            print()

        print(f'      self.{m.name} = nil')

    print('    }')
    print()

    # ========================
    # === class - Init MRO ===
    # ========================

    print('''\
    // MARK: - Init MRO

    /// Special init for heap types (types created on-the-fly,
    /// for example by 'class' statement).
    ///
    /// We can't just use 'base' type, because each type has a different method
    /// resolution order (MRO) and we have to respect this.
    public convenience init(
      _ py: Py,
      mroWithoutCurrentlyCreatedType mro: [PyType],
      dictForCurrentlyCreatedType dict: PyDict
    ) {
      self.init()

      // We need to start from the back (the most base type, probably 'object').
      for type in mro.reversed() {
        let dict = type.getDict(py)
        self.removeOverriddenMethods(py, dict: dict)
        self.copyMethods(from: type.staticMethods)
      }

      self.removeOverriddenMethods(py, dict: dict)
    }
''')

    print('    private func copyMethods(from other: KnownNotOverriddenMethods) {')
    for m in ALL_STATIC_METHODS:
        if m.name in INSERT_NEW_LINE_BEFORE:
            print()

        print(f'      self.{m.name} = other.{m.name} ?? self.{m.name}')

    print('    }')
    print()

    print('''\
    private func removeOverriddenMethods(_ py: Py, dict: PyDict) {
      for entry in dict.elements {
        let key = entry.key.object
        guard let string = py.cast.asString(key) else {
          continue
        }

        // All of the methods have ASCII name, so we can just use Swift definition
        // of equality.
        switch string.value {\
''')

    for m in ALL_STATIC_METHODS:
        if m.name in INSERT_NEW_LINE_BEFORE:
            print()

        print(f'        case "{m.name}": self.{m.name} = nil')

    print('        default: break')
    print('        }')
    print('      }')
    print('    }')
    print()

    # ====================
    # === class - Copy ===
    # ====================

    print('    // MARK: - Copy')
    print()
    print('    public func copy() -> KnownNotOverriddenMethods {')
    print('      let result = KnownNotOverriddenMethods()')
    print()

    for m in ALL_STATIC_METHODS:
        if m.name in INSERT_NEW_LINE_BEFORE:
            print()

        print(f'      result.{m.name} = self.{m.name}')

    print()
    print('      return result')
    print('    }')
    print('  }')

    # =================
    # === Functions ===
    # =================

    for m in ALL_STATIC_METHODS:
        name = m.name
        return_type = m.kind.return_type
        arguments = m.kind.arguments

        assert len(arguments) >= 2 # 'Py' and 'zelf'
        self_argument = arguments[1]

        func_arguments = ''
        call_arguments = ''
        for index, arg in enumerate(arguments):
            if index != 0:
                func_arguments += ', '
                call_arguments += ', '

            label = '_ ' if arg.has_underscore_label else ''
            func_arguments += f'{label}{arg.name}: {arg.typ}'
            call_arguments += arg.name

        print(f'''
  // MARK: - {name}

  internal static func {name}({func_arguments}) -> {return_type}? {{
    guard let method = {self_argument.name}.type.staticMethods.{name} else {{
      return nil
    }}

    return method({call_arguments})
  }}\
''')

    print('}')  # PyStaticCall end
