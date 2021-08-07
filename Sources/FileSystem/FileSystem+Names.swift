import Foundation

// swiftlint:disable force_unwrapping

extension FileSystem {

  // MARK: - Basename

  /// Returns the last part of a path.
  public func basename(path: Path) -> String {
    guard let nonEmpty = NonEmptyPath(from: path) else {
      // $ basename ""
      return ""
    }

    // 'Foundation.basename' returns 'UnsafeMutablePointer<Int8>!',
    // so it is safe to unwrap.
    // https://linux.die.net/man/3/basename
    let ptr = self.withMutableFileSystemRepresentation(
      path: nonEmpty,
      body: Foundation.basename
    )!

    return self.string(nullTerminatedWithFileSystemRepresentation: ptr)
  }

  // MARK: - Extname

  /// Returns the file extension of a path.
  public func extname(path: Path) -> String {
    let basename = self.basename(path: path)

    if let dotIndex = basename.lastIndex(of: ".") {
      let substring = basename[dotIndex...]
      return String(substring)
    }

    return ""
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