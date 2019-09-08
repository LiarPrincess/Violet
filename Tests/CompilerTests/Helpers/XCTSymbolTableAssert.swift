import XCTest
import Core
import Lexer
import Parser
import Bytecode
import Compiler

// swiftlint:disable multiline_arguments

internal func XCTAssertContainsSymbol(_ scope: SymbolScope,
                                      name: String,
                                      flags: SymbolFlags,
                                      location: SourceLocation? = nil,
                                      _ message:  String = "",
                                      file: StaticString = #file,
                                      line: UInt         = #line) {
  let mangled = MangledName(from: name)

  XCTAssertNotNil(scope.symbols[mangled],
                  "\(message) (symbol is not present)",
                  file: file, line: line)

  guard let info = scope.symbols[mangled] else { return }

  if let loc = location {
    XCTAssertEqual(info.location,
                   loc,
                   "\(message) (invalid location)",
                   file: file,
                   line: line)
  }

  if info.flags == flags {
    return
  }

  // Enumerate flags to print invalid ones
  let maxShift = 16
  for shift in 0..<maxShift {
    let f = SymbolFlags(rawValue: 1 << shift)
    let contains = info.flags.contains(f)
    let shouldContain = flags.contains(f)

    let additionalMissing = contains ? "unexpected" : "missing"

    XCTAssertEqual(contains,
                   shouldContain,
                   "\(message) (\(additionalMissing) flag: 1<<\(shift))",
                   file: file, line: line)
  }
}

internal func XCTAssertContainsParameter(_ scope: SymbolScope,
                                         name: String,
                                         _ message:  String = "",
                                         file: StaticString = #file,
                                         line: UInt         = #line) {
  let mangled = MangledName(from: name)
  XCTAssertTrue(scope.varNames.contains(mangled),
                "\(message) (missing \(name))",
                file: file, line: line)
}

internal struct ScopeFeatures: OptionSet {
  let rawValue: UInt16

  static let isNested          = ScopeFeatures(rawValue: 1 << 0)
  static let isGenerator       = ScopeFeatures(rawValue: 1 << 3)
  static let isCoroutine       = ScopeFeatures(rawValue: 1 << 4)
  static let hasVarargs        = ScopeFeatures(rawValue: 1 << 5)
  static let hasVarKeywords    = ScopeFeatures(rawValue: 1 << 6)
  static let hasReturnValue    = ScopeFeatures(rawValue: 1 << 7)
  static let needsClassClosure = ScopeFeatures(rawValue: 1 << 8)
}

internal func XCTAssertScope(_ scope: SymbolScope,
                             name: String,
                             type: ScopeType,
                             flags: ScopeFeatures,
                             _ message:  String = "",
                             file: StaticString = #file,
                             line: UInt         = #line) {

  XCTAssertEqual(scope.name, name, message, file: file, line: line)
  XCTAssertEqual(scope.type, type, message, file: file, line: line)

  XCTAssertEqual(scope.isNested, flags.contains(.isNested),
                 "\(message) (isNested)", file: file, line: line)

  XCTAssertEqual(scope.isGenerator, flags.contains(.isGenerator),
                 "\(message) (isGenerator)", file: file, line: line)

  XCTAssertEqual(scope.isCoroutine, flags.contains(.isCoroutine),
                 "\(message) (isCoroutine)", file: file, line: line)

  XCTAssertEqual(scope.hasVarargs, flags.contains(.hasVarargs),
                 "\(message) (hasVarargs)", file: file, line: line)

  XCTAssertEqual(scope.hasVarKeywords, flags.contains(.hasVarKeywords),
                 "\(message) (hasVarKeywords)", file: file, line: line)

  XCTAssertEqual(scope.hasReturnValue, flags.contains(.hasReturnValue),
                 "\(message) (hasReturnValue)", file: file, line: line)

  XCTAssertEqual(scope.needsClassClosure, flags.contains(.needsClassClosure),
                 "\(message) (needsClassClosure)", file: file, line: line)
}
