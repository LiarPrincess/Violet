import XCTest
import VioletCore
@testable import VioletCompiler

class SymbolInfoTests: SymbolTableTestCase {

  func test_description_noflags() {
    self.assertDescription(flags: [], description: "[]")
  }

  func test_description_single() {
    self.assertDescription(flags: [.defLocal], description: "[defLocal]")
    self.assertDescription(flags: [.defGlobal], description: "[defGlobal]")
    self.assertDescription(flags: [.defNonlocal], description: "[defNonlocal]")
    self.assertDescription(flags: [.defParam], description: "[defParam]")
    self.assertDescription(flags: [.defImport], description: "[defImport]")
    self.assertDescription(flags: [.defFree], description: "[defFree]")
    self.assertDescription(flags: [.defFreeClass], description: "[defFreeClass]")
    self.assertDescription(flags: [.srcLocal], description: "[srcLocal]")
    self.assertDescription(flags: [.srcGlobalExplicit], description: "[srcGlobalExplicit]")
    self.assertDescription(flags: [.srcGlobalImplicit], description: "[srcGlobalImplicit]")
    self.assertDescription(flags: [.srcFree], description: "[srcFree]")
    self.assertDescription(flags: [.cell], description: "[cell]")
    self.assertDescription(flags: [.use], description: "[use]")
    self.assertDescription(flags: [.annotated], description: "[annotated]")
  }

  func test_description_multiple() {
    let flags: SymbolInfo.Flags = [
      .defLocal,
      .defGlobal,
      .defNonlocal,
      .defParam,
      .defImport,
      .defFree,
      .defFreeClass,
      .srcLocal,
      .srcGlobalExplicit,
      .srcGlobalImplicit,
      .srcFree,
      .cell,
      .use,
      .annotated
    ]

    let description = "[defLocal, defGlobal, defNonlocal, defParam, defImport, " +
      "defFree, defFreeClass, srcLocal, srcGlobalExplicit, srcGlobalImplicit, " +
      "srcFree, cell, use, annotated]"

    self.assertDescription(flags: flags, description: description)
  }

  private func assertDescription(flags: SymbolInfo.Flags,
                                 description: String,
                                 file: StaticString = #file,
                                 line: UInt = #line) {
    let location = SourceLocation(line: 42, column: 43)
    let info = SymbolInfo(flags: flags, location: location)

    let expectedDescr = "SymbolInfo(flags: \(description), location: 42:43)"
    XCTAssertEqual(String(describing: info),
                   expectedDescr,
                   file: file,
                   line: line)
  }
}
