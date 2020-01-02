import Foundation

// In CPython:
// Modules -> _io -> textio.c
// https://docs.python.org/3.7/library/io.html

#warning("3188: PyTypeObject PyTextIOWrapper_Type = {")

// sourcery: pytype = file, default, baseType, hasGC, hasFinalize
/// `TextIOWrapper` is a Python class for reading and writing files.
/// It is also used as `sys.stdin` and `sys.stdout`.
///
/// We will implement this class, but:
/// - only partially (just the things we actually need)
/// - as a part of ` builtins` module (because we are too lazy to introduce a new one)
/// - without class hierarchy
public class PyFile: PyObject {

  internal let fd: FileDescriptor
  internal let encoding: FileEncoding
  internal let errors: FileErrorHandler

  // MARK: - Init

  internal init(_ context: PyContext,
                fd: FileDescriptor,
                encoding: FileEncoding,
                errors: FileErrorHandler) {
    self.fd = fd
    self.encoding = encoding
    self.errors = errors
    super.init(type: context.builtins.types.none) // <-- THIS!!!
  }
}
