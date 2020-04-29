# Empty init where compare with builtins is possible
assert bytes() == b''
assert complex() == 0j
assert dict() == {}
assert float() == 0.0
assert int() == 0
assert list() == []
assert property()
assert str() == ''
assert tuple() == ()
assert bool() == False

# Empty init
assert isinstance(bytearray(), bytearray)
assert isinstance(frozenset(), frozenset)
assert isinstance(set(), set)
assert isinstance(zip(), zip)

# Those types require arguments
# classmethod()
# enumerate()
# filter()
# map()
# range()
# reversed()
# slice()
# staticmethod()
# super()

# Those types do not have '__init__' (or require 'import types')
# builtinMethod
# builtinFunction
# bytearray_iterator
# bytes_iterator
# callable_iterator
# cell
# code
# dict_itemiterator
# dict_items
# dict_keyiterator
# dict_keys
# dict_valueiterator
# dict_values
# ellipsis
# frame
# function
# iterator
# list_iterator
# list_reverseiterator
# method
# module
# types
# NoneType
# NotImplementedType
# range_iterator
# set_iterator
# str_iterator
# TextFile
# traceback
# tuple_iterator
