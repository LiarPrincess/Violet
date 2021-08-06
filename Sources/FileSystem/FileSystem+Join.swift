extension FileSystem {

  public func join(path: Path, element: String) -> Path {
    return self.join(path: path, elements: [element])
  }

  public func join(path: Path, elements: String...) -> Path {
    let array = Array(elements)
    return self.join(path: path, elements: array)
  }

  public func join(path: Path, elements: [String]) -> Path {
    var result = path.string

    for component in elements {
      if component.isEmpty {
        continue
      }

      // Is result empty?
      guard let last = result.last else {
        result = component
        continue
      }

      if !self.isPathSeparator(char: last) {
        // We will do this even if 'component' (or 'result') is empty.
        result.append(pathSeparators[0])
      }

      result.append(component)
    }

    return Path(string: result)
  }
}
