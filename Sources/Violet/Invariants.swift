import Foundation
import VioletCore
import VioletLexer
import VioletParser
import VioletBytecode
import VioletCompiler
import VioletVM

private var anyFailed = false

/// Check the memory footprint of a given type.
///
/// Technically stride would be better, but the same stride may describe
/// multiple sizes and in this test we are more intrested in the fact
/// that the value has changed and not in the value itself.
private func checkMemorySize<T>(of type: T.Type, expectedSize: Int) {
  let size = MemoryLayout<T>.size
  if size != expectedSize {
    anyFailed = true
    let typeName = String(describing: type)
    print(
      "[Invariant] \(typeName) has size \(size) instead of expected \(expectedSize) " +
      "(although it may be ok, as long as the stride is the same, " +
      "in that case just fix this test)."
    )
  }
}

private func dumpMemory<T>(of value: T) {
  print("\(String(describing: value)) (\(String(describing: T.self)))")
  print("  Size:", MemoryLayout<T>.size)
  print("  Stride:", MemoryLayout<T>.stride)
  print("  Alignment:", MemoryLayout<T>.alignment)

  withUnsafeBytes(of: value) { bufferPtr in
    let address = bufferPtr.baseAddress.map { String(describing: $0) } ?? ""
    print("  Address:", address)
    print("  Data:    ", terminator: "")
    for byte in bufferPtr {
      let hex = String(byte, radix: 16, uppercase: false)
      let hexPad = hex.padding(toLength: 2, withPad: "0", startingAt: 0)
      print(hexPad + " ", terminator: "")
    }
    print()
  }
  print()
}

internal func checkInvariants() {
  // 1 opcode + 1 argument = 2
  checkMemorySize(of: Instruction.self, expectedSize: 2)

  // 2 line + 2 column = 4
  checkMemorySize(of: SourceLocation.self, expectedSize: 4)

  // Token: 17 kind + 1 padding + 4 start + 4 end = 26
  // TokenKind: 16 string payload + 1 tag = 17
  // Tokens are quite big, but we have only 2 or 3 of them at the same time
  // (not a whole array etc.).
  checkMemorySize(of: Token.self, expectedSize: 26)
  checkMemorySize(of: TokenKind.self, expectedSize: 17)

  if anyFailed {
    exit(EXIT_FAILURE)
  }
}
