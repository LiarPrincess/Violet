// swiftlint:disable force_unwrapping
// swiftlint:disable file_length
// cSpell:ignore corelibs nulldevice closeopt

import Foundation
import VioletCore

// FileHandle has a .read(upToCount:) method.
// Just invoking read() will cause an ambiguity warning. Use _read instead.
#if canImport(Darwin)
import Darwin

private let _read = Darwin.read(_:_:_:)
private let _write = Darwin.write(_:_:_:)
private let _close = Darwin.close(_:)
#elseif canImport(Glibc)
import Glibc

private let _read = Glibc.read(_:_:_:)
private let _write = Glibc.write(_:_:_:)
private let _close = Glibc.close(_:)
#endif

// MARK: - Polyfills (because we JS now)

private func _NSErrorWithErrno(_ posixErrno: Int32,
                               reading: Bool,
                               path: String? = nil,
                               url: URL? = nil) -> Swift.Error {
  return FileDescriptor.Error(errno: posixErrno,
                              operation: reading ? .read : .write)
}

private func _CFReallocf(_ ptr: UnsafeMutableRawPointer,
                         _ size: Int) -> UnsafeMutableRawPointer {
  #if canImport(Darwin)
  return reallocf(ptr, size)
  #elseif canImport(Glibc)
  // Code in C:
  // #if TARGET_OS_WIN32 || TARGET_OS_LINUX
  //
  // void *mem = realloc(ptr, size);
  // if (mem == NULL && ptr != NULL && size != 0) {
  //     free(ptr);
  // }

  guard let mem = Foundation.realloc(ptr, size) else {
    trap("Unable to reallocate \(ptr)")
  }

  return mem
  #endif
}

private func _CFOpenFile(_ path: UnsafePointer<CChar>,
                         _ opts: Int32) -> Int32 {
  return open(path, opts, 0)
}

private func _CFOpenFileWithMode(_ path: UnsafePointer<CChar>,
                                 _ opts: Int32,
                                 _ mode: mode_t) -> Int32 {
  return open(path, opts, mode)
}

// MARK: - FileDescriptor

/// Our own wrapper around file descriptor.
/// Please see the module README for details.
///
/// Code mostly taken from 'swift-corelibs-foundation' with following changes:
/// - we are no longer NSObject
/// - no queues/barriers
public class FileDescriptor: CustomStringConvertible {

  public enum ErrorType {
    case fileReadTooLarge
    case fileReadNoSuchFile
    case fileReadNoPermission
    case fileReadUnknown

    case noSuchFile
    case fileWriteNoPermission
    case fileWriteOutOfSpace
    case fileWriteInvalidFileName
    case fileWriteVolumeReadOnly
    case fileWriteFileExists
    case fileWriteUnknown
  }

  public enum Operation {
    case read
    case write
  }

  public struct Error: Swift.Error {

    public let errno: Int32
    public let operation: Operation

    public var type: ErrorType {
      switch self.operation {
      case .read:
        switch self.errno {
        case EFBIG: return .fileReadTooLarge
        case ENOENT: return .fileReadNoSuchFile
        case EPERM,
             EACCES: return .fileReadNoPermission
        case ENAMETOOLONG: return .fileReadUnknown
        default: return .fileReadUnknown
        }
      case .write:
        switch self.errno {
        case ENOENT: return .noSuchFile
        case EPERM,
             EACCES: return .fileWriteNoPermission
        case ENAMETOOLONG: return .fileWriteInvalidFileName
        case EDQUOT,
             ENOSPC: return .fileWriteOutOfSpace
        case EROFS: return .fileWriteVolumeReadOnly
        case EEXIST: return .fileWriteFileExists
        default: return .fileWriteUnknown
        }
      }
    }

    public var str: String {
      guard let cStr = strerror(self.errno) else {
        return "unknown IO error"
      }

      return String(cString: cStr)
    }

    fileprivate static var fileReadUnknown: Error {
      return Error(errno: -1, operation: .read)
    }

    fileprivate static var fileWriteUnknown: Error {
      return Error(errno: -1, operation: .write)
    }
  }

