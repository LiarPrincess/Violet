struct Doc {

  private let lines: [String]

  init(lines: [String]) {
    var selfLines = [String]()

    for line in lines {
      switch line.isEmpty {
      case true:
        selfLines.append("")
      case false:
        // Lines can contain '\n' to denote new line
        let split = line
          .replacingOccurrences(of: "\\n", with: "\n")
          .split(separator: "\n", omittingEmptySubsequences: false)
          .map(String.init)
        selfLines.append(contentsOf: split)
      }
    }

    self.lines = selfLines
  }

  func formatForPrintingInSwift(indent: String) -> String {
    var result = ""

    for (index, line) in self.lines.enumerated() {
      let spaceAfterSlash = line.isEmpty ? "" : " "
      result += indent + "///" + spaceAfterSlash + line

      let isLast = index == self.lines.count - 1
      if !isLast {
        result += "\n"
      }
    }

    return result
  }

  func formatForPrintingInMarkdownTable(indent: String) -> String {
    var result = ""

    for (index, line) in self.lines.enumerated() {
      result += indent + line

      let isLast = index == self.lines.count - 1
      if !isLast {
        result += "<br/>"
      }
    }

    return result
  }
}
