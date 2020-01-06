import Rapunzel

struct Part {
  let character: String
  let lines: [String]
}

typealias Lyrics = [Part]

// MARK: - Rapunzel

extension Lyrics: RapunzelConvertible {
  public var doc: Doc {
    return self.stack()
  }
}

extension Part: RapunzelConvertible {
  var doc: Doc {
    let lines = self.lines.map(Doc.text)
    return Doc.block(title: self.character, indent: 2, lines: lines)
  }
}

// MARK: - I See the Light

extension Lyrics {

  /// '[I See the Light](https://www.youtube.com/watch?v=fKPK6c0mKE0)'
  /// from 'Tangled'.
  ///
  /// Source: https://genius.com/Walt-disney-records-i-see-the-light-lyrics
  static var iSeeTheLight: Lyrics {
    return [
      Part(
        character: "RAPUNZEL",
        lines: [
          "All those days watching from the windows",
          "All those years outside looking in",
          "All that time never even knowing",
          "Just how blind I've been",
          "Now I'm here blinking in the starlight",
          "Now I'm here suddenly I see",
          "Standing here it's all so clear",
          "I'm where I'm meant to be",

          "And at last I see the light",
          "And it's like the fog has lifted",
          "And at last I see the light",
          "And it's like the sky is new",
          "And it's warm and real and bright",
          "And the world has somehow shifted",
          "All at once everything looks different",
          "Now that I see you"
        ]
      ),

      // Rapunzel gives crown to Flynn
      // They ignite 2 sky-lanterns

      Part(
        character: "FLYNN",
        lines: [
          "All those days chasing down a daydream",
          "All those years living in a blur",
          "All that time never truly seeing",
          "Things, the way they were",
          "Now she's here shining in the starlight",
          "Now she's here suddenly I know",
          "If she's here it's crystal clear",
          "I'm where I'm meant to go"
        ]
      ),
      Part(
        character: "FLYNN & RAPUNZEL",
        lines: ["And at last I see the light"]
      ),
      Part(
        character: "FLYNN",
        lines: ["And it's like the fog has lifted"]
      ),
      Part(
        character: "FLYNN & RAPUNZEL",
        lines: ["And at last I see the light"]
      ),
      Part(
        character: "RAPUNZEL",
        lines: ["And it's like the sky is new"]
      ),
      Part(
        character: "FLYNN & RAPUNZEL",
        lines: [
          "And it's warm and real and bright",
          "And the world has somehow shifted",
          "All at once everything is different",
          "Now that I see you",

          "Now that I see you"
        ]
      )
    ]
  }
}
