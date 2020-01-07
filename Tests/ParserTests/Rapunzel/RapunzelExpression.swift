import Foundation
import XCTest
import Lexer
import Core
import Rapunzel
@testable import Parser

// swiftlint:disable file_length

internal func XCTAssertDoc(_ expr: ExpressionKind,
                           _ expected: String,
                           _ message:  String = "",
                           file: StaticString = #file,
                           line: UInt         = #line) {
  let doc = expr.doc
  let result = doc.layout()
  XCTAssertEqual(result, expected, message, file: file, line: line)
}

@available(*, deprecated, message: "Usable only when writing tests")
private func dump<R: RapunzelConvertible>(_ value: R) {
  print("========")
  print(value.dump())
  print("========")
}

/// Song reference: https://www.youtube.com/watch?v=t6Ol7VsZGk4
/// We will be using string literals as stand-in for more complicated expressions.
class RapunzelExpression: XCTestCase {

  // MARK: - Trivial

  func test_none() {
    XCTAssertDoc(.none, "None")
  }

  func test_ellipsis() {
    XCTAssertDoc(.ellipsis, "...")
  }

  func test_identifier() {
    XCTAssertDoc(.identifier("look_at_this_stuff"), "look_at_this_stuff")
  }

  // MARK: - Basic types

  func test_booleans() {
    XCTAssertDoc(.true, "True")
    XCTAssertDoc(.false, "False")
  }

  func test_numeric() {
    // swiftlint:disable:next number_separator
    XCTAssertDoc(.int(1989), "1989")

    XCTAssertDoc(.float(19.89), "19.89")

    XCTAssertDoc(.complex(real: 19, imag: 8.9), """
      Complex
        real: 19.0
        imag: 8.9
      """)
  }

  func test_string() {
    let literal = StringGroup.literal("Isn't it neat?")
    XCTAssertDoc(.string(literal), """
      String: 'Isn't it neat?'
      """)

    let formatted = StringGroup.literal("Wouldn't you think my collection's complete?")
    let formattedValue = StringGroup.formattedValue(
      self.expression(.string(formatted)),
      conversion: .ascii,
      spec: "Wouldn't you think I'm the girl"
    )

    XCTAssertDoc(.string(formattedValue), """
      Formatted string
        Expression(start: 1:10, end: 2:20)
          String: 'Wouldn't you think my collection's complete?'
        Conversion: ascii
        Spec: Wouldn't you think I'm the girl
      """)

    let joined = StringGroup.joined([literal, formattedValue])
    XCTAssertDoc(.string(joined), """
    Joined string
      String: 'Isn't it neat?'
      Formatted string
        Expression(start: 1:10, end: 2:20)
          String: 'Wouldn't you think my collection's complete?'
        Conversion: ascii
        Spec: Wouldn't you think I'm the girl
    """)
  }

  func test_bytes() {
    let data = Data([1,2,3,4,5,6])
    XCTAssertDoc(.bytes(data), """
      Bytes
        Count: \(data.count)
      """)
  }

  // MARK: - Operations

  func test_unaryOp() {
    let operators: [UnaryOperator] = [.invert, .not, .plus, .minus]

    let r = "The girl who has everything?"
    let right = self.expression(string: r)

    for op in operators {
      let expr = ExpressionKind.unaryOp(op, right: right)
      XCTAssertDoc(expr, """
        Unary operation
          Operation: \(op)
          Right
            Expression(start: 1:10, end: 2:20)
              String: '\(r)'
        """)
    }
  }

  func test_binaryOp() {
    let operators: [BinaryOperator] = [
      .add, .sub,
      .mul, .matMul, .pow,
      .div, .modulo,
      .leftShift, .rightShift,
      .bitOr, .bitXor, .bitAnd, .floorDiv
    ]

    let l = "Look at this trove"
    let left = self.expression(string: l)

    let r = "Treasures untold"
    let right = self.expression(string: r)

    for op in operators {
      let expr = ExpressionKind.binaryOp(op, left: left, right: right)
      XCTAssertDoc(expr, """
        Binary operation
          Operation: \(op)
          Left
            Expression(start: 1:10, end: 2:20)
              String: '\(l)'
          Right
            Expression(start: 1:10, end: 2:20)
              String: '\(r)'
        """)
    }
  }

