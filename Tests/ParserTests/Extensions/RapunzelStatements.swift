import Foundation
import XCTest
import Lexer
import Core
import Rapunzel
@testable import Parser

// swiftlint:disable file_length

/// This time we will be using 'Pride and Prejudice' by Jane Austen.
/// Source: 'https://www.gutenberg.org/files/1342/old/pandp12p.pdf'.
///
/// We will start from the beginning, although I really wanted to pick another
/// scene (the one that starts at page 132), but that would be a spoiler.
class RapunzelStatements: XCTestCase, RapunzelShared {

  // MARK: - Trivial

  func test_pass() {
    XCTAssertStmtDoc(.pass, "Pass")
  }

  func test_break() {
    XCTAssertStmtDoc(.break, "Break")
  }

  func test_continue() {
    XCTAssertStmtDoc(.continue, "Continue")
  }

  // MARK: - Function

  // swiftlint:disable:next function_body_length
  func test_functionDef() {
    let s0 = "It is a truth universally acknowledged,"
    let s1 = "that a single man in possession of a good fortune,"
    let s2 = "must be in want of a wife."

    let stmt = StatementKind.functionDef(
      name: s0,
      args:
        self.arguments(
            args: [
              self.arg(name: s0, annotation: nil)
            ],
            defaults: [],
            vararg: .none,
            kwOnlyArgs: [],
            kwOnlyDefaults: [],
            kwarg: nil
          ),
      body: NonEmptyArray(first: self.statement(string: s1)),
      decorators: [],
      returns: self.expression(string: s2)
    )

    XCTAssertStmtDoc(stmt, """
      FunctionDef
        Name: It is a truth universally acknowledged,
        Args
          Arguments(start: 5:50, end: 6:60)
            Args
              Arg
                Name: It is a truth universally acknowledged,
                Annotation: none
            Defaults: none
            Vararg: none
            KwOnlyArgs: none
            KwOnlyDefaults: none
        Body
          Statement(start: 0:0, end: 0:10)
            ExpressionStatement
              Expression(start: 1:10, end: 2:20)
                String: 'that a single man in possession of a good fortune,'
        Decorators: none
        Returns
          Expression(start: 1:10, end: 2:20)
            String: 'must be in want of a wife.'
      """)
  }

  // swiftlint:disable:next function_body_length
  func test_asyncFunctionDef() {
    let s0 = "However little known the feelings"
    let s1 = " or views of such a man may be"
    let s2 = "on his first entering a neighbourhood,"

    let stmt = StatementKind.asyncFunctionDef(
      name: s0,
      args:
        self.arguments(
          args: [self.arg(name: s0, annotation: nil)],
          defaults: [],
          vararg: .none,
          kwOnlyArgs: [],
          kwOnlyDefaults: [],
          kwarg: nil
        ),
      body: NonEmptyArray(first: self.statement(string: s1)),
      decorators: [],
      returns: self.expression(string: s2)
    )

    XCTAssertStmtDoc(stmt, """
      AsyncFunctionDef
        Name: However little known the feelings
        Args
          Arguments(start: 5:50, end: 6:60)
            Args
              Arg
                Name: However little known the feelings
                Annotation: none
            Defaults: none
            Vararg: none
            KwOnlyArgs: none
            KwOnlyDefaults: none
        Body
          Statement(start: 0:0, end: 0:10)
            ExpressionStatement
              Expression(start: 1:10, end: 2:20)
                String: ' or views of such a man may be'
        Decorators: none
        Returns
          Expression(start: 1:10, end: 2:20)
            String: 'on his first entering a neighbourhood,'
      """)
  }

  // MARK: - Class

  func test_class() {
    let s0 = "this truth is so well fixed in the minds of the"
    let s1 = "surrounding families, that he is considered the rightful"
    let s2 = "property of some one or other of their daughters."

    let stmt = StatementKind.classDef(
      name: s0,
      bases: [self.expression(string: s1)],
      keywords: [],
      body: NonEmptyArray(first: self.statement(string: s2)),
      decorators: []
    )

    XCTAssertStmtDoc(stmt, """
      ClassDef
        Name: this truth is so well fixed in the minds of the
        Bases
          Expression(start: 1:10, end: 2:20)
            String: 'surrounding families, that he is considered the rightful'
        Keywords: none
        Body
          Statement(start: 0:0, end: 0:10)
            ExpressionStatement
              Expression(start: 1:10, end: 2:20)
                String: 'property of some one or other of their daughters.'
        Decorators: none
      """)
  }

