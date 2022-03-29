import Foundation

// swiftlint:disable force_unwrapping
// swiftlint:disable implicitly_unwrapped_optional

#if canImport(Darwin)
import Darwin
internal typealias DIR = UnsafeMutablePointer<Foundation.DIR>
#elseif canImport(Glibc)
import Glibc
internal typealias DIR = OpaquePointer
#endif

private let slash: Int8 = 0x2f

/// Syscalls etc.
///
/// Tiny wrapper to make them feel more 'Swift-like'.
internal enum LibC {

  // MARK: - strlen

  /// https://linux.die.net/man/3/strlen
  internal static func strlen(str: UnsafePointer<Int8>) -> Int {
    return Foundation.strlen(str)
  }

  // MARK: - basename

  /// https://linux.die.net/man/3/basename
  internal static func basename(
    path: UnsafeMutablePointer<Int8>!
  ) -> UnsafeMutablePointer<Int8> {
    // On Linux 'Foundation.basename' does not exist, so we have to write it.
    // But if you really want to use it, then:
    // 'Foundation.basename' returns 'UnsafeMutablePointer<Int8>!',
    // so it is safe to unwrap.
    // return Foundation.basename(path)!

    // Assuming null-termination.
    var len = Foundation.strlen(path)
    if len == 0 {
      return path
    }

    // Remove trailing '/'.
    var indexBeforeLen = len - 1
    if indexBeforeLen >= 0 && path[indexBeforeLen] == slash {
      while indexBeforeLen >= 0, path[indexBeforeLen] == slash {
        indexBeforeLen -= 1
        len -= 1
      }

      let everythingWasSlash = len == 0
      if everythingWasSlash {
        path[1] = 0
        return path
      }

      path[len] = 0
    }

    // Go back to previous '/' and return string from there:
    // char *p = strrchr (filename, '/');
    // return p ? p + 1 : (char *) filename;

    var lastSlashIndex = len - 1
    while lastSlashIndex >= 0, path[lastSlashIndex] != slash {
      lastSlashIndex -= 1
    }

    let noSlash = lastSlashIndex == -1
    return noSlash ? path : path.advanced(by: lastSlashIndex + 1)
  }

  // MARK: - dirname

  /// https://linux.die.net/man/1/dirname
  internal static func dirname(
    path: UnsafeMutablePointer<Int8>!
  ) -> UnsafeMutablePointer<Int8> {
    // Both dirname() and basename() return pointers to null-terminated strings.
    // (Do not pass these pointers to free(3).)

    #if canImport(Darwin)
    // 'Foundation.dirname' returns 'UnsafeMutablePointer<Int8>!',
    // so it is safe to unwrap.
    return Foundation.dirname(path)!
    #elseif canImport(Glibc)
    // '//frozen' will return '//', but we want '/'.
    let result = Foundation.dirname(path)!

    var index = 0
    while true {
      let ch = result[index]

      switch ch {
      case 0:
        switch index {
        case 0:
          // Empty string?
          return result
        case 1:
          // Single '/'.
          return result
        default:
          // Multiple '/' in a row.
          result[1] = 0
          return result
        }

      case slash:
        index += 1

      default:
        // Non-slash -> not our special case.
        return result
      }
    }
    #endif
  }

  // MARK: - creat

  internal enum CreatResult {
    case value(Int32)
    case errno(Int32)
  }

  /// https://linux.die.net/man/2/creat
  internal static func creat(path: UnsafePointer<Int8>!,
                             mode: mode_t) -> CreatResult {
    // open() and creat() return the new file descriptor,
    // or -1 if an error occurred (in which case, errno is set appropriately).
    switch Foundation.creat(path, mode) {
    case -1:
      let err = Foundation.errno
      Foundation.errno = 0
      return .value(err)
    case let fd:
      return .value(fd)
    }
  }

  // MARK: - stat

  internal static func createStat() -> stat {
    return Foundation.stat()
  }

  internal enum StatResult {
    case ok
    case errno(Int32)