  private var _fd: Int32
  private var _closeOnDealloc: Bool

  public var raw: Int32 {
    return self._fd
  }

  public var description: String {
    // We could also switch on value of 'self._fd' (0, 1 or 2),
    // but we want to differentiate user-created stdio and ours.

    if self === FileDescriptor.standardInput {
      return "FileDescriptor.standardInput"
    }

    if self === FileDescriptor.standardOutput {
      return "FileDescriptor.standardOutput"
    }

    if self === FileDescriptor.standardError {
      return "FileDescriptor.standardError"
    }

    return "FileDescriptor(raw: \(self._fd))"
  }

  /// Foundation: `func _checkFileHandle()`
  private func _isValidOrFatal() {
    precondition(self._fd >= 0, "Bad file descriptor")
  }

  /// Foundation: `var _isPlatformHandleValid: Bool`
  private var _isValid: Bool {
    return self._fd >= 0
  }

  private var availableData: Data {
    self._isValidOrFatal()
    do {
      return try self._readDataOfLength(Int.max, untilEOF: false)
    } catch {
      trap("\(error)")
    }
  }

  // MARK: - Helpers - read

  private func _readDataOfLength(_ length: Int, untilEOF: Bool) throws -> Data {
    guard self._isValid else {
      throw Error.fileReadUnknown
    }

    if length == 0 && !untilEOF {
      // Nothing requested, return empty response
      return Data()
    }

    let readBlockSize = try self.determineReadBlockSize()
    var currentAllocationSize = readBlockSize
    var dynamicBuffer = malloc(currentAllocationSize)!
    var total = 0

    while total < length {
      let remaining = length - total
      let amountToRead = min(readBlockSize, remaining)

      // Make sure there is always at least amountToRead bytes available in the buffer.
      if (currentAllocationSize - total) < amountToRead {
        currentAllocationSize *= 2
        dynamicBuffer = _CFReallocf(dynamicBuffer, currentAllocationSize)
      }

      let amtRead = _read(self._fd, dynamicBuffer.advanced(by: total), amountToRead)
      if amtRead < 0 {
        free(dynamicBuffer)
        throw _NSErrorWithErrno(errno, reading: true)
      }

      total += amtRead
      // If there is nothing more to read or we shouldn't keep reading then exit
      if amtRead == 0 || !untilEOF {
        break
      }
    }

    if total == 0 {
      free(dynamicBuffer)
      return Data()
    }

    dynamicBuffer = _CFReallocf(dynamicBuffer, total)
    let bytePtr = dynamicBuffer.bindMemory(to: UInt8.self, capacity: total)
    return Data(bytesNoCopy: bytePtr, count: total, deallocator: .free)
  }

  // This code was taken from '_readDataOfLength' and moved to separate function,
  // because we also need it in 'readLine'.
  private func determineReadBlockSize() throws -> Int {
    guard self._isValid else {
      throw Error.fileReadUnknown
    }

    var statbuf = stat()
    if fstat(self._fd, &statbuf) < 0 {
      throw _NSErrorWithErrno(errno, reading: true)
    }

    let readBlockSize: Int
    if statbuf.st_mode & S_IFMT == S_IFREG {
      if statbuf.st_blksize > 0 {
        readBlockSize = Int(clamping: statbuf.st_blksize)
      } else {
        readBlockSize = 1_024 * 8
      }
    } else {
      /* We get here on sockets, character special files, FIFOs … */
      readBlockSize = 1_024 * 8
    }

    return readBlockSize
  }

  private func _readBytes(into buffer: UnsafeMutablePointer<UInt8>,
                          length: Int) throws -> Int {
    let amtRead = _read(self._fd, buffer, length)
    if amtRead < 0 {
      throw _NSErrorWithErrno(errno, reading: true)
    }

    return amtRead
  }

  // MARK: - Helpers - Write

