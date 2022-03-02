/// Initial section of every Python error object in memory.
///
/// Guaranteed to be word aligned.
public struct PyErrorHeader {

  // MARK: - Properties

  private static let suppressContextFlag = PyObjectHeader.Flags.custom0

  // sourcery: includeInLayout
  private var args: PyTuple { self.argsPtr.pointee }

  // sourcery: includeInLayout
  private var traceback: PyTraceback? { self.tracebackPtr.pointee }

  // sourcery: includeInLayout
  /// `raise from xxx`.
  private var cause: PyBaseException? { self.causePtr.pointee }

  // sourcery: includeInLayout
  /// Another exception during whose handling this exception was raised.
  private var context: PyBaseException? { self.contextPtr.pointee }

  /// Should we use `self.cause` or `self.context`?
  ///
  /// If we have `cause` then probably `cause`, otherwise `context`.
  internal var suppressContext: Bool {
    get { self.objectHeader.flags.isSet(Self.suppressContextFlag) }
    nonmutating set { self.objectHeader.flags.set(Self.suppressContextFlag, to: newValue) }
  }

  private var objectHeader: PyObjectHeader {
    PyObjectHeader(ptr: self.ptr)
  }

  // MARK: - Init

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // MARK: - Initialize/deinitialize

  // swiftlint:disable:next function_parameter_count
  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback?,
                           cause: PyBaseException?,
                           context: PyBaseException?,
                           suppressContext: Bool) {
    self.objectHeader.initialize(py, type: type)
    self.argsPtr.initialize(to: args)
    self.tracebackPtr.initialize(to: traceback)
    self.causePtr.initialize(to: cause)
    self.contextPtr.initialize(to: context)
    self.suppressContext = suppressContext
  }

  internal func deinitialize() {
    self.objectHeader.deinitialize()
    self.argsPtr.deinitialize()
    self.tracebackPtr.deinitialize()
    self.causePtr.deinitialize()
    self.contextPtr.deinitialize()
  }
}