    fileprivate init(returnValue: Int32) {
      // On success, zero is returned.
      // On error, -1 is returned, and errno is set appropriately.
      if returnValue == 0 {
        self = .ok
        return
      }

      assert(returnValue == -1)

      let err = Foundation.errno
      Foundation.errno = 0
      self = .errno(err)
    }
  }

  /// https://linux.die.net/man/2/fstat
  internal static func fstat(fd: Int32,
                             buf: UnsafeMutablePointer<stat>!) -> StatResult {
    let returnValue = Foundation.fstat(fd, buf)
    return StatResult(returnValue: returnValue)
  }

  /// https://linux.die.net/man/2/lstat
  internal static func lstat(path: UnsafePointer<Int8>!,
                             buf: UnsafeMutablePointer<stat>!) -> StatResult {
    let returnValue = Foundation.lstat(path, buf)
    return StatResult(returnValue: returnValue)
  }

  // MARK: - opendir

  internal enum OpendirResult {
    case value(DIR)
    case errno(Int32)

    fileprivate init(returnValue: DIR?) {
      // The opendir() and fdopendir() functions return a pointer to the directory
      // stream. On error, NULL is returned, and errno is set appropriately.

      if let dirp = returnValue {
        self = .value(dirp)
        return
      }

      let err = Foundation.errno
      Foundation.errno = 0
      self = .errno(err)
    }
  }

  /// https://linux.die.net/man/3/fdopendir
  internal static func fdopendir(fd: Int32) -> OpendirResult {
    let returnValue = Foundation.fdopendir(fd)
    return OpendirResult(returnValue: returnValue)
  }

  /// https://linux.die.net/man/3/opendir
  internal static func opendir(name: UnsafePointer<Int8>!) -> OpendirResult {
    let returnValue = Foundation.opendir(name)
    return OpendirResult(returnValue: returnValue)
  }

  // MARK: - mkdir

  internal enum MkdirResult {
    case ok
    case errno(Int32)
  }

  /// https://linux.die.net/man/2/mkdir
  internal static func mkdir(path: UnsafePointer<Int8>!,
                             mode: mode_t) -> MkdirResult {
    // mkdir() returns zero on success, or -1 if an error occurred
    // (in which case, errno is set appropriately).

    let returnValue = Foundation.mkdir(path, mode)
    if returnValue == 0 {
      return .ok
    }

    let err = Foundation.errno
    Foundation.errno = 0
    return .errno(err)
  }

  // MARK: - readdir_r

  internal static func createDirent() -> dirent {
    return dirent()
  }

  internal enum ReaddirResult {
    case entryWasUpdated
    case noMoreEntries
    case errno(Int32)
  }

  /// https://linux.die.net/man/3/readdir_r
  internal static func readdir_r(
    dirp: DIR,
    entry: UnsafeMutablePointer<dirent>!,
    result: UnsafeMutablePointer<UnsafeMutablePointer<dirent>?>!
  ) -> ReaddirResult {
    // The readdir_r() function returns 0 on success.
    // On error, it returns a positive error number (listed under ERRORS).
    // If the end of the directory stream is reached, readdir_r() returns 0,
    // and returns NULL in *result.

    let errno = Foundation.readdir_r(dirp, entry, result)
    guard errno == 0 else {
      return .errno(errno)
    }

    let isResultNil = result?.pointee == nil
    if isResultNil {
      return .noMoreEntries
    }

    return .entryWasUpdated
  }

  // MARK: - closedir

  internal enum ClosedirResult {
    case ok
    case errno(Int32)
  }

  /// https://linux.die.net/man/3/closedir
  internal static func closedir(dirp: DIR) -> ClosedirResult {
    // The closedir() function returns 0 on success. On error, -1 is returned,
    // and errno is set appropriately.

    let returnValue = Foundation.closedir(dirp)
    if returnValue == 0 {
      return .ok
    }

    assert(returnValue == -1)

    // Should not happen, the only possible thing is:
    // EBADF - Invalid directory stream descriptor dirp.
    let err = Foundation.errno
    Foundation.errno = 0
    return .errno(err)
  }
}
