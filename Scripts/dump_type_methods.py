import inspect
import dump_type_methods_implemented as implemented

def dump(obj):
  for attr in dir(obj):
    print("obj.%s = %r" % (attr, getattr(obj, attr)))

for t in implemented.types:
  print(t.__name__)

  doc = None
  own_implemented = []
  own_unimplemented = []
  derived_members = []
  implemented_methods = implemented.types[t]

  for name, member in inspect.getmembers(t):
    if name == '__class__':
      continue
    elif name == '__doc__':
      doc = member
    elif hasattr(member, '__objclass__'):
      if member.__objclass__ == t:
        if member.__name__ in implemented_methods:
          own_implemented.append(member)
        else:
          own_unimplemented.append(member)
      else:
        derived_members.append(member)
    else:
      # print(' ', name, '-', type(member))
      pass

  implemented_extra = []
  own_member_names = list(map(lambda m: m.__name__, own_implemented + own_unimplemented))
  for m in implemented_methods:
    if not (m in own_member_names):
      implemented_extra.append(m)

  print_own_members = 1
  print_derived_members = 0

  if print_own_members:
    if own_implemented:
      print('  Implemented:')
      for m in own_implemented:
        doc = '' # if m.__doc__ is None else '"' + m.__doc__ + '"'
        print('   ', m.__name__)

    if own_unimplemented:
      print('  Unimplemented:')
      for m in own_unimplemented:
        print('   ', m.__name__)

    if implemented_extra:
      print('  Please remind me why do we even have this method?')
      for m in implemented_extra:
        print('   ', m)

  if print_derived_members:
    print('  Derived members:')
    for m in derived_members:
      owner = m.__objclass__.__name__
      print('   ', m.__name__, 'from', owner)

  print()
