import Foundation
import VioletObjects

/// Adapter between `FileDescriptor` and `FileDescriptorType`.
///
/// Basically it will call a method on provided `FileDescriptor`
/// and then in case of exception it will convert it to Python error.
internal struct FileDescriptorAdapter:
  CustomStringConvertible, FileDescriptorType {

  private let fd: FileDescriptor
  /// Path for error messages
  private let path: String?

  internal var description: String {
    return self.fd.description
  }

  internal init(fd: FileDescriptor, path: String?) {
    self.fd = fd
    self.path = path
  }

  // MARK: - Raw

  internal var raw: Int32 {
    return self.fd.raw
  }

  // MARK: - Read

  internal func readLine() -> PyResult<Data> {
    do {
      let data = try self.fd.readLine()
      return .value(data)
    } catch {
      let e = self.osError(from: error)
      return .error(e)
    }
  }

  internal func readToEnd() -> PyResult<Data> {
    do {
      let data = try self.fd.readToEnd()
      return .value(data)
    } catch {
      let e = self.osError(from: error)
      return .error(e)
    }
  }

  internal func read(upToCount count: Int) -> PyResult<Data> {
    do {
      let data = try self.fd.read(upToCount: count)
      return .value(data)
    } catch {
      let e = self.osError(from: error)
      return .error(e)
    }
  }

  // MARK: - Write

  internal func write<T: DataProtocol>(contentsOf data: T) -> PyResult<PyNone> {
    do {
      try self.fd.write(contentsOf: data)
      return .value(Py.none)
    } catch {
      let e = self.osError(from: error)
      return .error(e)
    }
  }

  // MARK: - Flush

  internal func flush() -> PyResult<PyNone> {
    do {
      try self.fd.synchronize()
      return .value(Py.none)
    } catch {
      let e = self.osError(from: error)
      return .error(e)
    }
  }

  // MARK: - Offset

  internal func offset() -> PyResult<UInt64> {
    do {
      let result = try self.fd.offset()
      return .value(result)
    } catch {
      let e = self.osError(from: error)
      return .error(e)
    }
  }

  // MARK: - Seek

  internal func seekToEnd() -> PyResult<UInt64> {
    do {
      let result = try self.fd.seekToEnd()
      return .value(result)
    } catch {
      let e = self.osError(from: error)
      return .error(e)
    }
  }

  internal func seek(toOffset offset: UInt64) -> PyResult<PyNone> {
    do {
      try self.fd.seek(toOffset: offset)
      return .value(Py.none)
    } catch {
      let e = self.osError(from: error)
      return .error(e)
    }
  }

  // MARK: - Close

  internal func close() -> PyResult<PyNone> {
    do {
      try self.fd.close()
      return .value(Py.none)
    } catch {
      let e = self.osError(from: error)
      return .error(e)
    }
  }

  // MARK: - Error

  private func osError(from error: Error) -> PyBaseException {
    if let descriptorError = error as? FileDescriptor.Error {
      let errno = descriptorError.errno
      if let p = self.path {
        return Py.newOSError(errno: errno, path: p)
      }

      return Py.newOSError(errno: errno)
    }

    var msg = "unknown IO error"
    if let p = self.path {
      msg.append(" (file: \(p))")
    }

    return Py.newOSError(msg: msg)
  }
}