  func test_boolOp() {
    let operators: [BooleanOperator] = [.and, .or]

    let l = "How many wonders can one cavern hold?"
    let left = self.expression(string: l)

    let r = "Lookin' around here you'd think"
    let right = self.expression(string: r)

    for op in operators {
      let expr = ExpressionKind.boolOp(op, left: left, right: right)
      XCTAssertDoc(expr, """
        Bool operation
          Operation: \(op)
          Left
            Expression(start: 1:10, end: 2:20)
              String: '\(l)'
          Right
            Expression(start: 1:10, end: 2:20)
              String: '\(r)'
        """)
    }
  }

  func test_compareOp() {
    let operators: [ComparisonOperator] = [
      .equal, .notEqual,
      .less, .lessEqual,
      .greater, .greaterEqual,
      .`is`, .isNot,
      .`in`, .notIn
    ]

    let l = "Sure"
    let left = self.expression(string: l)

    let r = "She's got everything"
    let right = self.expression(string: r)

    for op in operators {
      let element = ComparisonElement(op: op, right: right)
      let elements = NonEmptyArray(first: element)

      let expr = ExpressionKind.compare(left: left, elements: elements)
      XCTAssertDoc(expr, """
        Compare operation
          Left
            Expression(start: 1:10, end: 2:20)
              String: '\(l)'
          Elements
            ComparisonElement
              Operation: \(op)
              Right
                Expression(start: 1:10, end: 2:20)
                  String: '\(r)'
        """)
    }
  }

  // MARK: - Collections

  func test_tuple() {
    let s0 = "I've got gadgets and gizmos a-plenty"
    let s1 = "I've got whose-its and whats-its galore"

    let expr = ExpressionKind.tuple([
      self.expression(string: s0),
      self.expression(string: s1)
    ])

    XCTAssertDoc(expr, """
      Tuple
        Expression(start: 1:10, end: 2:20)
          String: '\(s0)'
        Expression(start: 1:10, end: 2:20)
          String: '\(s1)'
      """)
  }

  func test_list() {
    let s0 = "You want thingamabobs?"
    let s1 = "I got twenty"

    let expr = ExpressionKind.list([
      self.expression(string: s0),
      self.expression(string: s1)
    ])

    XCTAssertDoc(expr, """
      List
        Expression(start: 1:10, end: 2:20)
          String: '\(s0)'
        Expression(start: 1:10, end: 2:20)
          String: '\(s1)'
      """)
  }

  func test_dist() {
    let s0 = "But who cares?"
    let s1 = "No big deal"
    let s2 = "I want more"

    let expr = ExpressionKind.dictionary([
      .keyValue(
        key: self.expression(string: s0),
        value: self.expression(string: s1)
      ),
      .unpacking(self.expression(string: s2))
    ])

    XCTAssertDoc(expr, """
      Dictionary
        Key/value
          Key
            Expression(start: 1:10, end: 2:20)
              String: '\(s0)'
          Value
            Expression(start: 1:10, end: 2:20)
              String: '\(s1)'
        Unpack
          Expression(start: 1:10, end: 2:20)
            String: '\(s2)'
      """)
  }

  func test_set() {
    let s0 = "I wanna be where the people are"
    let s1 = "I wanna see, wanna see 'em dancin'"

    let expr = ExpressionKind.set([
      self.expression(string: s0),
      self.expression(string: s1)
    ])

    XCTAssertDoc(expr, """
      Set
        Expression(start: 1:10, end: 2:20)
          String: '\(s0)'
        Expression(start: 1:10, end: 2:20)
          String: '\(s1)'
      """)
  }

  // MARK: - Comprehension

