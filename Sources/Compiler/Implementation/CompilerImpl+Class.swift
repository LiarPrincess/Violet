import Foundation
import VioletCore
import VioletParser
import VioletBytecode

// In CPython:
// Python -> compile.c

extension CompilerImpl {

  /// compiler_class(struct compiler *c, stmt_ty s)
  ///
  /// Ultimately generate code for:
  /// ```
  /// <name> = __build_class__(<func>, <name>, *<bases>, **<keywords>)
  /// ```
  /// where:
  /// - `<func>` is a function/closure created from the class body;
  ///        it has a single argument (`__locals__`) where the dict
  ///        (or MutableSequence) representing the locals is passed
  /// - `<name>` is the class name
  /// - `<bases>` is the positional arguments and *varargs argument
  /// - `<keywords>` is the keyword arguments and **kwds argument
  internal func visit(_ node: ClassDefStmt) throws {
    let location = node.start
    try self.visitDecorators(decorators: node.decorators, location: location)

    // 1. compile the class body into a code object
    let codeObject = try self.inNewCodeObject(node: node) {
      assert(self.builder.kind == .class)

      // load (global) __name__ and store it as __module__
      self.builder.appendLoadName(SpecialIdentifiers.__name__)
      self.builder.appendStoreName(SpecialIdentifiers.__module__)

      self.builder.appendString(self.builder.qualifiedName)
      self.builder.appendStoreName(SpecialIdentifiers.__qualname__)

      try self.visitBody(body: node.body, onDoc: .storeAs__doc__)

      // Return __class__ cell if it is referenced, otherwise return None
      if self.currentScope.needsClassClosure {
        let __class__ = MangledName(withoutClass: SpecialIdentifiers.__class__)
        let __classcell__ = SpecialIdentifiers.__classcell__

        // Store __classcell__ into class namespace & return it
        self.builder.appendLoadClosureCell(name: __class__)
        self.builder.appendDupTop()
        self.builder.appendStoreName(__classcell__)
      } else {
        assert(self.builder.cellVariableNames.isEmpty)
        self.builder.appendNone()
      }

      self.builder.appendReturn()
    }

    // 2. load the 'build_class' function
    self.builder.appendLoadBuildClass()

    // 3. load a function (or closure) made from the code object
    try self.makeClosure(codeObject: codeObject, flags: [], location: location)

    // 4. load class name
    self.builder.appendString(node.name)

    // 5. generate the rest of the code for the call
    try self.callHelper(args: node.bases,
                        keywords: node.keywords,
                        context: .load,
                        alreadyPushedArgs: 2)

    // 6. apply decorators
    for _ in node.decorators {
      self.builder.appendCallFunction(argumentCount: 1)
    }

    // 7. store into <name>
    self.visitName(name: node.name, context: .store)
  }
}