  private func _writeBytes(buf: UnsafeRawPointer, length: Int) throws {
    var bytesRemaining = length
    while bytesRemaining > 0 {
      var bytesWritten = 0

      repeat {
        bytesWritten = _write(self._fd,
                              buf.advanced(by: length - bytesRemaining),
                              bytesRemaining)
      } while bytesWritten < 0 && errno == EINTR

      if bytesWritten <= 0 {
        throw _NSErrorWithErrno(errno, reading: false, path: nil)
      }
      bytesRemaining -= bytesWritten
    }
  }

  // MARK: - Init

  public init(fileDescriptor fd: Int32, closeOnDealloc closeopt: Bool) {
    self._fd = fd
    self._closeOnDealloc = closeopt
  }

  public convenience init(fileDescriptor fd: Int32) {
    self.init(fileDescriptor: fd, closeOnDealloc: false)
  }

  public init?(path: String, flags: Int32, createMode: Int) {
    self._fd = _CFOpenFileWithMode(path, flags, mode_t(createMode))
    self._closeOnDealloc = true

    if self._fd < 0 {
      return nil
    }
  }

  // MARK: - Deinit

  deinit {
    try? _immediatelyClose()
  }

  // MARK: - Read

  public func readLine() throws -> Data {
    guard self._isValid else {
      throw Error.fileReadUnknown
    }

    let readBlockSize = try self.determineReadBlockSize()
    let bufferPtr = malloc(readBlockSize)!
    defer { free(bufferPtr) }

    var result = Data()
    let newLines = CharacterSet.newlines

    while true {
      // Hmm… I'm not sure that this is the best way
      let requestedReadCount = 1
      let readCount = _read(self._fd, bufferPtr, requestedReadCount)

      if readCount < 0 {
        throw _NSErrorWithErrno(errno, reading: true)
      }

      let isEnd = readCount == 0
      if isEnd {
        return result
      }

      let buffer = UnsafeRawBufferPointer(start: bufferPtr, count: readCount)
      for byte in buffer {
        let scalar = UnicodeScalar(byte)

        if newLines.contains(scalar) {
          return result
        }

        result.append(byte)
      }
    }
  }

  public func readToEnd() throws -> Data {
    return try self.read(upToCount: Int.max)
  }

  public func read(upToCount count: Int) throws -> Data {
    guard self !== FileDescriptor._nulldeviceFileDescriptor else {
      return Data()
    }

    return try self._readDataOfLength(count, untilEOF: true)
  }

  // MARK: - Write

  public func write<T: DataProtocol>(contentsOf data: T) throws {
    guard self !== FileDescriptor._nulldeviceFileDescriptor else { return }

    guard self._isValid else { throw Error.fileWriteUnknown }

    for region in data.regions {
      try region.withUnsafeBytes { bytes in
        if let baseAddress = bytes.baseAddress, bytes.any {
          try self._writeBytes(buf: UnsafeRawPointer(baseAddress),
                               length: bytes.count)
        }
      }
    }
  }

  // MARK: - Offset

  public func offset() throws -> UInt64 {
    guard self !== FileDescriptor._nulldeviceFileDescriptor else { return 0 }

    guard self._isValid else { throw Error.fileReadUnknown }

    let offset = lseek(self._fd, 0, SEEK_CUR)
    guard offset >= 0 else { throw _NSErrorWithErrno(errno, reading: true) }
    return UInt64(offset)
  }

  // MARK: - Seek

  @discardableResult
  public func seekToEnd() throws -> UInt64 {
    guard self !== FileDescriptor._nulldeviceFileDescriptor else { return 0 }

    guard self._isValid else { throw Error.fileReadUnknown }

    let offset = lseek(self._fd, 0, SEEK_END)
    guard offset >= 0 else { throw _NSErrorWithErrno(errno, reading: true) }
    return UInt64(offset)
  }

  public func seek(toOffset offset: UInt64) throws {
    guard self !== FileDescriptor._nulldeviceFileDescriptor else { return }

    guard self._isValid else { throw Error.fileReadUnknown }

    guard lseek(self._fd, off_t(offset), SEEK_SET) >= 0 else {
      throw _NSErrorWithErrno(errno, reading: true)
    }
  }

