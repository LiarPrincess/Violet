extension FileSystem {

  /// Joins all given `path` segments together using the platform-specific
  /// separator as a delimiter.
  public func join(path: Path, element: PathPartConvertible) -> Path {
    var copy = path
    self.join(path: &copy, element: element)
    return copy
  }

  /// Joins all given `path` segments together using the platform-specific
  /// separator as a delimiter.
  public func join(path: Path, elements: PathPartConvertible...) -> Path {
    var copy = path

    for e in elements {
      self.join(path: &copy, element: e)
    }

    return copy
  }

  /// Joins all given `path` segments together using the platform-specific
  /// separator as a delimiter.
  public func join<S: Sequence>(
    path: Path,
    elements: S
  ) -> Path where S.Element: PathPartConvertible {
    var copy = path

    for e in elements {
      self.join(path: &copy, element: e)
    }

    return copy
  }

  private func join(path: inout Path, element: PathPartConvertible) {
    let part = element.pathPart

    if part.isEmpty {
      return
    }

    // Is 'path' empty?
    guard let last = path.string.last else {
      path = Path(string: part)
      return
    }

    if !self.isPathSeparator(char: last) {
      // We will do this even if 'component' (or 'result') is empty.
      path.string.append(pathSeparators[0])
    }

    path.string.append(part)
  }
}
