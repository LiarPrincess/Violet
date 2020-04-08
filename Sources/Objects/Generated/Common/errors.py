where_to_find_it_in_cpython = '''\
// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/library/exceptions.html
// https://docs.python.org/3.7/c-api/exceptions.html\
'''

def get_builtins_type_property_name(name):
  if name == 'OSError':
    return 'osError'

  if name == 'EOFError':
    return 'eofError'

  return name[0].lower() + name[1:]
