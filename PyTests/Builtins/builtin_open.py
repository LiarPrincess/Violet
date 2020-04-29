# from testutils import assert_raises

filename = 'README.md'

fd = open(filename)
assert 'Violet' in fd.read()

# assert_raises(FileNotFoundError, open, 'DoesNotExist')

# Use open as a context manager
with open(filename, 'rt') as fp:
    contents = fp.read()
    assert type(contents) == str, "type is " + str(type(contents))

with open(filename, 'r') as fp:
    contents = fp.read()
    assert type(contents) == str, "type is " + str(type(contents))

# with open(filename, 'rb') as fp:
#     contents = fp.read()
#     assert type(contents) == bytes, "type is " + str(type(contents))
