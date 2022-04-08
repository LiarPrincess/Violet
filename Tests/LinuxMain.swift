import XCTest

import BigIntTests
import FileSystemTests
import RapunzelTests
import UnicodeDataTests
import VioletBytecodeTests
import VioletCompilerTests
import VioletCoreTests
import VioletLexerTests
import VioletObjectsTests
import VioletParserTests
import VioletVMTests

var tests = [XCTestCaseEntry]()
tests += BigIntTests.__allTests()
tests += FileSystemTests.__allTests()
tests += RapunzelTests.__allTests()
tests += UnicodeDataTests.__allTests()
tests += VioletBytecodeTests.__allTests()
tests += VioletCompilerTests.__allTests()
tests += VioletCoreTests.__allTests()
tests += VioletLexerTests.__allTests()
tests += VioletObjectsTests.__allTests()
tests += VioletParserTests.__allTests()
tests += VioletVMTests.__allTests()

XCTMain(tests)
