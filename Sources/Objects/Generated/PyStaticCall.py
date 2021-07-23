from Sourcery import get_types, TypeInfo
from Sourcery.signature import SignatureInfo
from Common.strings import generated_warning
from Static_methods import STATIC_METHODS

if __name__ == '__main__':
    print(f'''\
{generated_warning(__file__)}

import BigInt
import VioletCore

// swiftlint:disable discouraged_optional_boolean
// swiftlint:disable line_length
// swiftlint:disable file_length

/// Call Swift method directly without going through full Python dispatch
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
/// 2. Go into method wrapper (lldb: `s`)
/// 3. Step over `self` cast (lldb: `n`)
/// 4. Go into the final method (lldb: `s`)
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
internal enum PyStaticCall {{\
''')

    for m in STATIC_METHODS:
        name = m.name
        return_type = m.kind.return_type
        arguments = m.kind.arguments

        assert len(arguments) != 0
        self_argument = arguments[0]

        func_arguments = ''
        call_arguments = ''
        for index, arg in enumerate(arguments):
            if len(func_arguments) > 0:
                func_arguments += ', '
                call_arguments += ', '

            label = '_ ' if arg.has_underscore_label else ''
            func_arguments += f'{label}{arg.name}: {arg.typ}'
            call_arguments += arg.name

        print(f'''
  // MARK: - {name}

  internal static func {name}({func_arguments}) -> {return_type}? {{
    if let method = {self_argument.name}.type.staticMethods.{name}?.fn {{
      return method({call_arguments})
    }}

    return nil
  }}\
''')

    print('}')  # PyStaticCall end
