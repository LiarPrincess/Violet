import Foundation
import VioletObjects

// swiftlint:disable file_length
// cSpell:ignore BPOSIX fileio nameobj

// A lot of this code was based on:
// https://github.com/apple/swift-corelibs-foundation/blob/master/Sources/
//    Foundation/FileManager%2BPOSIX.swift

#if canImport(Darwin)
import Darwin

private let _stat = Darwin.stat(_:_:)
#elseif canImport(Glibc)
import Glibc

private let _stat = Darwin.stat(_:_:)
#endif

#if os(Windows)
let pathSeparators: [Character] = ["\\", "/"]
#else
let pathSeparators: [Character] = ["/"]
#endif

internal class FileSystemImpl: PyFileSystem {

  private let bundle: Bundle
  private let fileManager: FileManager

  internal init(bundle: Bundle, fileManager: FileManager) {
    self.bundle = bundle
    self.fileManager = fileManager
  }

  // MARK: - Executable

  internal var executablePath: String? {
    return self.bundle.executablePath
  }

  // MARK: - Cwd

  internal var currentWorkingDirectory: String {
    return self.fileManager.currentDirectoryPath
  }

  // MARK: - Exists

  /// Check if the file at given path exists.
  internal func exists(path: String) -> Bool {
    var isDir = false
    return self.exists(path: path, isDirectory: &isDir)
  }

  /// Check if the file at given path exists.
  internal func exists(path: String, isDirectory: inout Bool) -> Bool {
    var isDirResult: ObjCBool = false
    let existsResult = self.fileManager.fileExists(
      atPath: path,
      isDirectory: &isDirResult
    )

    isDirectory = isDirResult.boolValue
    return existsResult
  }

  // MARK: - Open

  internal func open(fd: Int32, mode: FileMode) -> PyResult<FileDescriptorType> {
    // When we get raw descriptor we assume that the user knows what they
    // are doing, which means that we can ignore 'mode'.
    let result = FileDescriptor(fileDescriptor: fd, closeOnDealloc: false)
    return .value(FileDescriptorAdapter(fd: result, path: nil))
  }

  /// static int
  /// _io_FileIO___init___impl(fileio *self, PyObject *nameobj, … )
  internal func open(path: String, mode: FileMode) -> PyResult<FileDescriptorType> {
    var flags: Int32 = 0
    let createMode: Int = 0o666

    switch mode {
    case .read: flags |= O_RDONLY
    case .write: flags |= O_WRONLY | O_CREAT | O_TRUNC
    case .create: flags |= O_WRONLY | O_EXCL | O_CREAT
    case .append: flags |= O_WRONLY | O_APPEND | O_CREAT
    case .update: flags |= O_RDWR
    }

    if let fd = FileDescriptor(path: path,
                               flags: flags,
                               createMode: createMode) {
      return .value(FileDescriptorAdapter(fd: fd, path: path))
    }

    switch self.stat(path: path) {
    case .enoent:
      return .error(Py.newFileNotFoundError(path: path))
    case .value,
         .error:
      // Maybe we could check 'stat' for permissions?
      return .osError("unable to open '\(path)' (mode: \(mode))")
    }
  }

  // MARK: - Stat

  internal func stat(fd: Int32) -> PyFileSystem_StatResult {
    var info = Foundation.stat()
    guard fstat(fd, &info) == 0 else {
      return self.handleStatError(path: nil)
    }

    let result = self.createStat(from: info)
    return .value(result)
  }

  /// Foundation:
  /// func _fileExists(atPath path: String, , isDirectory: UnsafeMutablePointer<ObjCBool>?)
  internal func stat(path: String) -> PyFileSystem_StatResult {
    guard let nonEmpty = NonEmptyPath(from: path) else {
      return .enoent
    }

    return self.withFileSystemRepresentation(path: nonEmpty) { fsRep in
      var info = Foundation.stat()
      guard _stat(fsRep, &info) == 0 else {
        return self.handleStatError(path: path)
      }

      let result = self.createStat(from: info)
      return .value(result)
    }
  }

  private func createStat(from stat: stat) -> PyFileSystem_Stat {
    return PyFileSystem_Stat(
      st_mode: stat.st_mode,
      st_mtime: stat.st_mtimespec
    )
  }

  private func handleStatError(path: String?) -> PyFileSystem_StatResult {
    if errno == ENOENT {
      return .enoent
    }

    if let p = path {
      return .error(Py.newOSError(errno: errno, path: p))
    }

    return .error(Py.newOSError(errno: errno))
  }

  // MARK: - List dir

  internal func listdir(fd: Int32) -> PyFileSystem_ListdirResult {
    guard let dir = fdopendir(fd) else {
      return .enoent
    }
    defer { closedir(dir) }

    switch self.listdir(dir: dir) {
    case let .entries(e):
      return .entries(e)
    case let .error(errno: e):
      return .error(Py.newOSError(errno: e))
    }
  }

