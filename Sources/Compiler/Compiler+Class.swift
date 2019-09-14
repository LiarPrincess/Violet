import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

extension Compiler {

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
  internal func visitClassDef(name: String,
                              bases: [Expression],
                              keywords: [Keyword],
                              body: NonEmptyArray<Statement>,
                              decorators: [Expression],
                              statement:  Statement) throws {

    let location = statement.start
    try self.visitDecorators(decorators: decorators, location: location)

    // 1. compile the class body into a code object
    let codeObject = try self.inNewCodeObject(node: statement, type: .class) {
      // load (global) __name__ and store it as __module__
      self.builder.appendLoadName(SpecialIdentifiers.__name__)
      self.builder.appendStoreName(SpecialIdentifiers.__module__)

      self.builder.appendString(self.codeObject.qualifiedName)
      self.builder.appendStoreName(SpecialIdentifiers.__qualname__)

      try self.visitStatements(body)

      // Return __class__ cell if it is referenced, otherwise return None
      if self.currentScope.needsClassClosure {
        let __class__ = MangledName(from: SpecialIdentifiers.__class__)
        let __classcell__ = SpecialIdentifiers.__classcell__

        // Store __classcell__ into class namespace & return it
        self.builder.appendLoadClosure(.cell(__class__))
        self.builder.appendDupTop()
        self.builder.appendStoreName(__classcell__)
      } else {
        assert(self.codeObject.cellVars.isEmpty)
        self.builder.appendNone()
      }

      self.builder.appendReturn()
    }

    // 2. load the 'build_class' function
    self.builder.appendLoadBuildClass()
    // 3. load a function (or closure) made from the code object
    try self.makeClosure(codeObject: codeObject, flags: [], location: location)
    // 4. load class name
    self.builder.appendString(name)
    // 5. generate the rest of the code for the call
    try self.callHelper(args: bases,
                        keywords: keywords,
                        context: .load,
                        alreadyPushedArgs: 2)
    // 6. apply decorators
    for _ in decorators {
      self.builder.appendCallFunction(argumentCount: 1)
    }
    // 7. store into <name>
    self.builder.appendStoreName(name)
  }
}
