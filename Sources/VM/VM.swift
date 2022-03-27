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
      standardInput: FileDescriptorAdapter(fd: .standardInput, path: "stdin"),
      standardOutput: FileDescriptorAdapter(fd: .standardOutput, path: "stdin"),
      standardError: FileDescriptorAdapter(fd: .standardError, path: "stderr")
    )

    self.delegate = PyDelegate()
    self.py = Py(config: config, delegate: delegate, fileSystem: self.fileSystem)
  }

  deinit {
    self.py.destroy()
  }
}
