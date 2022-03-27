import Foundation
import FileSystem
import VioletCore
import VioletObjects

// swiftlint:disable:next type_name
public final class VM {

  public let py: Py
  internal let delegate: PyDelegate
  internal let fileSystem = PyFileSystem(fileSystem: .default)

  public init(arguments: Arguments, environment: Environment) {
    let executablePath = Bundle.main.executablePath ??
        arguments.raw.first ??
        Sys.implementation.name

    let config = PyConfig(
      arguments: arguments,
      environment: environment,
      executablePath: Path(string: executablePath),
      standardInput: PyFileDescriptor(fd: .standardInput, path: "stdin"),
      standardOutput: PyFileDescriptor(fd: .standardOutput, path: "stdin"),
      standardError: PyFileDescriptor(fd: .standardError, path: "stderr")
    )

    self.delegate = PyDelegate()
    self.py = Py(config: config, delegate: delegate, fileSystem: self.fileSystem)
  }

  deinit {
    self.py.destroy()
  }
}
