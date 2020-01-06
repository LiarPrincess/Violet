import XCTest
@testable import Rapunzel

private func XCTAssertLayout(_ doc: Doc,
                             _ s:  String,
                             file: StaticString = #file,
                             line: UInt         = #line) {
  let layout = doc.layout()
  XCTAssertEqual(layout, s, file: file, line: line)
}

class Tests: XCTestCase {

  private let rapunzel = Doc.text("Rapunzel")
  private let flynn = Doc.text("Flynn")
  private let pascal = Doc.text("Pascal")

  // MARK: - Ctors

  func test_ctors() {
    XCTAssertLayout(.concat(rapunzel, flynn), "RapunzelFlynn")
    XCTAssertLayout(.nest(2, rapunzel), "  Rapunzel")
    XCTAssertLayout(.text("Rapunzel"), "Rapunzel")
    XCTAssertLayout(.line, "\n")

    let block = Doc.block(title: "Tangled", indent: 2, lines: [rapunzel, flynn])
    XCTAssertLayout(block, """
      Tangled
        Rapunzel
        Flynn
      """)
  }

  // MARK: - Combine

  func test_recursive_nested() {
    let horizontal = Doc.nest(2, rapunzel) <> Doc.nest(3, flynn)
    XCTAssertLayout(horizontal, "  Rapunzel   Flynn")

    let vertical = rapunzel <|>
                    Doc.nest(2, flynn <|> // notice not closed paren
                      Doc.nest(3, pascal))
    XCTAssertLayout(vertical, """
      Rapunzel
        Flynn
           Pascal
      """)
  }

  func test_recursive_blocks() {
    let thug1 = Doc.text("Hook Hand")
    let thug2 = Doc.text("Vladimir")

    let thugs = Doc.block(title: "Pub Thugs", indent: 2, lines: [thug1, thug2])
    let doc = Doc.block(title: "Tangled",
                        indent: 2,
                        lines: [rapunzel, flynn, thugs, pascal])

    XCTAssertLayout(doc, """
      Tangled
        Rapunzel
        Flynn
        Pub Thugs
          Hook Hand
          Vladimir
        Pascal
      """)
  }

  // MARK: - Common

  func test_common_documents() {
    XCTAssertLayout(.empty, "")

    XCTAssertLayout(.space, " ")
    XCTAssertLayout(.dot, ".")
    XCTAssertLayout(.colon, ":")
    XCTAssertLayout(.comma, ",")
    XCTAssertLayout(.semicolon, ";")

    XCTAssertLayout(.leftParen, "(")
    XCTAssertLayout(.leftSqb, "[")
    XCTAssertLayout(.leftBrace, "{")
    XCTAssertLayout(.rightParen, ")")
    XCTAssertLayout(.rightSqb, "]")
    XCTAssertLayout(.rightBrace, "}")
  }

  func test_common_layout() {
    let spread = Doc.spread(rapunzel, flynn, pascal)
    XCTAssertLayout(spread, "Rapunzel Flynn Pascal")

    let stack = Doc.stack(rapunzel, flynn, pascal)
    XCTAssertLayout(stack, "Rapunzel\nFlynn\nPascal")

    let join = Doc.join([rapunzel, flynn, pascal], with: .colon)
    XCTAssertLayout(join, "Rapunzel:Flynn:Pascal")
  }

  // MARK: - Lyrics

  func test_lyrics_part() {
    let part = Lyrics.iSeeTheLight[0]
    XCTAssertLayout(part.doc, """
      RAPUNZEL
        All those days watching from the windows
        All those years outside looking in
        All that time never even knowing
        Just how blind I've been
        Now I'm here blinking in the starlight
        Now I'm here suddenly I see
        Standing here it's all so clear
        I'm where I'm meant to be
        And at last I see the light
        And it's like the fog has lifted
        And at last I see the light
        And it's like the sky is new
        And it's warm and real and bright
        And the world has somehow shifted
        All at once everything looks different
        Now that I see you
      """)
  }

  // swiftlint:disable:next function_body_length
  func test_lyrics_song() {
    let lyrics = Lyrics.iSeeTheLight
    XCTAssertLayout(lyrics.doc, """
      RAPUNZEL
        All those days watching from the windows
        All those years outside looking in
        All that time never even knowing
        Just how blind I've been
        Now I'm here blinking in the starlight
        Now I'm here suddenly I see
        Standing here it's all so clear
        I'm where I'm meant to be
        And at last I see the light
        And it's like the fog has lifted
        And at last I see the light
        And it's like the sky is new
        And it's warm and real and bright
        And the world has somehow shifted
        All at once everything looks different
        Now that I see you
      FLYNN
        All those days chasing down a daydream
        All those years living in a blur
        All that time never truly seeing
        Things, the way they were
        Now she's here shining in the starlight
        Now she's here suddenly I know
        If she's here it's crystal clear
        I'm where I'm meant to go
      FLYNN & RAPUNZEL
        And at last I see the light
      FLYNN
        And it's like the fog has lifted
      FLYNN & RAPUNZEL
        And at last I see the light
      RAPUNZEL
        And it's like the sky is new
      FLYNN & RAPUNZEL
        And it's warm and real and bright
        And the world has somehow shifted
        All at once everything is different
        Now that I see you
        Now that I see you
      """)
  }
}