  // MARK: - Return

  func test_return() {
    let s0 = "“My dear Mr. Bennet,”"
    let stmt = StatementKind.return(self.expression(string: s0))
    XCTAssertStmtDoc(stmt, """
      Return
        Expression(start: 1:10, end: 2:20)
          String: '“My dear Mr. Bennet,”'
      """)
  }

  func test_return_none() {
    let stmt = StatementKind.return(nil)
    XCTAssertStmtDoc(stmt, "Return")
  }

  // MARK: - Delete

  func test_delete() {
    let s0 = "said his lady to him one day,"
    let s1 = "“have you heard that Netherfield Park is let at last?”"
    let s2 = "Mr. Bennet replied that he had not."

    let stmt = StatementKind.delete(
      NonEmptyArray(
        first: self.expression(string: s0),
        rest: [
          self.expression(string: s1),
          self.expression(string: s2)
        ]
      )
    )

    XCTAssertStmtDoc(stmt, """
      Delete
        Expression(start: 1:10, end: 2:20)
          String: 'said his lady to him one day,'
        Expression(start: 1:10, end: 2:20)
          String: '“have you heard that Netherfield Park is let at last?”'
        Expression(start: 1:10, end: 2:20)
          String: 'Mr. Bennet replied that he had not.'
      """)
  }

  // MARK: - Assign

  func test_assign() {
    let s0 = "“But it is,”"
    let s1 = "returned she;"
    let s2 = "“for Mrs. Long has just been here, and she told me all about it.”"

    let stmt = StatementKind.assign(
      targets: NonEmptyArray(
        first: self.expression(string: s0),
        rest: [
          self.expression(string: s1)
        ]
      ),
      value: self.expression(string: s2)
    )

    XCTAssertStmtDoc(stmt, """
      Assign
        Targets
          Expression(start: 1:10, end: 2:20)
            String: '“But it is,”'
          Expression(start: 1:10, end: 2:20)
            String: 'returned she;'
        Value
          Expression(start: 1:10, end: 2:20)
            String: '“for Mrs. Long has just been here, and she told me all about ...'
      """)
  }

  func test_assign_annotated() {
    let s0 = "Mr. Bennet replied that he had not."
    let s1 = "“But it is,”"
    let s2 = "returned she;"

    let stmt = StatementKind.annAssign(
      target: self.expression(string: s0),
      annotation: self.expression(string: s1),
      value: self.expression(string: s2),
      isSimple: true
    )

    XCTAssertStmtDoc(stmt, """
      AnnAssign
        Target
          Expression(start: 1:10, end: 2:20)
            String: 'Mr. Bennet replied that he had not.'
        Annotation
          Expression(start: 1:10, end: 2:20)
            String: '“But it is,”'
        Value
          Expression(start: 1:10, end: 2:20)
            String: 'returned she;'
      """)
  }

  func test_assign_augumented() {
    let operators: [BinaryOperator] = [
      .add, .sub,
      .mul, .matMul, .pow,
      .div, .modulo,
      .leftShift, .rightShift,
      .bitOr, .bitXor, .bitAnd, .floorDiv
    ]

    let s0 = "“for Mrs. Long has just been here, and she told me all about it.”"
    let target = self.expression(string: s0)

    let s1 = "Mr. Bennet made no answer."
    let value = self.expression(string: s1)

    for op in operators {
      let stmt = StatementKind.augAssign(target: target,
                                         op: op,
                                         value: value)

      XCTAssertStmtDoc(stmt, """
        AugAssign
          Target
            Expression(start: 1:10, end: 2:20)
              String: '“for Mrs. Long has just been here, and she told me all about ...'
          Operation: \(op)
          Value
            Expression(start: 1:10, end: 2:20)
              String: 'Mr. Bennet made no answer.'
        """)
    }
  }

  // MARK: - For

