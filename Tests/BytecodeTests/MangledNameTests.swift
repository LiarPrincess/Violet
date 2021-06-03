import XCTest
import VioletCore
@testable import VioletBytecode

/// Use 'Scripts/dump_python_code' to check given code snippets.
class MangledNameTests: XCTestCase {

  func test_init_withoutClass() {
    for name in ["Elsa", "__Anna", "__Olaf__", "__Frozen.Kristoff"] {
      let mangled = MangledName(withoutClass: name)
      XCTAssertEqual(mangled.beforeMangling, name)
      XCTAssertEqual(mangled.value, name)
    }
  }

  func test_init_withClass_nil() {
    for name in ["Elsa", "__Anna", "__Olaf__", "__Frozen.Kristoff"] {
      let mangled = MangledName(className: nil, name: name)
      XCTAssertEqual(mangled.beforeMangling, name)
      XCTAssertEqual(mangled.value, name)
    }
  }

  /// class Frozen:
  ///     def __init__(self):
  ///         self.Elsa = 1
  ///         self._Anna = 1
  ///         self.Olaf_ = 1
  ///         self.Kristoff__ = 1
  ///
  /// Names:          ('Elsa', '_Anna', 'Olaf_', 'Kristoff__')
  func test_init_withClass_nameWithoutDoubleUnderscorePrefix_isNotMangled() {
    let className = "Frozen"
    for name in ["Elsa", "_Anna", "Olaf_", "Kristoff__"] {
      let mangled = MangledName(className: className, name: name)
      XCTAssertEqual(mangled.beforeMangling, name)
      XCTAssertEqual(mangled.value, name)
    }
  }

  /// class Frozen:
  ///     def __init__(self):
  ///         self.__Elsa__ = 1
  ///         self.__Anna___ = 1
  ///         self.___Olaf___ = 1
  ///
  /// Names:          ('__Elsa__', '__Anna___', '___Olaf___')
  func test_init_withClass_nameWithDoubleUnderscoreSuffix_isNotMangled() {
    let className = "Frozen"
    for name in ["__Elsa__", "__Anna___", "___Olaf___"] {
      let mangled = MangledName(className: className, name: name)
      XCTAssertEqual(mangled.beforeMangling, name)
      XCTAssertEqual(mangled.value, name)
    }
  }

  /// class Frozen:
  ///     def __init__(self):
  ///         self.__.Elsa = 1
  ///         self.__An.na = 1
  ///         self.__O.la.f = 1
  ///
  /// Names:          ('__', 'Elsa', '_Frozen__An', 'na', '_Frozen__O', 'la', 'f')
  /// So no mangling here, but the compiler thinks that those are properties
  ///
  /// self.__Kristoff. = 1
  /// will not compile 'SyntaxError: invalid syntax'
  func test_init_withClass_nameWithDotInside_isNotMangled() {
    let className = "Frozen"
    for name in ["__.Elsa", "__An.na", "__O.la.f", "__Kristoff."] {
      let mangled = MangledName(className: className, name: name)
      XCTAssertEqual(mangled.beforeMangling, name)
      XCTAssertEqual(mangled.value, name)
    }
  }

  ///  class Frozen:
  ///      def __init__(self):
  ///          self.__elsa = 1
  ///
  /// Names:          ('_Frozen__elsa',)
  func test_init_withClass_isMangled() {
    let className = "Frozen"
    let name = "__Elsa"

    let mangled = MangledName(className: className, name: name)
    XCTAssertEqual(mangled.beforeMangling, "__Elsa")
    XCTAssertEqual(mangled.value, "_Frozen__Elsa")
  }

  /// class __Frozen:
  ///     def __init__(self):
  ///         self.__elsa = 1
  ///
  /// Names:          ('_Frozen__elsa',)
  func test_init_withClass_withLeadingUnderscores_isStripped_andMangled() {
    let className = "__Frozen" // should remove leading underscores
    let name = "__Elsa"

    let mangled = MangledName(className: className, name: name)
    XCTAssertEqual(mangled.beforeMangling, "__Elsa")
    XCTAssertEqual(mangled.value, "_Frozen__Elsa")
  }
}