  func test_listComprehension() {
    let s0 = "I wanna be where the people are"
    let s1 = "I wanna see, wanna see 'em dancin'"
    let s2 = "Walkin' around on those — what do ya' call 'em? — oh, feet"

    let expr = ExpressionKind.listComprehension(
      elt: self.expression(string: s0),
      generators: NonEmptyArray(
        first: self.comprehension(
          target: self.expression(string: s1),
          iter: self.expression(string: s2),
          ifs: [],
          isAsync: false
        )
      )
    )

    XCTAssertDoc(expr, """
      ListComprehension
        Element
          Expression(start: 1:10, end: 2:20)
            String: '\(s0)'
        Generators
          Comprehension(start: 3:30, end: 4:40)
            isAsync: false
            Target
              Expression(start: 1:10, end: 2:20)
                String: '\(s1)'
            Iterable
              Expression(start: 1:10, end: 2:20)
                String: '\(s2)'
            Ifs: none
      """)
  }

  func test_setComprehension() {
    let s0 = "Flippin' your fins you don't get too far"
    let s1 = "Legs are required for jumpin', dancin'"
    let s2 = "Strollin' along down a — what's that word again? – street"

    let expr = ExpressionKind.setComprehension(
      elt: self.expression(string: s0),
      generators: NonEmptyArray(
        first: self.comprehension(
          target: self.expression(string: s1),
          iter: self.expression(string: s2),
          ifs: [],
          isAsync: false
        )
      )
    )

    XCTAssertDoc(expr, """
      SetComprehension
        Element
          Expression(start: 1:10, end: 2:20)
            String: '\(s0)'
        Generators
          Comprehension(start: 3:30, end: 4:40)
            isAsync: false
            Target
              Expression(start: 1:10, end: 2:20)
                String: '\(s1)'
            Iterable
              Expression(start: 1:10, end: 2:20)
                String: '\(s2)'
            Ifs: none
      """)
  }

  // swiftlint:disable:next function_body_length
  func test_dictionaryComprehension() {
    let s0 = "Up where they walk"
    let s1 = "Up where they run"
    let s2 = "Up where they stay all day in the sun"
    let s3 = "Wanderin' free"

    let expr = ExpressionKind.dictionaryComprehension(
      key: self.expression(string: s0),
      value: self.expression(string: s1),
      generators: NonEmptyArray(
        first: self.comprehension(
          target: self.expression(string: s2),
          iter: self.expression(string: s3),
          ifs: [],
          isAsync: false
        )
      )
    )

    XCTAssertDoc(expr, """
      DictionaryComprehension
        Key
          Expression(start: 1:10, end: 2:20)
            String: '\(s0)'
        Value
          Expression(start: 1:10, end: 2:20)
            String: '\(s1)'
        Generators
          Comprehension(start: 3:30, end: 4:40)
            isAsync: false
            Target
              Expression(start: 1:10, end: 2:20)
                String: '\(s2)'
            Iterable
              Expression(start: 1:10, end: 2:20)
                String: '\(s3)'
            Ifs: none
      """)
  }

  func test_generatorExpr() {
    let s0 = "Wanderin' free"
    let s1 = "Wish I could be"
    let s2 = "Part of that world"

    let expr = ExpressionKind.generatorExp(
      elt: self.expression(string: s0),
      generators: NonEmptyArray(
        first: self.comprehension(
          target: self.expression(string: s1),
          iter: self.expression(string: s2),
          ifs: [],
          isAsync: false
        )
      )
    )

    XCTAssertDoc(expr, """
      GeneratorExpr
        Element
          Expression(start: 1:10, end: 2:20)
            String: '\(s0)'
        Generators
          Comprehension(start: 3:30, end: 4:40)
            isAsync: false
            Target
              Expression(start: 1:10, end: 2:20)
                String: '\(s1)'
            Iterable
              Expression(start: 1:10, end: 2:20)
                String: '\(s2)'
            Ifs: none
      """)
  }

  // MARK: - Await, yield

