import SwiftSyntax
import XCTest
@testable import LibAriel

// For soem reason if we use 'LibAriel.Protocol' as return type we get
// "Cannot find type 'LibAriel' in scope".
typealias LibArielProtocol = ProtocolAliasBecauseOtherwiseItFailsToCompileTests

enum Parser {

  // MARK: - Single declaration

  static func enumeration(source: String,
                          file: StaticString = #file,
                          line: UInt = #line) -> Enumeration? {
    return Self.singleDeclaration(source: source,
                                  type: Enumeration.self,
                                  file: file,
                                  line: line)
  }

  static func structure(source: String,
                        file: StaticString = #file,
                        line: UInt = #line) -> Structure? {
    return Self.singleDeclaration(source: source,
                                  type: Structure.self,
                                  file: file,
                                  line: line)
  }

  static func `class`(source: String,
                      file: StaticString = #file,
                      line: UInt = #line) -> Class? {
    return Self.singleDeclaration(source: source,
                                  type: Class.self,
                                  file: file,
                                  line: line)
  }

  static func `protocol`(source: String,
                         file: StaticString = #file,
                         line: UInt = #line) -> LibArielProtocol? {
    return Self.singleDeclaration(source: source,
                                  type: LibAriel.Protocol.self,
                                  file: file,
                                  line: line)
  }

  static func `associatedtype`(source: String,
                               file: StaticString = #file,
                               line: UInt = #line) -> AssociatedType? {
    return Self.singleDeclaration(source: source,
                                  type: AssociatedType.self,
                                  file: file,
                                  line: line)
  }

  static func `typealias`(source: String,
                          file: StaticString = #file,
                          line: UInt = #line) -> Typealias? {
    return Self.singleDeclaration(source: source,
                                  type: Typealias.self,
                                  file: file,
                                  line: line)
  }

  static func `extension`(source: String,
                          file: StaticString = #file,
                          line: UInt = #line) -> Extension? {
    return Self.singleDeclaration(source: source,
                                  type: Extension.self,
                                  file: file,
                                  line: line)
  }

  static func variable(source: String,
                       file: StaticString = #file,
                       line: UInt = #line) -> Variable? {
    return Self.singleDeclaration(source: source,
                                  type: Variable.self,
                                  file: file,
                                  line: line)
  }

  static func initializer(source: String,
                          file: StaticString = #file,
                          line: UInt = #line) -> Initializer? {
    return Self.singleDeclaration(source: source,
                                  type: Initializer.self,
                                  file: file,
                                  line: line)
  }

  static func function(source: String,
                       file: StaticString = #file,
                       line: UInt = #line) -> Function? {
    return Self.singleDeclaration(source: source,
                                  type: Function.self,
                                  file: file,
                                  line: line)
  }

  static func `subscript`(source: String,
                          file: StaticString = #file,
                          line: UInt = #line) -> Subscript? {
    return Self.singleDeclaration(source: source,
                                  type: Subscript.self,
                                  file: file,
                                  line: line)
  }

  static func `operator`(source: String,
                         file: StaticString = #file,
                         line: UInt = #line) -> Operator? {
    return Self.singleDeclaration(source: source,
                                  type: Operator.self,
                                  file: file,
                                  line: line)
  }

  // MARK: - Helpers

  private static func singleDeclaration<T>(source: String,
                                           type: T.Type,
                                           file: StaticString,
                                           line: UInt) -> T? {
    guard let topLevelDeclarations = Self.getTopLevelDeclarations(source: source,
                                                                  file: file,
                                                                  line: line) else {
      return nil
    }

    let count = topLevelDeclarations.count
    guard count == 1 else {
      XCTFail("Found \(count) top level declarations.", file: file, line: line)
      return nil
    }

    let declaration = topLevelDeclarations[0]
    guard let result = declaration as? T else {
      let realType = Swift.type(of: declaration)
      XCTFail("Found '\(realType)' not '\(T.self)'.", file: file, line: line)
      return nil
    }

    return result
  }

  // swiftlint:disable:next discouraged_optional_collection
  private static func getTopLevelDeclarations(source: String,
                                              file: StaticString,
                                              line: UInt) -> [Declaration]? {
    do {
      let ast = try SyntaxParser.parse(source: source)
      let astVisitor = ASTVisitor()
      astVisitor.walk(ast)
      return astVisitor.topLevelDeclarations
    } catch {
      let msg = "Parsing error: \(error)."
      XCTFail(msg, file: file, line: line)
      return nil
    }
  }
}