  func test_for() {
    let s0 = "“Do you not want to know who has taken it?”"
    let s1 = "cried his wife impatiently."
    let s2 = "“You want to tell me,"
    let s3 = "and I have no objection to hearing it.”"

    let stmt = StatementKind.for(
      target: self.expression(string: s0),
      iter: self.expression(string: s1),
      body: NonEmptyArray(first: self.statement(string: s2)),
      orElse: [self.statement(string: s3)]
    )

    XCTAssertStmtDoc(stmt, """
      For
        Target
          Expression(start: 1:10, end: 2:20)
            String: '“Do you not want to know who has taken it?”'
        Iter
          Expression(start: 1:10, end: 2:20)
            String: 'cried his wife impatiently.'
        Body
          Statement(start: 0:0, end: 0:10)
            ExpressionStatement
              Expression(start: 1:10, end: 2:20)
                String: '“You want to tell me,'
        OrElse
          Statement(start: 0:0, end: 0:10)
            ExpressionStatement
              Expression(start: 1:10, end: 2:20)
                String: 'and I have no objection to hearing it.”'
      """)
  }

  func test_for_async() {
    let s0 = "This was invitation enough."
    let s1 = "“Why, my dear, you must know,"
    let s2 = "Mrs. Long says that Netherfield is"
    let s3 = "taken by a young man of large fortune from the north of England;"

    let stmt = StatementKind.asyncFor(
      target: self.expression(string: s0),
      iter: self.expression(string: s1),
      body: NonEmptyArray(first: self.statement(string: s2)),
      orElse: [self.statement(string: s3)]
    )

    XCTAssertStmtDoc(stmt, """
      AsyncFor
        Target
          Expression(start: 1:10, end: 2:20)
            String: 'This was invitation enough.'
        Iter
          Expression(start: 1:10, end: 2:20)
            String: '“Why, my dear, you must know,'
        Body
          Statement(start: 0:0, end: 0:10)
            ExpressionStatement
              Expression(start: 1:10, end: 2:20)
                String: 'Mrs. Long says that Netherfield is'
        OrElse
          Statement(start: 0:0, end: 0:10)
            ExpressionStatement
              Expression(start: 1:10, end: 2:20)
                String: 'taken by a young man of large fortune from the north of Engla...'
      """)
  }

  // MARK: - While

  func test_while() {
    let s0 = "that he came down on Monday"
    let s1 = "in a chaise and four to see the place,"
    let s2 = "and was so much delighted with it"

    let stmt = StatementKind.while(
      test: self.expression(string: s0),
      body: NonEmptyArray(first: self.statement(string: s1)),
      orElse: [self.statement(string: s2)]
    )

    XCTAssertStmtDoc(stmt, """
      While
        Test
          Expression(start: 1:10, end: 2:20)
            String: 'that he came down on Monday'
        Body
          Statement(start: 0:0, end: 0:10)
            ExpressionStatement
              Expression(start: 1:10, end: 2:20)
                String: 'in a chaise and four to see the place,'
        OrElse
          Statement(start: 0:0, end: 0:10)
            ExpressionStatement
              Expression(start: 1:10, end: 2:20)
                String: 'and was so much delighted with it'
      """)
  }

  // MARK: - If

  func test_if() {
    let s0 = "that he agreed with Mr. Morris immediately;"
    let s1 = "that he is to take possession before Michaelmas,"
    let s2 = "and some of his servants are to be in the house by the end of next week."

    let stmt = StatementKind.if(
      test: self.expression(string: s0),
      body: NonEmptyArray(first: self.statement(string: s1)),
      orElse: [self.statement(string: s2)]
    )

    XCTAssertStmtDoc(stmt, """
      If
        Test
          Expression(start: 1:10, end: 2:20)
            String: 'that he agreed with Mr. Morris immediately;'
        Body
          Statement(start: 0:0, end: 0:10)
            ExpressionStatement
              Expression(start: 1:10, end: 2:20)
                String: 'that he is to take possession before Michaelmas,'
        OrElse
          Statement(start: 0:0, end: 0:10)
            ExpressionStatement
              Expression(start: 1:10, end: 2:20)
                String: 'and some of his servants are to be in the house by the end of...'
      """)
  }

