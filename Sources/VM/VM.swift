import Foundation
import VioletObjects

// swiftlint:disable:next type_name
public final class VM: PyDelegate {

  /// Stack of currently executed frames.
  ///
  /// Current frame is last.
  internal var frames = [PyFrame]()
  internal let fileSystem = FileSystemImpl(bundle: .main, fileManager: .default)

  internal let arguments: Arguments

  /// Currently executed frame.
  ///
  /// Required by `PyDelegate`.
  public var frame: PyFrame? {
    return self.frames.last
  }

  /// Currently handled exception.
  ///
  /// If exception was raised when another exception was beeing handled then
  /// the new one has `__context__` set to previous exception.
  /// (In terms of API: use `getContext()` to get to the first raised exception)
  ///
  /// For example:
  /// 1. We were handling `e1`
  /// 2. During that `e2` was raised
  /// In such case `currentlyHandledException` is set to `e2`, but you can
  /// get to `e1` by using `e2.__context__` (`e2.getContext()` in Swift).
  ///
  /// Tip 1. If `currentlyHandledException` is `nil` then we are currently
  /// not handling any exceptions
  /// Tip 2. To get to the first raised exception follow `getContext()` path
  /// until you get to the exception which has `getContext()` set to `nil`.
  ///
  /// Required by `PyDelegate`.
  public var currentlyHandledException: PyBaseException?

  public init(arguments: Arguments, environment: Environment) {
    self.arguments = arguments

    let executablePath = self.fileSystem.executablePath ??
        arguments.raw.first ??
        "Violet"

    let config = PyConfig(
      arguments: arguments,
      environment: environment,
      executablePath: executablePath,
      standardInput: FileDescriptorAdapter(for: .standardInput),
      standardOutput: FileDescriptorAdapter(for: .standardOutput),
      standardError: FileDescriptorAdapter(for: .standardError)
    )

    Py.initialize(
      config: config,
      delegate: self,
      fileSystem: self.fileSystem
    )
  }

  deinit {
    Py.destroy()
  }
}
