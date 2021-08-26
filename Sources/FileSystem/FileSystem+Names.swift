import Foundation
import VioletCore

extension FileSystem {

  // MARK: - Basename

  /// Returns the last part of a path.
  public func basename(path: Path) -> Filename {
    guard let nonEmpty = NonEmptyPath(from: path) else {
      // $ basename ""
      return Filename(string: "")
    }

    return self.withMutableFileSystemRepresentation(path: nonEmpty) { ptr in
      let resultPtr = LibC.basename(path: ptr)
      let string = self.string(nullTerminatedWithFileSystemRepresentation: resultPtr)
      return Filename(string: string)
    }
  }

  public func basenameWithoutExt(filename: Filename) -> Filename {
    switch self.splitNameAndExt(filename: filename) {
    case .split(name: let name, ext: _):
      return Filename(string: name)
    case .noExt:
      return filename
    }
  }

  public func basenameWithoutExt(path: Path) -> Filename {
    let basename = self.basename(path: path)
    return self.basenameWithoutExt(filename: basename)
  }

  // MARK: - Extname

  /// Returns the file extension of a path.
  public func extname(filename: Filename) -> String {
    switch self.splitNameAndExt(filename: filename) {
    case .split(name: _, ext: let ext):
      return String(ext)
    case .noExt:
      return ""
    }
  }

  /// Returns the file extension of a path.
  public func extname(path: Path) -> String {
    let basename = self.basename(path: path)
    return self.extname(filename: basename)
  }

  private enum NameAndExt {
    case split(name: Substring, ext: Substring)
    case noExt
  }

  private func splitNameAndExt(filename: Filename) -> NameAndExt {
    let s = filename.string

    if s == "." || s == ".." {
      return .noExt
    }

    // We will fail on something like '.tar.gz'.
    if let dotIndex = s.lastIndex(of: ".") {
      let name = s[..<dotIndex]
      let ext = s[dotIndex...]
      return .split(name: name, ext: ext)
    }

    return .noExt
  }

  // MARK: - Add ext

  /// Add extension.
  public func addExt(filename: Filename, ext: String) -> Filename {
    let result = self.addExt(string: filename.string, ext: ext)
    return Filename(string: result)
  }

  /// Add extension.
  public func addExt(path: Path, ext: String) -> Path {
    let result = self.addExt(string: path.string, ext: ext)
    return Path(string: result)
  }

  private func addExt(string: String, ext: String) -> String {
    // We will allow adding extension to '.' and '..'
    // (even if it does not make sense).
    switch ext.hasPrefix(".") {
    case true:
      return string + ext
    case false:
      return string + "." + ext
    }
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

    return self.withMutableFileSystemRepresentation(path: nonEmpty) { ptr in
      let resultPtr = LibC.dirname(path: ptr)
      let string = self.string(nullTerminatedWithFileSystemRepresentation: resultPtr)
      let isTop = string == "." || string == "/"
      let resultPath = Path(string: string)
      return DirnameResult(path: resultPath, isTop: isTop)
    }
  }
}
