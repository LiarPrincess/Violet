import Foundation

// cSpell:ignore Anakin Padmé

#if DEBUG

/// Don't bother reading this, it will never be called.
///
/// - Anakin: This is an `unreachable` function.
/// - Padmé: It will never be called?
/// - Anakin: (gazes in silence)
/// - Padmé: It will never be called, right?
public func unreachable(file: StaticString = #file,
                        function: StaticString = #function,
                        line: Int = #line) -> Never {
  var fileShort = String(describing: file)

  if let range = fileShort.range(of: "Sources/") {
    let startIndex = range.lowerBound
    fileShort = String(fileShort[startIndex...])
  }

  if let range = fileShort.range(of: "Tests/") {
    let startIndex = range.lowerBound
    fileShort = String(fileShort[startIndex...])
  }

  // https://knowyourmeme.com/memes/it-was-me-dio
  let msg = "You expected unreachable, but it me '\(fileShort):\(line)'!"
  trap(msg, file: file, function: function, line: line)
}

#else

public func unreachable() -> Never {
  exit(1)
}

#endif
