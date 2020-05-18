from testutils import assert_raises

# VIOLET: changed 'RustPython' -> 'Violet'
fd = open('README.md')
# assert 'RustPython' in fd.read()
assert 'Violet' in fd.read()

assert_raises(FileNotFoundError, open, 'DoesNotExist')

# Use open as a context manager
with open('README.md', 'rt') as fp:
    contents = fp.read()
    assert type(contents) == str, "type is " + str(type(contents))

with open('README.md', 'r') as fp:
    contents = fp.read()
    assert type(contents) == str, "type is " + str(type(contents))

# VIOLET: We do not support binary mode
# with open('README.md', 'rb') as fp:
#     contents = fp.read()
#     assert type(contents) == bytes, "type is " + str(type(contents))