  // MARK: - With

  func test_with() {
    let s0 = "“What is his name?”"
    let s1 = "“Bingley.”"
    let s2 = "“Is he married or single?”"

    let stmt = StatementKind.with(
      items: NonEmptyArray(first:
        self.withItem(
          contextExpr: self.expression(string: s0),
          optionalVars: self.expression(string: s1)
        )
      ),
      body: NonEmptyArray(first: self.statement(string: s2))
    )

    XCTAssertStmtDoc(stmt, """
      With
        Items
          WithItem(start: 13:130, end: 14:140)
            ContextExpr
              Expression(start: 1:10, end: 2:20)
                String: '“What is his name?”'
            OptionalVars
              Expression(start: 1:10, end: 2:20)
                String: '“Bingley.”'
        Body
          Statement(start: 0:0, end: 0:10)
            ExpressionStatement
              Expression(start: 1:10, end: 2:20)
                String: '“Is he married or single?”'
      """)
  }

  func test_with_async() {
    let s0 = "Oh! Single,"
    let s1 = "my dear, "
    let s2 = "to be sure!"

    let stmt = StatementKind.asyncWith(
      items: NonEmptyArray(first:
        self.withItem(
          contextExpr: self.expression(string: s0),
          optionalVars: self.expression(string: s1)
        )
      ),
      body: NonEmptyArray(first: self.statement(string: s2))
    )

    XCTAssertStmtDoc(stmt, """
      AsyncWith
        Items
          WithItem(start: 13:130, end: 14:140)
            ContextExpr
              Expression(start: 1:10, end: 2:20)
                String: 'Oh! Single,'
            OptionalVars
              Expression(start: 1:10, end: 2:20)
                String: 'my dear, '
        Body
          Statement(start: 0:0, end: 0:10)
            ExpressionStatement
              Expression(start: 1:10, end: 2:20)
                String: 'to be sure!'
      """)
  }

  // MARK: - Try

  // swiftlint:disable:next function_body_length
  func test_try() {
    let s0 = "A single man of large fortune;"
    let s1 = "four or five thousand a year."
    let s2 = "What a fine thing for our girls!”"
    let s3 = "“How so? How can it affect them?”"
    let s4 = "“My dear Mr. Bennet,”"
    let s5 = "replied his wife,"
    let s6 = "“how can you be so tiresome!"

    let stmt = StatementKind.try(
      body: NonEmptyArray(first: self.statement(string: s0)),
      handlers: [
        self.exceptHandler(
          kind: .default,
          body: self.statement(string: s1)
        ),
        self.exceptHandler(
          kind: .typed(
            type: self.expression(string: s2),
            asName: s3
          ),
          body: self.statement(string: s4)
        )
      ],
      orElse: [self.statement(string: s5)],
      finally: [self.statement(string: s6)]
    )

    XCTAssertStmtDoc(stmt, """
      Try
        Body
          Statement(start: 0:0, end: 0:10)
            ExpressionStatement
              Expression(start: 1:10, end: 2:20)
                String: 'A single man of large fortune;'
        Handlers
          ExceptHandler(start: 15:150, end: 16:160)
            Kind
              Default
            Body
              Statement(start: 0:0, end: 0:10)
                ExpressionStatement
                  Expression(start: 1:10, end: 2:20)
                    String: 'four or five thousand a year.'
          ExceptHandler(start: 15:150, end: 16:160)
            Kind
              Typed
                Type
                  Expression(start: 1:10, end: 2:20)
                    String: 'What a fine thing for our girls!”'
                AsName: “How so? How can it affect them?”
            Body
              Statement(start: 0:0, end: 0:10)
                ExpressionStatement
                  Expression(start: 1:10, end: 2:20)
                    String: '“My dear Mr. Bennet,”'
        OrElse
          Statement(start: 0:0, end: 0:10)
            ExpressionStatement
              Expression(start: 1:10, end: 2:20)
                String: 'replied his wife,'
        FinalBody
          Statement(start: 0:0, end: 0:10)
            ExpressionStatement
              Expression(start: 1:10, end: 2:20)
                String: '“how can you be so tiresome!'
      """)
  }