  func test_await() {
    let s0 = "What would I give"

    let expr = ExpressionKind.await(
      self.expression(string: s0)
    )

    XCTAssertDoc(expr, """
      Await
        Expression(start: 1:10, end: 2:20)
          String: '\(s0)'
      """)
  }

  func test_yield() {
    let s0 = "If I could live"

    let expr = ExpressionKind.yield(
      self.expression(string: s0)
    )

    XCTAssertDoc(expr, """
      Yield
        Expression(start: 1:10, end: 2:20)
          String: '\(s0)'
      """)
  }

  func test_yield_nil() {
    let expr = ExpressionKind.yield(nil)

    XCTAssertDoc(expr, """
      Yield
        (none)
      """)
  }

  func test_yieldFrom() {
    let s0 = "Out of these waters?"

    let expr = ExpressionKind.yieldFrom(
      self.expression(string: s0)
    )

    XCTAssertDoc(expr, """
      YieldFrom
        Expression(start: 1:10, end: 2:20)
          String: '\(s0)'
      """)
  }

  // MARK: - Lambda

  func test_lambda() {
    let s0 = "What would I pay"
    let s1 = "To spend a day"

    let expr = ExpressionKind.lambda(
      args: self.arguments(
        args: [
          self.arg(name: s0, annotation: nil)
        ],
        defaults: [],
        vararg: .none,
        kwOnlyArgs: [],
        kwOnlyDefaults: [],
        kwarg: nil
      ),
      body: self.expression(string: s1)
    )

    XCTAssertDoc(expr, """
      Lambda
        Args
          Arguments(start: 5:50, end: 6:60)
            Args
              Arg
                Name: \(s0)
                Annotation: none
            Defaults: none
            Vararg: none
            KwOnlyArgs: none
            KwOnlyDefaults: none
        Body
          Expression(start: 1:10, end: 2:20)
            String: '\(s1)'
      """)
  }

  // MARK: - Call

  // swiftlint:disable:next function_body_length
  func test_call() {
    let s0 = "Warm on the sand?"
    let s1 = "Bet ya on land"
    let s2 = "They understand"
    let s3 = "Bet they don't reprimand their daughters"
    let s4 = "Bright young women"
    let s5 = "Sick of swimming"

    let expr = ExpressionKind.call(
      function: self.expression(string: s0),
      args: [
        self.expression(string: s1),
        self.expression(string: s2)
      ],
      keywords: [
        self.keyword(kind: .dictionaryUnpack, value: self.expression(string: s3)),
        self.keyword(kind: .named(s4), value: self.expression(string: s5))
      ]
    )

    XCTAssertDoc(expr, """
      Call
        Name
          Expression(start: 1:10, end: 2:20)
            String: '\(s0)'
        Args
          Expression(start: 1:10, end: 2:20)
            String: '\(s1)'
          Expression(start: 1:10, end: 2:20)
            String: '\(s2)'
        Keywords
          Keyword(start: 9:90, end: 10:100)
            Kind
              DictionaryUnpack
            Value
              Expression(start: 1:10, end: 2:20)
                String: '\(s3)'
          Keyword(start: 9:90, end: 10:100)
            Kind
              Named('\(s4)')
            Value
              Expression(start: 1:10, end: 2:20)
                String: '\(s5)'
      """)
  }

  // MARK: - If expression

  func test_ifExpr() {
    let s0 = "Ready to stand"
    let s1 = "And I'm ready to know what the people know"
    let s2 = "Ask 'em my questions"

    let expr = ExpressionKind.ifExpression(
      test: self.expression(string: s0),
      body: self.expression(string: s1),
      orElse: self.expression(string: s2)
    )

    XCTAssertDoc(expr, """
      IfExpression
        Expression(start: 1:10, end: 2:20)
          String: '\(s0)'
        Expression(start: 1:10, end: 2:20)
          String: '\(s1)'
        Expression(start: 1:10, end: 2:20)
          String: '\(s2)'
      """)
  }

  // MARK: - Starred

