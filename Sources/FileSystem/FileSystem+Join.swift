extension FileSystem {

  public func join(path: Path, element: Path) -> Path {
    return self.join(path: path, element: element.string)
  }

  public func join(path: Path, element: Filename) -> Path {
    return self.join(path: path, element: element.string)
  }

  public func join(path: Path, element: String) -> Path {
    var copy = path
    self.join(path: &copy, element: element)
    return copy
  }

  public func join(path: Path, elements: String...) -> Path {
    var copy = path

    for e in elements {
      self.join(path: &copy, element: e)
    }

    return copy
  }

  public func join<S: Sequence>(
    path: Path,
    elements: S
  ) -> Path where S.Element == String {
    var copy = path

    for e in elements {
      self.join(path: &copy, element: e)
    }

    return copy
  }

  private func join(path: inout Path, element: String) {
    if element.isEmpty {
      return
    }

    // Is 'path' empty?
    guard let last = path.string.last else {
      path = Path(string: element)
      return
    }

    if !self.isPathSeparator(char: last) {
      // We will do this even if 'component' (or 'result') is empty.
      path.string.append(pathSeparators[0])
    }

    path.string.append(element)
  }
}
