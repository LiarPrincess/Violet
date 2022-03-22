import Foundation
import FileSystem
import VioletObjects

/// Adapter between `FileDescriptor` and `FileDescriptorType`.
///
/// Basically it will call a method on provided `FileDescriptor`
/// and then in case of exception it will convert it to Python error.
internal struct FileDescriptorAdapter: CustomStringConvertible, FileDescriptorType {

  /// File descriptors are `Py` specic (you can't use the same adapter in multiple
  /// contexts), so we may as well store `py` reference.
  private let py: Py
  private let fd: FileDescriptor
  /// Path for error messages
  private let path: String?

  internal var description: String {
    return self.fd.description
  }

  internal init(_ py: Py, fd: FileDescriptor, path: String?) {
    self.py = py
    self.fd = fd
    self.path = path
  }

  // MARK: - Raw

  internal var raw: Int32 {
    return self.fd.raw
  }

  // MARK: - Read

  internal func readLine() -> PyResultGen<Data> {
    do {
      let data = try self.fd.readLine()
      return .value(data)
    } catch {
      return self.toOSError(error)
    }
  }

  internal func readToEnd() -> PyResultGen<Data> {
    do {
      let data = try self.fd.readToEnd()
      return .value(data)
    } catch {
      return self.toOSError(error)
    }
  }

  internal func read(upToCount count: Int) -> PyResultGen<Data> {
    do {
      let data = try self.fd.read(upToCount: count)
      return .value(data)
    } catch {
      return self.toOSError(error)
    }
  }

  // MARK: - Write

  internal func write<T: DataProtocol>(contentsOf data: T) -> PyBaseException? {
    do {
      try self.fd.write(contentsOf: data)
      return nil
    } catch {
      return self.toOSError(error)
    }
  }

  // MARK: - Flush

  internal func flush() -> PyBaseException? {
    do {
      try self.fd.synchronize()
      return nil
    } catch {
      return self.toOSError(error)
    }
  }

  // MARK: - Offset

  internal func offset() -> PyResultGen<UInt64> {
    do {
      let result = try self.fd.offset()
      return .value(result)
    } catch {
      return self.toOSError(error)
    }
  }

  // MARK: - Seek

  internal func seekToEnd() -> PyResultGen<UInt64> {
    do {
      let result = try self.fd.seekToEnd()
      return .value(result)
    } catch {
      return self.toOSError(error)
    }
  }

  internal func seek(toOffset offset: UInt64) -> PyBaseException? {
    do {
      try self.fd.seek(toOffset: offset)
      return nil
    } catch {
      return self.toOSError(error)
    }
  }

  // MARK: - Close

  internal func close() -> PyBaseException? {
    do {
      try self.fd.close()
      return nil
    } catch {
      return self.toOSError(error)
    }
  }

  // MARK: - Error

  private func toOSError<T>(_ error: Error) -> PyResultGen<T> {
    let osError: PyBaseException = self.toOSError(error)
    return .error(osError)
  }

  private func toOSError(_ error: Error) -> PyBaseException {
    if let descriptorError = error as? FileDescriptor.Error {
      let errno = descriptorError.errno
      if let p = self.path {
        let error = self.py.newOSError(errno: errno, path: p)
        return error.asBaseException
      }

      let error = self.py.newOSError(errno: errno)
      return error.asBaseException
    }

    var message = "unknown IO error"
    if let p = self.path {
      message.append(" (file: \(p))")
    }

    let error = self.py.newOSError(message: message)
    return error.asBaseException
  }
}
