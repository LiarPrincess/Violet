import XCTest
import VioletCore
import VioletLexer
import VioletParser
import VioletBytecode
import VioletCompiler

// MARK: - Assert scope

/// Expected symbol
struct ExpectedSymbol {
  let name: String
  let flags: SymbolInfo.Flags
  let location: SourceLocation?

  // We need custom `init` to make `location` optional parameter.
  init(name: String, flags: SymbolInfo.Flags, location: SourceLocation? = nil) {
    self.name = name
    self.flags = flags
    self.location = location
  }
}

struct ScopeFlags: OptionSet {
  let rawValue: UInt16

  static let isNested = ScopeFlags(rawValue: 1 << 0)
  static let isGenerator = ScopeFlags(rawValue: 1 << 3)
  static let isCoroutine = ScopeFlags(rawValue: 1 << 4)
  static let hasVarargs = ScopeFlags(rawValue: 1 << 5)
  static let hasVarKeywords = ScopeFlags(rawValue: 1 << 6)
  static let hasReturnValue = ScopeFlags(rawValue: 1 << 7)
  static let needsClassClosure = ScopeFlags(rawValue: 1 << 8)
}

// swiftlint:disable:next function_parameter_count
func XCTAssertScope(_ scope: SymbolScope,
                    name: String,
                    kind: SymbolScope.Kind,
                    flags: ScopeFlags,
                    symbols: [ExpectedSymbol],
                    parameters: [String],
                    childrenCount: Int,
                    file: StaticString = #file,
                    line: UInt = #line) {
  XCTAssertEqual(scope.name, name, "Name", file: file, line: line)
  XCTAssertEqual(scope.kind, kind, "Kind", file: file, line: line)

  assertFlags(scope, expected: flags, file: file, line: line)
  assertSymbols(scope, expected: symbols, file: file, line: line)
  assertParameters(scope, expected: parameters, file: file, line: line)

  XCTAssertEqual(scope.children.count,
                 childrenCount,
                 "Children count",
                 file: file,
                 line: line)
}

// MARK: - Flags

private func assertFlags(_ scope: SymbolScope,
                         expected: ScopeFlags,
                         file: StaticString,
                         line: UInt) {
  func assertFlag(_ path: KeyPath<SymbolScope, Bool>,
                  _ flag: ScopeFlags,
                  name: String) {
    let hasFlag = scope[keyPath: path]
    let expectsFlag = expected.contains(flag)
    XCTAssertEqual(hasFlag,
                   expectsFlag,
                   "\(name) flag",
                   file: file,
                   line: line)
  }

  assertFlag(\.isNested, .isNested, name: "isNested")
  assertFlag(\.isGenerator, .isGenerator, name: "isGenerator")
  assertFlag(\.isCoroutine, .isCoroutine, name: "isCoroutine")
  assertFlag(\.hasVarargs, .hasVarargs, name: "hasVarargs")
  assertFlag(\.hasVarKeywords, .hasVarKeywords, name: "hasVarKeywords")
  assertFlag(\.hasReturnValue, .hasReturnValue, name: "hasReturnValue")
  assertFlag(\.needsClassClosure, .needsClassClosure, name: "needsClassClosure")
}

// MARK: - Symbols

// swiftlint:disable:next function_body_length
private func assertSymbols(_ scope: SymbolScope,
                           expected: [ExpectedSymbol],
                           file: StaticString,
                           line: UInt) {
  XCTAssertEqual(scope.symbols.count,
                 expected.count,
                 "Symbol count",
                 file: file,
                 line: line)

  for (index, ((name, info), expected)) in zip(scope.symbols, expected).enumerated() {
    XCTAssertEqual(name.value,
                   expected.name,
                   "Symbol \(index) - name",
                   file: file,
                   line: line)

    func assertFlag(_ flag: SymbolInfo.Flags, name: String) {
      let hasFlag = info.flags.contains(flag)
      let expectsFlag = expected.flags.contains(flag)
      XCTAssertEqual(hasFlag,
                     expectsFlag,
                     "Symbol \(index) - \(name) flag",
                     file: file,
                     line: line)
    }

    assertFlag(.defLocal, name: "defLocal")
    assertFlag(.defGlobal, name: "defGlobal")
    assertFlag(.defNonlocal, name: "defNonlocal")
    assertFlag(.defParam, name: "defParam")
    assertFlag(.defImport, name: "defImport")
    assertFlag(.defFree, name: "defFree")
    assertFlag(.defFreeClass, name: "defFreeClass")
    assertFlag(.srcLocal, name: "srcLocal")
    assertFlag(.srcGlobalExplicit, name: "srcGlobalExplicit")
    assertFlag(.srcGlobalImplicit, name: "srcGlobalImplicit")
    assertFlag(.srcFree, name: "srcFree")
    assertFlag(.cell, name: "cell")
    assertFlag(.use, name: "use")
    assertFlag(.annotated, name: "annotated")

    if let expectedLocation = expected.location {
      XCTAssertEqual(info.location,
                     expectedLocation,
                     "Symbol \(index) - location",
                     file: file,
                     line: line)
    }
  }
}

// MARK: - Parameters

private func assertParameters(_ scope: SymbolScope,
                              expected: [String],
                              file: StaticString,
                              line: UInt) {
  XCTAssertEqual(scope.parameterNames.count,
                 expected.count,
                 "Parameter count",
                 file: file,
                 line: line)

  for (index, (n, expected)) in zip(scope.parameterNames, expected).enumerated() {
    XCTAssertEqual(n.value,
                   expected,
                   "Parameter \(index)",
                   file: file,
                   line: line)
  }
}
