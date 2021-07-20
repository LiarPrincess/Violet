import Foundation

func withRedirectedStandardOutput(to file: URL, block: () -> Void) {
  freopen(file.path, "w", stdout)
  block()
  fclose(stdout)
}

func trap(_ msg: String) -> Never {
  fatalError(msg)
}

// MARK: - String + case

extension String {

  /// First letter upper
  var pascalCase: String {
    let first = self.first?.uppercased() ?? ""
    return first + self.dropFirst()
  }

  /// First letter lower
  var camelCase: String {
    let first = self.first?.lowercased() ?? ""
    return first + self.dropFirst()
  }
}

// MARK: - Escape Swift keyword

/// https://docs.swift.org/swift-book/ReferenceManual/LexicalStructure.html
private let swiftKeywords = Set<String>([
  "associatedtype", "class", "deinit", "enum", "extension", "fileprivate",
  "func", "import", "init", "inout", "internal", "let", "open", "operator",
  "private", "protocol", "public", "static", "struct", "subscript", "typealias",
  "var,", "break", "case", "continue", "default", "defer", "do", "else",
  "fallthrough", "for", "guard", "if", "in", "repeat", "return", "switch",
  "where", "while", "as", "Any", "catch", "false", "is", "nil", "rethrows",
  "super", "self", "Self", "throw", "throws", "true", "try"
])

func escapeSwiftKeyword(_ name: String) -> String {
  return swiftKeywords.contains(name) ? "`\(name)`" : name
}
