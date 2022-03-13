# https://docs.swift.org/swift-book/ReferenceManual/LexicalStructure.html
KEYWORDS = (
    # Keywords used in declarations:
    'associatedtype', 'class', 'deinit', 'enum', 'extension', 'fileprivate',
    'func', 'import', 'init', 'inout', 'internal', 'let', 'open', 'operator',
    'private', 'precedencegroup', 'protocol', 'public', 'rethrows', 'static',
    'struct', 'subscript', 'typealias', 'var',
    # Keywords used in statements:
    'break', 'case', 'catch', 'continue', 'default', 'defer', 'do', 'else',
    'fallthrough', 'for', 'guard', 'if', 'in', 'repeat', 'return', 'throw',
    'switch',
    'where', 'while',
    # Keywords used in expressions and types:
    'Any', 'as', 'catch', 'false', 'is', 'nil', 'rethrows', 'self', 'Self',
    'super', 'throw', 'throws', 'true', 'try'
    # Keywords used in patterns: _
    # We don't care.
    # Keywords that begin with a number sign (#):
    '#available', '#colorLiteral', '#column', '#dsohandle', '#elseif', '#else',
    '#endif', '#error', '#fileID', '#fileLiteral', '#filePath', '#file',
    '#function', '#if', '#imageLiteral', '#keyPath', '#line', '#selector',
    '#sourceLocation', '#warning',
    # Keywords reserved in particular contexts:
    'associativity', 'convenience', 'didSet', 'dynamic', 'final', 'get',
    'indirect', 'infix', 'lazy', 'left', 'mutating', 'none', 'nonmutating',
    'optional', 'override', 'postfix', 'precedence', 'prefix', 'Protocol',
    'required', 'right', 'set', 'some', 'Type', 'unowned', 'weak', 'willSet'
)

def is_swift_keyword(s: str) -> bool:
    return s in KEYWORDS

def escape_swift_keyword(s: str) -> str:
    if is_swift_keyword(s):
        return '`' + s + '`'

    return s
