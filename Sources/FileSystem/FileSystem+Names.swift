import Foundation

// swiftlint:disable force_unwrapping

extension FileSystem {

  // MARK: - Basename

  /// Returns the last part of a path.
  public func basename(path: Path) -> Filename {
    guard let nonEmpty = NonEmptyPath(from: path) else {
      // $ basename ""
      return Filename(string: "")
    }

    // 'Foundation.basename' returns 'UnsafeMutablePointer<Int8>!',
    // so it is safe to unwrap.
    // https://linux.die.net/man/3/basename
    let ptr = self.withMutableFileSystemRepresentation(
      path: nonEmpty,
      body: Foundation.basename
    )!

    let string = self.string(nullTerminatedWithFileSystemRepresentation: ptr)
    return Filename(string: string)
  }

  // MARK: - Extname

  /// Returns the file extension of a path.
  public func extname(filename: Filename) -> String {
    let s = filename.string

    if let dotIndex = s.lastIndex(of: ".") {
      let substring = s[dotIndex...]
      return String(substring)
    }

    return ""
  }

  /// Returns the file extension of a path.
  public func extname(path: Path) -> String {
    let basename = self.basename(path: path)
    return self.extname(filename: basename)
  }

  // MARK: - Dirname

  public struct DirnameResult {

    public let path: Path
    /// Is file system or local root.
    ///
    /// Calling `dirname` again will return the same result.
    public let isTop: Bool

    fileprivate init(path: Path, isTop: Bool) {
      self.path = path
      self.isTop = isTop
    }
  }

  /// Returns the directories of a path.
  public func dirname(path: Path) -> DirnameResult {
    guard let nonEmpty = NonEmptyPath(from: path) else {
      // $ dirname ""
      let resultPath = Path(string: ".")
      return DirnameResult(path: resultPath, isTop: true)
    }

    // 'Foundation.dirname' returns 'UnsafeMutablePointer<Int8>!',
    // so it is safe to unwrap.
    // https://linux.die.net/man/1/dirname
    let ptr = self.withMutableFileSystemRepresentation(
      path: nonEmpty,
      body: Foundation.dirname
    )!

    let string = self.string(nullTerminatedWithFileSystemRepresentation: ptr)
    let isTop = string == "." || string == "/"
    let resultPath = Path(string: string)
    return DirnameResult(path: resultPath, isTop: isTop)
  }
}
