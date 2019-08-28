import Foundation
import Core
import Lexer
import Parser
import Bytecode

/// Check the memory footprint of a given type.
///
/// Technically stride would be better, but the same stride may describe
/// multiple sizes and in this test we are more intrested in the fact
/// that the value has changed and not in the value itself.
private func checkMemorySize<T>(of type: T.Type, expectedSize: Int) {
  let size = MemoryLayout<T>.size
  if size != expectedSize {
    let typeName = String(describing: type)
    fatalError(
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

private func checkInvariants() {
  // 1 opcode + 1 argument = 2
  checkMemorySize(of: Instruction.self, expectedSize: 2)

  // 2 line + 2 column = 4
  checkMemorySize(of: SourceLocation.self, expectedSize: 4)

  // 17 kind + 1 padding + 4 start + 4 end = 25
  // kind: 16 string payload + 1 tag = 17
  checkMemorySize(of: Token.self, expectedSize: 26)
  checkMemorySize(of: TokenKind.self, expectedSize: 17)

  // 8 id + 24 kind + 4 start + 4 end = 40
  // Kind has the same size as 'Expression' which is 24 (stmt array is only 8)
  // Tag is stored in (otherwise unused) ExpressionKind high bytes
  checkMemorySize(of: AST.self, expectedSize: 40)
  checkMemorySize(of: ASTKind.self, expectedSize: 24)

  // Use this to check (remember that x86 is little-endian):
  //  let expr = Expression(id: NodeId(value: 0xfaaa_faaa_faaa_faaa),
  //                        kind: .ellipsis,
  //                        start: SourceLocation(line: 0xfbbb, column: 0xfccc),
  //                        end:   SourceLocation(line: 0xfddd, column: 0xfeee))
  //  dumpMemory(of: ASTKind.expression(expr))

  // 8 id + 8 kind + 4 start + 4 end = 24
  checkMemorySize(of: Expression.self, expectedSize: 24)
  checkMemorySize(of: ExpressionKind.self, expectedSize: 8)

  // TODO: StatementKind has size of 234 bytes!
  checkMemorySize(of: Statement.self, expectedSize: 234)
  checkMemorySize(of: StatementKind.self, expectedSize: 217)
}

checkInvariants()