  // MARK: - Raise

  func test_raise() {
    let s0 = "You must know that I am thinking"
    let s1 = "of his marrying one of them.”"

    let stmt = StatementKind.raise(
      exception: self.expression(string: s0),
      cause: self.expression(string: s1)
    )

    XCTAssertStmtDoc(stmt, """
      Raise
        Exc
          Expression(start: 1:10, end: 2:20)
            String: 'You must know that I am thinking'
        Cause
          Expression(start: 1:10, end: 2:20)
            String: 'of his marrying one of them.”'
      """)
  }

  func test_raise_nil() {
    let stmt = StatementKind.raise(
      exception: nil,
      cause: nil
    )

    XCTAssertStmtDoc(stmt, """
      Raise
        Exc: none
        Cause: none
      """)
  }

  // MARK: - Import

  func test_import() {
    let s0 = "“Is that his design in settling here?”"
    let s1 = "“Design! Nonsense, how can you talk so!"

    let stmt = StatementKind.import(
      NonEmptyArray(first: self.alias(name: s0, asName: s1))
    )

    XCTAssertStmtDoc(stmt, """
      Import
        Alias(start: 17:170, end: 18:180)
          Name: “Is that his design in settling here?”
          AsName: “Design! Nonsense, how can you talk so!
      """)
  }

  func test_import_from() {
    let s0 = "But it is very likely that he may fall in love with one of them,"
    let s1 = "and therefore you must visit him as soon as he comes.”"
    let s2 = "“I see no occasion for that."

    let stmt = StatementKind.importFrom(
      moduleName: s0,
      names: NonEmptyArray(first:
        self.alias(
          name: s1,
          asName: s2
        )
      ),
      level: 5
    )

    XCTAssertStmtDoc(stmt, """
      ImportFrom
        Module: But it is very likely that he may fall in love with one of them,
        Names
          Alias(start: 17:170, end: 18:180)
            Name: and therefore you must visit him as soon as he comes.”
            AsName: “I see no occasion for that.
        Level: 5
      """)
  }

  func test_import_fromStar() {
    let s0 = "You and the girls may go,"

    let stmt = StatementKind.importFromStar(
      moduleName: s0,
      level: 5
    )

    XCTAssertStmtDoc(stmt, """
      ImportFromStar
        Module: You and the girls may go,
        Level: 5
      """)
  }

  // MARK: - Global/local

  func test_global() {
    let s0 = "or you may send them by themselves,"
    let s1 = "which perhaps will be still better,"

    let stmt = StatementKind.global(
      NonEmptyArray(first: s0, rest: [s1])
    )

    XCTAssertStmtDoc(stmt, """
      Global
        or you may send them by themselves,
        which perhaps will be still better,
      """)
  }

  func test_local() {
    let s0 = "for as you are as handsome as any of them,"
    let s1 = "Mr. Bingley may like you the best of the party.”"

    let stmt = StatementKind.nonlocal(
      NonEmptyArray(first: s0, rest: [s1])
    )

    XCTAssertStmtDoc(stmt, """
      Nonlocal
        for as you are as handsome as any of them,
        Mr. Bingley may like you the best of the party.”
      """)
  }

  // MARK: - Assert

  func test_assert() {
    let s0 = "“My dear, you flatter me."
    let s1 = "I certainly have had my share of beauty,"

    let stmt = StatementKind.assert(
      test: self.expression(string: s0),
      msg: self.expression(string: s1)
    )

    XCTAssertStmtDoc(stmt, """
      Assert
        Test
          Expression(start: 1:10, end: 2:20)
            String: '“My dear, you flatter me.'
        Msg
          Expression(start: 1:10, end: 2:20)
            String: 'I certainly have had my share of beauty,'
      """)
  }

  func test_assert_noMessage() {
    let s0 = "but I do not pretend to be anything extraordinary now."

    let stmt = StatementKind.assert(
      test: self.expression(string: s0),
      msg: nil
    )

    XCTAssertStmtDoc(stmt, """
      Assert
        Test
          Expression(start: 1:10, end: 2:20)
            String: 'but I do not pretend to be anything extraordinary now.'
        Msg: none
      """)
  }
}