  func test_starred() {
    let s0 = "And get some answers"

    let expr = ExpressionKind.starred(self.expression(string: s0))

    XCTAssertDoc(expr, """
      Starred
        Expression(start: 1:10, end: 2:20)
          String: '\(s0)'
      """)
  }

  // MARK: - Attribute

  func test_attribute() {
    let s0 = "What's a fire and why does it — what's the word? — burn?"
    let s1 = "When's it my turn?"

    let expr = ExpressionKind.attribute(
      self.expression(string: s0),
      name: s1
    )

    XCTAssertDoc(expr, """
      Attribute
        Value
          Expression(start: 1:10, end: 2:20)
            String: '\(s0)'
        Name: \(s1)
      """)
  }

  // MARK: - Slice

  func test_slice_index() {
    let s0 = "Wouldn't I love"
    let s1 = "Love to explore that shore up above?"

    let expr = ExpressionKind.subscript(
      self.expression(string: s0),
      slice: self.slice(kind: .index(self.expression(string: s1)))
    )

    XCTAssertDoc(expr, """
      Subscript
        Value
          Expression(start: 1:10, end: 2:20)
            String: '\(s0)'
        Slice
          Slice(start: 11:110, end: 12:120)
            Index
              Expression(start: 1:10, end: 2:20)
                String: '\(s1)'
      """)
  }

  func test_slice_slice() {
    let s0 = "Out of the sea"
    let s1 = "Wish I could be"

    let expr = ExpressionKind.subscript(
      self.expression(string: s0),
      slice: self.slice(kind:
        .slice(
          lower: nil,
          upper: self.expression(string: s1),
          step: nil
        )
      )
    )

    XCTAssertDoc(expr, """
      Subscript
        Value
          Expression(start: 1:10, end: 2:20)
            String: '\(s0)'
        Slice
          Slice(start: 11:110, end: 12:120)
            Slice
              Lower: none
              Upper
                Expression(start: 1:10, end: 2:20)
                  String: '\(s1)'
              Step: none
      """)
  }

  // MARK: - Helpers

  private func expression(string: String) -> Expression {
    return self.expression(.string(.literal(string)))
  }

  private func expression(_ kind: ExpressionKind) -> Expression {
    return Expression(
      kind,
      start: SourceLocation(line: 1, column: 10),
      end: SourceLocation(line: 2, column: 20)
    )
  }

  private func comprehension(target: Expression,
                             iter: Expression,
                             ifs: [Expression],
                             isAsync: Bool) -> Comprehension {
    return Comprehension(
       target: target,
       iter: iter,
       ifs: ifs,
       isAsync: isAsync,
       start: SourceLocation(line: 3, column: 30),
       end: SourceLocation(line: 4, column: 40)
     )
  }

  // swiftlint:disable:next function_parameter_count
  private func arguments(args: [Arg],
                         defaults: [Expression],
                         vararg: Vararg,
                         kwOnlyArgs: [Arg],
                         kwOnlyDefaults: [Expression],
                         kwarg: Arg?) -> Arguments {
    return Arguments(
      args: args,
      defaults: defaults,
      vararg: vararg,
      kwOnlyArgs: kwOnlyArgs,
      kwOnlyDefaults: kwOnlyDefaults,
      kwarg: kwarg,
      start: SourceLocation(line: 5, column: 50),
      end: SourceLocation(line: 6, column: 60)
    )
  }

  private func arg(name: String, annotation: Expression?) -> Arg {
    return Arg(
      name,
      annotation: annotation,
      start: SourceLocation(line: 7, column: 70),
      end: SourceLocation(line: 8, column: 80)
    )
  }

  private func keyword(kind: KeywordKind, value: Expression) -> Keyword {
    return Keyword(
      kind: kind,
      value: value,
      start: SourceLocation(line: 9, column: 90),
      end: SourceLocation(line: 10, column: 100)
    )
  }

  private func slice(kind: SliceKind) -> Slice {
    return Slice(
      kind,
      start: SourceLocation(line: 11, column: 110),
      end: SourceLocation(line: 12, column: 120)
    )
  }
}