  /// Foundation:
  /// func _contentsOfDir(atPath path: String, _ closure: (String, Int32) throws -> ())
  internal func listdir(path: String) -> PyFileSystem_ListdirResult {
    guard let nonEmpty = NonEmptyPath(from: path) else {
      return .enoent
    }

    return self.withFileSystemRepresentation(path: nonEmpty) { fsRep in
      guard let dir = opendir(fsRep) else {
        return .enoent
      }
      defer { closedir(dir) }

      switch self.listdir(dir: dir) {
      case let .entries(e):
        return .entries(e)
      case let .error(errno: e):
        return .error(Py.newOSError(errno: e, path: path))
      }
    }
  }

  private enum ListdirInnerResult {
    case entries([String])
    case error(errno: Int32)
  }

  private func listdir(dir: UnsafeMutablePointer<DIR>) -> ListdirInnerResult {
    // readdir returns NULL on EOF and error so set errno to 0 to check for errors
    var result = [String]()
    errno = 0

    while let entry = readdir(dir) {
      let name = withUnsafePointer(to: entry.pointee.d_name) { ptr -> String in
        let namePtr = UnsafeRawPointer(ptr)
        let nameLen = entry.pointee.d_namlen
        let data = Data(bytes: namePtr, count: Int(nameLen))
        return String(data: data, encoding: .utf8)!
        // swiftlint:disable:previous force_unwrapping
      }

      if name != "." && name != ".." {
        result.append(name)
      }

      errno = 0
    }

    guard errno == 0 else {
      return .error(errno: errno)
    }

    return .entries(result)
  }

  // MARK: - Basename

  internal func basename(path: String) -> String {
    guard let nonEmpty = NonEmptyPath(from: path) else {
      return "" // $ basename ""
    }

    // 'Foundation.basename' returns 'UnsafeMutablePointer<Int8>!',
    // so it is safe to unwrap.
    let cString = self.withMutableFileSystemRepresentation(
      path: nonEmpty,
      body: Foundation.basename
    )! // swiftlint:disable:this force_unwrapping

    return String(cString: cString)
  }

  // MARK: - Dirname

  internal func dirname(path: String) -> PyFileSystem_DirnameResult {
    guard let nonEmpty = NonEmptyPath(from: path) else {
      // $ dirname ""
      return PyFileSystem_DirnameResult(path: ".", isTop: true)
    }

    // 'Foundation.dirname' returns 'UnsafeMutablePointer<Int8>!',
    // so it is safe to unwrap.
    let cString = self.withMutableFileSystemRepresentation(
      path: nonEmpty,
      body: Foundation.dirname
    )! // swiftlint:disable:this force_unwrapping

    // https://linux.die.net/man/3/dirname
    let result = String(cString: cString)
    switch result {
    case ".":
      return PyFileSystem_DirnameResult(path: ".", isTop: true)
    case "/":
      return PyFileSystem_DirnameResult(path: "/", isTop: true)
    default:
      return PyFileSystem_DirnameResult(path: result, isTop: false)
    }
  }

  // MARK: - Join

  internal func join(paths: String...) -> String {
    guard let first = paths.first else {
      return ""
    }

    var result = first
    for component in paths.dropFirst() {
      if component.isEmpty {
        continue
      }

      // Is result empty?
      guard let last = result.last else {
        result = component
        continue
      }

      if !self.isPathSeparator(char: last) {
        // We will do this even if 'component' is empty
        result.append(pathSeparators[0])
      }

      result.append(component)
    }

    return result
  }

  private func isPathSeparator(char: Character) -> Bool {
    return pathSeparators.contains(char)
  }

  // MARK: - Helpers

  /// `FileManager.fileSystemRepresentation` does not accept empty path.
  /// We will prevent that on the type level.
  ///
  /// Otherwise we would have 'to remember' to check this every time.
  /// And you know how it works when programmers have 'to remember' stuff…
  private struct NonEmptyPath {

    fileprivate let value: String

    fileprivate init?(from value: String) {
      if value.isEmpty {
        return nil
      }

      self.value = value
    }
  }

  private func withFileSystemRepresentation<ResultType>(
    path: NonEmptyPath,
    body: (UnsafePointer<Int8>) -> ResultType
  ) -> ResultType {
    // I think we should add 'defer { fsRep.deallocate() }',
    // but it we do so our unit tests will fail.
    let fsRep = self.fileManager.fileSystemRepresentation(withPath: path.value)
    return body(fsRep)
  }

  private func withMutableFileSystemRepresentation<ResultType>(
    path: NonEmptyPath,
    body: (UnsafeMutablePointer<Int8>) -> ResultType
  ) -> ResultType {
    return self.withFileSystemRepresentation(path: path) { fsRep -> ResultType in
      let fsRepMut = UnsafeMutablePointer(mutating: fsRep)
      return body(fsRepMut)
    }
  }
}
