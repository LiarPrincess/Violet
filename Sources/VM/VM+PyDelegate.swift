import Objects
import Bytecode
import Foundation

extension VM {

  // MARK: - Open

  public func open(fileno: Int32,
                   mode: FileMode) -> PyResult<FileDescriptorType> {
    // When we get raw descriptor we assume that the user knows what they
    // are doing, which means that we can ignore 'mode'.
    let result = FileDescriptor(fileDescriptor: fileno, closeOnDealloc: false)
    return .value(result)
  }

  /// static int
  /// _io_FileIO___init___impl(fileio *self, PyObject *nameobj, ... )
  public func open(file: String,
                   mode: FileMode) -> PyResult<FileDescriptorType> {
    var flags: Int32 = 0
    let createMode: Int = 0o666

    switch mode {
    case .read: flags |= O_RDONLY
    case .write: flags |= O_WRONLY | O_CREAT | O_TRUNC
    case .create: flags |= O_WRONLY | O_EXCL | O_CREAT
    case .append: flags |= O_WRONLY | O_APPEND | O_CREAT
    case .update: flags |= O_RDWR
    }

    if let fd = FileDescriptor(path: file,
                               flags: flags,
                               createMode: createMode) {
      return .value(fd)
    }

    return .osError("unable to open '\(file)' (mode: \(mode))")
  }

  // MARK: - Eval

  // swiftlint:disable:next function_parameter_count
  public func eval(name: String?,
                   qualname: String?,
                   code: CodeObject,

                   args: [PyObject],
                   kwArgs: Attributes?,
                   defaults: [PyObject],
                   kwDefaults: Attributes?,

                   globals: Attributes,
                   locals: Attributes) -> PyResult<PyObject> {
    return self.eval(
      name: name,
      qualname: qualname,
      code: code,

      args: args,
      kwArgs: kwArgs,
      defaults: defaults,
      kwDefaults: kwDefaults,

      globals: globals,
      locals: locals,
      parent: nil // TODO: Parent
    )
  }
}
