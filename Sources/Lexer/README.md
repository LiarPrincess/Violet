# Lexer

Lexer is responsible for transforming Python source code into a stream of tokens.

See “Documentation” directory in `<repository-root>` for more details.

## Important files

- `Lexer.swift` — main type (duh…). Please note that this is more of a “lexical closure” for properties than a proper object-oriented entity. You can’t really talk with it (send messages), you should just create it and then call `getToken` repeatedly.
- `Token.swift` — token definition.
- `LexerType.swift` — protocol describing external `Lexer` interface.
- `Lexer+UNIMPLEMENTED.swift` — things that are not yet implemented.
