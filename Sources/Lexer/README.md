# Lexer

Lexer is responsible for transforming Python source code to stream of tokens.

## Important files

- `Lexer.swift` - main type (duh…). Please note that this is is more of a “lexical closure” for properties than a proper object-oriented entity.
- `Token.swift` and `TokenKind.swift` - token definitions.
- `LexerType.swift` - protocol describing external Lexer interface.
- `Lexer+UNIMPLEMENTED.swift` - things that are not yet implemented.

## CPython

- [docs.python.org/lexical_analysis](https://docs.python.org/3/reference/lexical_analysis.html)
- Github
  - [Include/token.h](https://github.com/python/cpython/blob/3.6/Include/token.h)
  - [Parser/tokenizer.c](https://github.com/python/cpython/blob/3.6/Parser/tokenizer.c)
