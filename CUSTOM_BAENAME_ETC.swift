import Foundation

#if os(Windows)
let pathSeparators: [Character] = ["/", "\\"]
#else
let pathSeparators: [Character] = ["/"]
#endif

internal class Dummy {

  private let fileManager: FileManager

  internal init(fileManager: FileManager) {
    self.fileManager = fileManager
  }





  // MARK: - Basename

  /// Foundation.NSURL.lastPathComponent
  internal func basename(path: String) -> String {
    if path == "/" {
      return "/"
    }

    /// Walk the path from the end until a path separator is encountered.
    /// Returns index AFTER this.
    let path = self.removeLastSlash(path: path)
    var basenameStartIndex = path.endIndex

    while basenameStartIndex != path.startIndex {
      let previous = path.index(before: basenameStartIndex)
      if self.isPathSeparator(char: path[previous]) {
        break
      }

      basenameStartIndex = previous
    }

    // If the '/' was not found then: basenameStartIndex = path.startIndex
    return String(path[basenameStartIndex...])
  }





  // MARK: - Dirname

  internal func dirname(path: String) -> String {
    if path == "/" {
      return "/"
    }

    if path.isEmpty || path == "." || path == ".." {
      return "."
    }

    /// Walk the path from the end until a path separator is encountered.
    let path = self.removeLastSlash(path: path)
    var separatorIndex = path.index(before: path.endIndex)

    while separatorIndex != path.startIndex {
      if self.isPathSeparator(char: path[separatorIndex]) {
        break
      }

      path.formIndex(before: &separatorIndex)
    }

    // We need to also check start
    if separatorIndex == path.startIndex {
      // Something like: '/elsa'
      if self.isPathSeparator(char: path[separatorIndex]) {
        return "/"
      }

      // Something like 'elsa'
      return "."
    }

    let result = String(path[..<separatorIndex])
    assert(!result.isEmpty, "We checked: 'separatorIndex == path.startIndex'")
    assert(result != "." && result != "/") // TODO: ./elsa -> gives us '.'
    return result
  }






  // MARK: - Join

  // MARK: - Helpers

}