  public func truncate(atOffset offset: UInt64) throws {
    guard self !== FileDescriptor._nulldeviceFileDescriptor else { return }

    guard self._isValid else { throw Error.fileWriteUnknown }

    guard lseek(self._fd, off_t(offset), SEEK_SET) >= 0 else {
      throw _NSErrorWithErrno(errno, reading: false)
    }

    guard ftruncate(self._fd, off_t(offset)) >= 0 else {
      throw _NSErrorWithErrno(errno, reading: false)
    }
  }

  // MARK: - Synchronize

  public func synchronize() throws {
    guard self !== FileDescriptor._nulldeviceFileDescriptor else { return }

    guard fsync(self._fd) >= 0 else {
      throw _NSErrorWithErrno(errno, reading: false)
    }
  }

  // MARK: - Close

  public func close() throws {
    try self._immediatelyClose()
  }

  private func _immediatelyClose() throws {
    guard self !== FileDescriptor._nulldeviceFileDescriptor else { return }
    guard self._isValid else { return }

    guard _close(self._fd) >= 0 else {
      throw _NSErrorWithErrno(errno, reading: true)
    }

    self._fd = -1
  }
}

// MARK: - Standard descriptors

extension FileDescriptor {

  public static let standardInput = FileDescriptor(
    fileDescriptor: STDIN_FILENO,
    closeOnDealloc: false
  )

  public static let standardOutput = FileDescriptor(
    fileDescriptor: STDOUT_FILENO,
    closeOnDealloc: false
  )

  public static let standardError = FileDescriptor(
    fileDescriptor: STDERR_FILENO,
    closeOnDealloc: false
  )

  private static var _nulldeviceFileDescriptor: FileDescriptor = {
    class NullDevice: FileDescriptor {

      override var availableData: Data { return Data() }

      override func readToEnd() throws -> Data { return Data() }
      override func read(upToCount count: Int) throws -> Data { return Data() }
      override func write<T: DataProtocol>(contentsOf data: T) throws {}
      override func offset() throws -> UInt64 { return 0 }
      override func seekToEnd() throws -> UInt64 { return 0 }
      override func seek(toOffset offset: UInt64) throws {}
      override func truncate(atOffset offset: UInt64) throws {}
      override func synchronize() throws {}
      override func close() throws {}

      deinit {}
    }

    return NullDevice(fileDescriptor: -1, closeOnDealloc: false)
  }()

  public static let nullDevice = _nulldeviceFileDescriptor
}

// MARK: - Convenience inits

extension FileDescriptor {

  public convenience init?(forReadingAtPath path: String) {
    self.init(path: path, flags: O_RDONLY, createMode: 0)
  }

  public convenience init?(forWritingAtPath path: String) {
    self.init(path: path, flags: O_WRONLY, createMode: 0)
  }

  public convenience init?(forUpdatingAtPath path: String) {
    self.init(path: path, flags: O_RDWR, createMode: 0)
  }

  public static func _openFileDescriptorForURL(_ url: URL,
                                               flags: Int32,
                                               reading: Bool) throws -> Int32 {
    let fd = url.withUnsafeFileSystemRepresentation { fsRep -> Int32 in
      guard let fsRep = fsRep else { return -1 }
      return _CFOpenFile(fsRep, flags)
    }

    if fd < 0 {
      throw _NSErrorWithErrno(errno, reading: reading, url: url)
    }

    return fd
  }

  public convenience init(forReadingFrom url: URL) throws {
    let fd = try FileDescriptor._openFileDescriptorForURL(url,
                                                          flags: O_RDONLY,
                                                          reading: true)
    self.init(fileDescriptor: fd, closeOnDealloc: true)
  }

  public convenience init(forWritingTo url: URL) throws {
    let fd = try FileDescriptor._openFileDescriptorForURL(url,
                                                          flags: O_WRONLY,
                                                          reading: false)
    self.init(fileDescriptor: fd, closeOnDealloc: true)
  }

  public convenience init(forUpdating url: URL) throws {
    let fd = try FileDescriptor._openFileDescriptorForURL(url,
                                                          flags: O_RDWR,
                                                          reading: false)
    self.init(fileDescriptor: fd, closeOnDealloc: true)
  }
}
